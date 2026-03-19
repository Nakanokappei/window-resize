// WindowTracker.swift — Core drag tracking engine that monitors mouse events
// globally to detect window resize operations. When a window is resized near
// a preset size, shows an overlay preview and snaps to it on release.
//
// Architecture:
// - NSEvent global monitors detect drag start/move/end
// - CGWindowListCopyWindowInfo polling identifies which window changed
// - SnapDetector determines if a snap should trigger
// - OverlayWindowController shows the preview
// - SnapExecutor applies the snap via AXUIElement

import AppKit

/// The corner of the window being dragged during a resize operation.
/// Used to position the size labels relative to the user's mouse.
enum DragCorner {
    case topLeft, topRight, bottomLeft, bottomRight
}

class WindowTracker {

    // MARK: - Event Monitors

    /// Global monitor for mouse drag events (fires for drags in all apps).
    private var dragMonitor: Any?

    /// Global monitor for mouse-up events (detects drag end).
    private var upMonitor: Any?

    // MARK: - Drag State

    /// Snapshot of all window frames at drag start, keyed by CGWindowID.
    /// Used as baseline to detect which window changed and how.
    private var initialFrames: [CGWindowID: CGRect] = [:]

    /// True while a mouse drag is in progress.
    private var isDragging = false

    /// The window currently being dragged (identified by frame delta).
    private var trackedWindow: WindowInfo?

    /// Whether the current drag is a resize (size changed vs position only).
    private var isResizing = false

    /// Which corner of the window is being dragged (resize only).
    private var dragCorner: DragCorner = .bottomRight

    /// The current snap candidate, if any. Set during drag, consumed on release.
    private var currentCandidate: SnapCandidate?

    /// The aspect ratio (width/height) at the start of the resize drag.
    /// Used to constrain proportions when Shift is held.
    private var initialAspectRatio: CGFloat = 0

    // MARK: - Overlay

    private let overlay = OverlayWindowController()

    // MARK: - Throttling

    /// Minimum interval between CGWindowList polls (seconds).
    /// Polling too frequently wastes CPU; too infrequently misses snap opportunities.
    private static let pollInterval: TimeInterval = 0.05

    /// Timestamp of the last CGWindowList poll.
    private var lastPollTime: TimeInterval = 0

    // MARK: - Lifecycle

    /// Installs global event monitors to begin tracking window drags.
    /// Call once at app launch from applicationDidFinishLaunching.
    func start() {
        installDragMonitor()
        installUpMonitor()
    }

    /// Removes event monitors. Call when the app is terminating.
    func stop() {
        if let monitor = dragMonitor {
            NSEvent.removeMonitor(monitor)
            dragMonitor = nil
        }
        if let monitor = upMonitor {
            NSEvent.removeMonitor(monitor)
            upMonitor = nil
        }
        overlay.hide()
    }

    // MARK: - Event Monitor Installation

    /// Monitors leftMouseDragged events from all applications.
    /// On the first drag event, takes a frame snapshot. On subsequent events,
    /// polls CGWindowList to detect the dragged window and check for snap candidates.
    private func installDragMonitor() {
        dragMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDragged) { [weak self] event in
            guard let self = self else { return }

            if !self.isDragging {
                // First drag event: snapshot all window frames as baseline.
                self.isDragging = true
                self.trackedWindow = nil
                self.currentCandidate = nil
                self.snapshotWindowFrames()
                return
            }

            // Throttle CGWindowList polling to avoid excessive CPU usage.
            let now = ProcessInfo.processInfo.systemUptime
            guard now - self.lastPollTime >= Self.pollInterval else { return }
            self.lastPollTime = now

            self.processDragEvent(event)
        }
    }

    /// Monitors leftMouseUp events to detect the end of a drag.
    /// If a snap candidate is active, executes the snap.
    private func installUpMonitor() {
        upMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseUp) { [weak self] event in
            guard let self = self, self.isDragging else { return }
            self.isDragging = false

            // Execute snap if a candidate was active when the user released.
            // Record the pre-snap frame for undo support.
            if let candidate = self.currentCandidate, let window = self.trackedWindow {
                ResizeHistory.shared.pushState(windowID: window.windowID, frame: window.bounds)
                _ = SnapExecutor.execute(windowInfo: window, targetFrame: candidate.targetFrame)
            }

            // Clean up drag state.
            self.overlay.hide()
            self.trackedWindow = nil
            self.currentCandidate = nil
            self.initialFrames.removeAll()
        }
    }

    // MARK: - Drag Processing

    /// Core drag processing: identifies the dragged window and checks for
    /// resize snap candidates. Move drags are ignored (macOS provides native
    /// edge/corner snapping since Sequoia).
    private func processDragEvent(_ event: NSEvent) {
        let currentWindows = WindowManager.discoverWindows()

        // If we haven't identified the dragged window yet, find it by
        // comparing current frames against the snapshot.
        if trackedWindow == nil {
            identifyDraggedWindow(currentWindows: currentWindows)
        }

        // Only process resize drags — ignore window moves entirely.
        guard isResizing else { return }

        // If we still can't identify the window, refresh the snapshot and bail.
        guard let tracked = trackedWindow else {
            snapshotWindowFrames()
            return
        }

        // Find the tracked window's current frame in the latest poll.
        guard let currentInfo = currentWindows.first(where: { $0.windowID == tracked.windowID }) else {
            return
        }

        // Update the tracked window with its latest frame data.
        trackedWindow = currentInfo

        // When Shift is held and the setting is enabled, constrain the resize
        // to the initial aspect ratio.
        var effectiveBounds = currentInfo.bounds
        let shiftHeld = event.modifierFlags.contains(.shift)
        if shiftHeld && initialAspectRatio > 0 && SettingsStore.shared.shiftToLockRatio {
            effectiveBounds = constrainToAspectRatio(
                currentFrame: currentInfo.bounds,
                initialFrame: initialFrames[tracked.windowID] ?? currentInfo.bounds,
                ratio: initialAspectRatio,
                corner: dragCorner
            )
            // Apply the constrained size to the actual window.
            _ = SnapExecutor.execute(windowInfo: currentInfo, targetFrame: effectiveBounds)
        }

        // Detect snap candidate: check proximity to preset sizes.
        let allPresets = SettingsStore.shared.allPresets
        let candidate = SnapDetector.detectResizeSnap(
            currentFrame: effectiveBounds,
            presets: allPresets
        )

        // Update overlay visibility based on candidate state.
        if let candidate = candidate {
            currentCandidate = candidate

            // Build the label from the matched preset.
            var label = "\(candidate.preset.width) × \(candidate.preset.height)"
            if let name = candidate.preset.label, !name.isEmpty { label += "  \(name)" }

            overlay.show(at: candidate.targetFrame, label: label,
                         dragCorner: dragCorner, currentSize: effectiveBounds.size)
        } else {
            // No snap candidate — show resize overlay only if the user hasn't disabled it.
            currentCandidate = nil
            if SettingsStore.shared.showResizeOverlay {
                overlay.show(at: effectiveBounds, label: nil,
                             dragCorner: dragCorner, currentSize: effectiveBounds.size)
            } else {
                overlay.hide()
            }
        }
    }

    /// Scans all windows to find which one changed relative to the snapshot.
    /// Classifies the change as resize or move based on whether size or
    /// position changed. For resize, determines which corner is being dragged
    /// by comparing which edges moved.
    private func identifyDraggedWindow(currentWindows: [WindowInfo]) {
        for window in currentWindows {
            guard let initialFrame = initialFrames[window.windowID] else { continue }

            let sizeChanged = abs(window.bounds.width - initialFrame.width) > 3
                           || abs(window.bounds.height - initialFrame.height) > 3
            let posChanged = abs(window.bounds.origin.x - initialFrame.origin.x) > 3
                          || abs(window.bounds.origin.y - initialFrame.origin.y) > 3

            if sizeChanged {
                trackedWindow = window
                isResizing = true

                // Record the initial aspect ratio for Shift-constrained resize.
                if initialFrame.height > 0 {
                    initialAspectRatio = initialFrame.width / initialFrame.height
                }

                // Determine which corner is being dragged by checking which
                // edges moved relative to the initial frame.
                let topMoved = abs(window.bounds.minY - initialFrame.minY) > 3
                let leftMoved = abs(window.bounds.minX - initialFrame.minX) > 3
                let bottomMoved = abs(window.bounds.maxY - initialFrame.maxY) > 3
                let rightMoved = abs(window.bounds.maxX - initialFrame.maxX) > 3

                if topMoved && leftMoved { dragCorner = .topLeft }
                else if topMoved && rightMoved { dragCorner = .topRight }
                else if topMoved { dragCorner = .topRight }
                else if bottomMoved && leftMoved { dragCorner = .bottomLeft }
                else if leftMoved { dragCorner = .bottomLeft }
                else if bottomMoved && rightMoved { dragCorner = .bottomRight }
                else { dragCorner = .bottomRight }

                return
            } else if posChanged {
                trackedWindow = window
                isResizing = false
                return
            }
        }
    }

    // MARK: - Aspect Ratio Constraint

    /// Constrains a resized frame to maintain the given aspect ratio (width/height).
    /// Determines whether to adjust width or height based on which dimension
    /// changed more relative to the initial frame, then anchors the opposite
    /// edges to the initial frame based on the drag corner.
    private func constrainToAspectRatio(currentFrame: CGRect, initialFrame: CGRect,
                                         ratio: CGFloat, corner: DragCorner) -> CGRect {
        let dw = abs(currentFrame.width - initialFrame.width)
        let dh = abs(currentFrame.height - initialFrame.height)

        var newWidth: CGFloat
        var newHeight: CGFloat

        // Use the dimension that changed more as the driver.
        if dw >= dh {
            newWidth = currentFrame.width
            newHeight = newWidth / ratio
        } else {
            newHeight = currentFrame.height
            newWidth = newHeight * ratio
        }

        // Round to whole pixels.
        newWidth = round(newWidth)
        newHeight = round(newHeight)

        // Anchor the frame based on the drag corner.
        // The corner opposite to the drag stays fixed.
        var origin = currentFrame.origin
        switch corner {
        case .bottomRight:
            // Top-left is fixed.
            break
        case .bottomLeft:
            // Top-right is fixed: adjust origin.x so right edge stays.
            origin.x = initialFrame.maxX - newWidth
        case .topRight:
            // Bottom-left is fixed: adjust origin.y so bottom edge stays.
            origin.y = initialFrame.maxY - newHeight
        case .topLeft:
            // Bottom-right is fixed: adjust both origin.x and origin.y.
            origin.x = initialFrame.maxX - newWidth
            origin.y = initialFrame.maxY - newHeight
        }

        return CGRect(x: origin.x, y: origin.y, width: newWidth, height: newHeight)
    }

    // MARK: - Snapshot

    /// Captures a snapshot of all on-screen window frames to use as baseline
    /// for detecting changes during the current drag operation.
    private func snapshotWindowFrames() {
        initialFrames.removeAll()
        for window in WindowManager.discoverWindows() {
            initialFrames[window.windowID] = window.bounds
        }
    }
}
