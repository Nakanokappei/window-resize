// WindowTracker.swift — Core drag tracking engine that monitors mouse events
// globally to detect window resize and move operations. When a snap candidate
// is detected, shows/hides the overlay preview and executes the snap on release.
//
// Architecture:
// - NSEvent global monitors detect drag start/move/end
// - CGWindowListCopyWindowInfo polling identifies which window changed
// - SnapDetector determines if a snap should trigger
// - OverlayWindowController shows the preview
// - SnapExecutor applies the snap via AXUIElement

import AppKit

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

    /// Whether the current drag is a resize (true) or move (false).
    private var isResizing = false

    /// The current snap candidate, if any. Set during drag, consumed on release.
    private var currentCandidate: SnapCandidate?

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
            if let candidate = self.currentCandidate, let window = self.trackedWindow {
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

    /// Core drag processing: identifies the dragged window, determines if it's
    /// a resize or move, and checks for snap candidates.
    private func processDragEvent(_ event: NSEvent) {
        let currentWindows = WindowManager.discoverWindows()

        // If we haven't identified the dragged window yet, find it by
        // comparing current frames against the snapshot.
        if trackedWindow == nil {
            identifyDraggedWindow(currentWindows: currentWindows)
        }

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

        // Detect snap candidate based on drag type.
        let candidate: SnapCandidate?
        let allPresets = SettingsStore.shared.allPresets

        if isResizing {
            // During resize: check proximity to preset sizes.
            candidate = SnapDetector.detectResizeSnap(
                currentFrame: currentInfo.bounds,
                presets: allPresets
            )
        } else {
            // During move: check proximity to screen edges/corners.
            // Pass the window's current size so edge/corner snaps preserve dimensions.
            let mouseNS = NSEvent.mouseLocation
            let mouseCG = ScreenGeometry.nsPointToCG(mouseNS)
            if let screen = ScreenGeometry.screenContaining(cgPoint: mouseCG) {
                candidate = SnapDetector.detectMoveSnap(
                    mouseInCG: mouseCG, screen: screen,
                    windowSize: currentInfo.bounds.size
                )
            } else {
                candidate = nil
            }
        }

        // Update overlay visibility based on candidate state.
        if let candidate = candidate {
            currentCandidate = candidate

            // Build the primary overlay label from the snap candidate.
            let primaryLabel: String?
            if case .presetSize(let preset, _) = candidate {
                var label = "\(preset.width) × \(preset.height)"
                if let name = preset.label, !name.isEmpty { label += "  \(name)" }
                primaryLabel = label
            } else {
                primaryLabel = nil
            }

            overlay.show(at: candidate.targetFrame, label: primaryLabel)
        } else {
            currentCandidate = nil
            overlay.hide()
        }

        // During resize, show dashed-border overlays for nearby presets
        // so the user can see where to drag to reach other preset sizes.
        if isResizing && candidate != nil {
            let nearby = SnapDetector.detectNearbyPresets(
                currentFrame: currentInfo.bounds,
                presets: allPresets
            )

            // Determine which preset is the primary snap candidate.
            let primaryPresetID: UUID? = {
                if case .presetSize(let preset, _) = candidate {
                    return preset.id
                }
                return nil
            }()

            // Build entries with target frames. For resize snaps, each preset's
            // overlay shares the window's current origin with the preset dimensions.
            let windowOrigin = currentInfo.bounds.origin
            let entries: [SizeHintEntry] = nearby.map { item in
                let targetFrame = CGRect(
                    x: windowOrigin.x,
                    y: windowOrigin.y,
                    width: CGFloat(item.preset.width),
                    height: CGFloat(item.preset.height)
                )
                return SizeHintEntry(
                    preset: item.preset,
                    distance: item.distance,
                    isPrimary: item.preset.id == primaryPresetID,
                    targetFrame: targetFrame
                )
            }

            overlay.showSecondaryOverlays(entries)
        } else {
            overlay.hideSecondaryOverlays()
        }
    }

    /// Scans all windows to find which one changed relative to the snapshot.
    /// Classifies the change as resize or move based on whether size or
    /// position changed.
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
                return
            } else if posChanged {
                trackedWindow = window
                isResizing = false
                return
            }
        }
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
