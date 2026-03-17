// OverlayWindowController.swift — Manages snap preview overlays:
// 1. Primary overlay: solid white border at the snap target frame, with a
//    size label inside the top-right corner.
// 2. Secondary overlays: dashed borders at other nearby preset sizes, so
//    the user can see where to drag next. Each has a small size label.
// All overlays ignore mouse events and float above other windows.

import AppKit

/// Information about a nearby preset for overlay display.
/// Includes whether this preset is the active snap candidate (primary).
struct SizeHintEntry {
    let preset: PresetSize
    let distance: CGFloat
    let isPrimary: Bool
    /// Target frame in CG coordinates (top-left origin). For resize snaps,
    /// this shares the window's origin with the preset's dimensions.
    let targetFrame: CGRect
}

class OverlayWindowController {

    /// The primary overlay window (solid white border).
    private var primaryWindow: NSWindow?
    private var primaryBorderView: OverlayBorderView?
    private var primaryLabelView: OverlaySizeLabelView?

    /// Pool of secondary overlay windows (dashed borders) for nearby presets.
    /// Reused across frames to avoid allocation churn during rapid polling.
    private var secondaryWindows: [(window: NSWindow, borderView: DashedBorderView, labelView: OverlaySizeLabelView)] = []

    /// Number of secondary overlays currently in use (rest are hidden).
    private var activeSecondaryCount = 0

    /// The primary frame currently displayed (in CG coordinates).
    /// Tracked to avoid redundant updates during rapid polling.
    private var currentPrimaryFrame: CGRect = .zero

    // MARK: - Primary Overlay (Solid Border)

    /// Shows the primary overlay at the specified frame (CG coordinates, top-left origin).
    /// Displays a solid white border with a size label inside.
    func show(at targetFrame: CGRect, label: String? = nil) {
        // Skip update if the frame hasn't changed significantly.
        if primaryWindow != nil && framesAreClose(currentPrimaryFrame, targetFrame) {
            // Still update label if provided.
            if let label = label { primaryLabelView?.update(text: label) }
            return
        }
        currentPrimaryFrame = targetFrame

        let nsFrame = cgRectToNS(targetFrame)

        if primaryWindow == nil {
            createPrimaryWindow(frame: nsFrame)
        }

        guard let window = primaryWindow else { return }

        // Update the size label.
        if let label = label {
            primaryLabelView?.update(text: label)
            primaryLabelView?.isHidden = false
        } else {
            primaryLabelView?.isHidden = true
        }

        // Animate the frame change for smooth transitions.
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.15
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            window.animator().setFrame(nsFrame, display: true)
        }

        if !window.isVisible {
            window.alphaValue = 0
            window.orderFrontRegardless()
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.2
                window.animator().alphaValue = 1.0
            }
        }
    }

    // MARK: - Secondary Overlays (Dashed Borders)

    /// Shows dashed-border overlays for nearby presets. Each entry's targetFrame
    /// is in CG coordinates. Entries marked isPrimary are skipped (handled by
    /// the solid primary overlay). Reuses a pool of NSWindows.
    func showSecondaryOverlays(_ entries: [SizeHintEntry]) {
        // Filter out the primary (already shown as solid border).
        let secondaries = entries.filter { !$0.isPrimary }

        // Ensure we have enough windows in the pool.
        while secondaryWindows.count < secondaries.count {
            secondaryWindows.append(createSecondaryWindow())
        }

        // Position and show each secondary overlay.
        for (index, entry) in secondaries.enumerated() {
            let item = secondaryWindows[index]
            let nsFrame = cgRectToNS(entry.targetFrame)

            // Build label: "1920 × 1080  Full HD"
            let label = buildSizeLabel(entry.preset)
            item.labelView.update(text: label)

            item.window.setFrame(nsFrame, display: true)

            if !item.window.isVisible {
                item.window.alphaValue = 0
                item.window.orderFrontRegardless()
                NSAnimationContext.runAnimationGroup { context in
                    context.duration = 0.15
                    item.window.animator().alphaValue = 1.0
                }
            }
        }

        // Hide any excess windows from the pool.
        for index in secondaries.count..<secondaryWindows.count {
            let item = secondaryWindows[index]
            if item.window.isVisible {
                item.window.orderOut(nil)
            }
        }

        activeSecondaryCount = secondaries.count
    }

    /// Hides all secondary overlays.
    func hideSecondaryOverlays() {
        for item in secondaryWindows where item.window.isVisible {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.1
                item.window.animator().alphaValue = 0
            }, completionHandler: {
                item.window.orderOut(nil)
            })
        }
        activeSecondaryCount = 0
    }

    // MARK: - Hide All

    /// Hides all overlays (primary + secondary) with a fade-out animation.
    func hide() {
        currentPrimaryFrame = .zero

        if let window = primaryWindow, window.isVisible {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.15
                window.animator().alphaValue = 0
            }, completionHandler: { [weak self] in
                self?.primaryWindow?.orderOut(nil)
            })
        }

        hideSecondaryOverlays()
    }

    /// Returns true if the primary overlay is currently visible.
    var isVisible: Bool {
        primaryWindow?.isVisible ?? false
    }

    // MARK: - Window Creation

    /// Creates the primary overlay window with a solid white border and size label.
    private func createPrimaryWindow(frame: NSRect) {
        let window = makeBaseWindow(frame: frame)

        let borderView = OverlayBorderView(frame: window.contentView!.bounds)
        borderView.autoresizingMask = [.width, .height]
        window.contentView?.addSubview(borderView)

        // Size label positioned at top-right inside the overlay.
        let labelView = OverlaySizeLabelView(frame: NSRect(x: 0, y: 0, width: 200, height: 28))
        labelView.autoresizingMask = [.minXMargin, .minYMargin]
        labelView.isPrimary = true
        window.contentView?.addSubview(labelView)

        self.primaryBorderView = borderView
        self.primaryLabelView = labelView
        self.primaryWindow = window
    }

    /// Creates a secondary overlay window with a dashed border and size label.
    private func createSecondaryWindow() -> (window: NSWindow, borderView: DashedBorderView, labelView: OverlaySizeLabelView) {
        let window = makeBaseWindow(frame: NSRect(x: 0, y: 0, width: 200, height: 200))

        let borderView = DashedBorderView(frame: window.contentView!.bounds)
        borderView.autoresizingMask = [.width, .height]
        window.contentView?.addSubview(borderView)

        let labelView = OverlaySizeLabelView(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        labelView.autoresizingMask = [.minXMargin, .minYMargin]
        labelView.isPrimary = false
        window.contentView?.addSubview(labelView)

        return (window: window, borderView: borderView, labelView: labelView)
    }

    /// Creates a base floating, non-interactive, transparent NSWindow.
    private func makeBaseWindow(frame: NSRect) -> NSWindow {
        let window = NSWindow(
            contentRect: frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.level = .floating
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false
        window.ignoresMouseEvents = true
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        return window
    }

    // MARK: - Helpers

    /// Builds a display string like "1920 × 1080  Full HD".
    private func buildSizeLabel(_ preset: PresetSize) -> String {
        var text = "\(preset.width) × \(preset.height)"
        if let label = preset.label, !label.isEmpty {
            text += "  \(label)"
        }
        return text
    }

    /// Converts a CGRect from CG coordinates (top-left origin) to NSScreen
    /// coordinates (bottom-left origin) for NSWindow positioning.
    private func cgRectToNS(_ cgRect: CGRect) -> NSRect {
        let primaryHeight = ScreenGeometry.primaryScreenHeight
        return NSRect(
            x: cgRect.origin.x,
            y: primaryHeight - cgRect.origin.y - cgRect.height,
            width: cgRect.width,
            height: cgRect.height
        )
    }

    /// Returns true if two frames are close enough to skip an update.
    private func framesAreClose(_ a: CGRect, _ b: CGRect) -> Bool {
        return abs(a.origin.x - b.origin.x) < 1
            && abs(a.origin.y - b.origin.y) < 1
            && abs(a.width - b.width) < 1
            && abs(a.height - b.height) < 1
    }
}

// MARK: - OverlayBorderView (Solid)

/// Draws a solid rounded white border with a semi-transparent fill.
/// Used for the primary snap candidate overlay.
private class OverlayBorderView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let insetRect = bounds.insetBy(dx: 4, dy: 4)
        let path = NSBezierPath(roundedRect: insetRect, xRadius: 8, yRadius: 8)

        // Semi-transparent white fill.
        NSColor.white.withAlphaComponent(0.15).setFill()
        path.fill()

        // Solid white border.
        NSColor.white.withAlphaComponent(0.6).setStroke()
        path.lineWidth = 3.0
        path.stroke()
    }
}

// MARK: - DashedBorderView

/// Draws a dashed rounded border for secondary (nearby) preset overlays.
/// Dimmer than the primary overlay to indicate they are not the active snap.
private class DashedBorderView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let insetRect = bounds.insetBy(dx: 4, dy: 4)
        let path = NSBezierPath(roundedRect: insetRect, xRadius: 8, yRadius: 8)

        // Subtle fill to distinguish from background.
        NSColor.white.withAlphaComponent(0.05).setFill()
        path.fill()

        // Dashed white border with moderate opacity.
        NSColor.white.withAlphaComponent(0.35).setStroke()
        path.lineWidth = 2.0
        let dashPattern: [CGFloat] = [8, 6]
        path.setLineDash(dashPattern, count: dashPattern.count, phase: 0)
        path.stroke()
    }
}

// MARK: - OverlaySizeLabelView

/// A small label drawn at the top-right of an overlay window, showing the
/// preset size (e.g. "1920 × 1080  Full HD") on a dark pill-shaped background.
private class OverlaySizeLabelView: NSView {

    /// True for the primary (snap candidate) — bolder, more opaque.
    var isPrimary: Bool = true

    private var text: String = ""

    func update(text: String) {
        self.text = text
        needsDisplay = true
        // Resize to fit the text content, then reposition to top-right.
        sizeToFitText()
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard !text.isEmpty else { return }

        let attrs = textAttributes()
        let textSize = (text as NSString).size(withAttributes: attrs)

        let paddingH: CGFloat = 8
        let paddingV: CGFloat = 4
        let pillWidth = textSize.width + paddingH * 2
        let pillHeight = textSize.height + paddingV * 2

        // Draw pill-shaped background.
        let pillRect = NSRect(x: 0, y: 0, width: pillWidth, height: pillHeight)
        let pillPath = NSBezierPath(roundedRect: pillRect, xRadius: pillHeight / 2, yRadius: pillHeight / 2)
        let bgAlpha: CGFloat = isPrimary ? 0.8 : 0.6
        NSColor.black.withAlphaComponent(bgAlpha).setFill()
        pillPath.fill()

        // Draw text centered in the pill.
        let textRect = NSRect(x: paddingH, y: paddingV - 1, width: textSize.width, height: textSize.height)
        (text as NSString).draw(in: textRect, withAttributes: attrs)
    }

    private func textAttributes() -> [NSAttributedString.Key: Any] {
        let fontSize: CGFloat = isPrimary ? 12 : 10
        let weight: NSFont.Weight = isPrimary ? .bold : .regular
        let alpha: CGFloat = isPrimary ? 1.0 : 0.8

        return [
            .font: NSFont.monospacedDigitSystemFont(ofSize: fontSize, weight: weight),
            .foregroundColor: NSColor.white.withAlphaComponent(alpha)
        ]
    }

    /// Resize to fit the current text and reposition to the top-right
    /// corner of the superview (the overlay window's content view).
    private func sizeToFitText() {
        let attrs = textAttributes()
        let textSize = (text as NSString).size(withAttributes: attrs)
        let paddingH: CGFloat = 8
        let paddingV: CGFloat = 4
        let newWidth = textSize.width + paddingH * 2
        let newHeight = textSize.height + paddingV * 2

        guard let superview = superview else {
            frame.size = NSSize(width: newWidth, height: newHeight)
            return
        }

        // Position at top-right of superview, inset from edges.
        let margin: CGFloat = 10
        frame = NSRect(
            x: superview.bounds.maxX - newWidth - margin,
            y: superview.bounds.maxY - newHeight - margin,
            width: newWidth,
            height: newHeight
        )
    }

    /// Reposition when the superview (overlay window) resizes.
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        sizeToFitText()
    }

    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        // Observe parent resizes to keep label in top-right.
        postsFrameChangedNotifications = true
    }

    override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
    }
}
