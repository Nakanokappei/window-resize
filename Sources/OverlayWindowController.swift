// OverlayWindowController.swift — Manages the snap/resize preview overlay:
//
// During a window resize, this controller displays a floating overlay that
// exactly covers the window being resized. The overlay has three visual layers:
//
// 1. OverlayBorderView — A rounded border (solid or dashed, color configurable
//    in Settings) with a semi-transparent fill. Also draws the aspect ratio
//    label at the corner diagonally opposite from the drag.
//
// 2. CornerSizeLabelView — A dark pill at the drag corner showing:
//    - Line 1 (large bold): snap target size (only when a preset match is found)
//    - Line 2 (small): current window dimensions (always shown during resize)
//
// All overlays ignore mouse events and float above other windows.

import AppKit

class OverlayWindowController {

    // MARK: - Properties

    /// The primary overlay window, created once and reused across drag sessions.
    private var primaryWindow: NSWindow?

    /// Border + ratio label view (first subview of the overlay window).
    private var primaryBorderView: OverlayBorderView?

    /// Size label view at the drag corner (second subview of the overlay window).
    private var sizeLabelView: CornerSizeLabelView?

    /// The primary frame currently displayed (in CG coordinates).
    /// Tracked to avoid redundant updates during rapid polling.
    private var currentPrimaryFrame: CGRect = .zero

    // MARK: - Show

    /// Shows the primary overlay at the specified frame (CG coordinates, top-left origin).
    ///
    /// - Parameters:
    ///   - targetFrame: The window frame to overlay (CG coords).
    ///   - label: Snap target description (e.g. "1280 × 720  HD"). Nil when no snap.
    ///   - dragCorner: Which corner the user is dragging.
    ///   - currentSize: The window's actual current dimensions.
    func show(at targetFrame: CGRect, label: String? = nil,
              dragCorner: DragCorner? = nil, currentSize: CGSize? = nil) {
        let nsFrame = cgRectToNS(targetFrame)

        // Create the overlay window on first use.
        if primaryWindow == nil {
            createPrimaryWindow(frame: nsFrame)
        }

        guard let window = primaryWindow else { return }

        // Read the user's overlay appearance preferences.
        let settings = SettingsStore.shared
        let corner = dragCorner ?? .topRight

        // Format the current size as "W × H" for display.
        let currentSizeText: String? = currentSize.map {
            "\(Int($0.width)) × \(Int($0.height))"
        }

        // Configure border style and size label based on snap state.
        if let label = label {
            // Snap candidate active: apply snap overlay settings.
            let color = SettingsStore.nsColor(forName: settings.snapBorderColor)
            primaryBorderView?.updateStyle(color: color, dashed: settings.snapBorderDashed)
            sizeLabelView?.update(snapText: label, currentSizeText: currentSizeText, corner: corner)
            sizeLabelView?.isHidden = false
        } else if let currentSizeText = currentSizeText {
            // No snap candidate: apply resize overlay settings.
            let color = SettingsStore.nsColor(forName: settings.resizeBorderColor)
            primaryBorderView?.updateStyle(color: color, dashed: settings.resizeBorderDashed)
            sizeLabelView?.update(snapText: "", currentSizeText: currentSizeText, corner: corner)
            sizeLabelView?.isHidden = false
        } else {
            sizeLabelView?.isHidden = true
        }

        // Update the aspect ratio label at the opposite corner from the drag.
        if settings.showRatioLabel,
           let size = currentSize, size.width > 0 && size.height > 0 {
            let ratioText = AspectRatioFormatter.format(width: size.width, height: size.height)
            primaryBorderView?.updateRatio(text: ratioText, corner: oppositeCorner(corner))
        } else {
            primaryBorderView?.updateRatio(text: "", corner: .topLeft)
        }

        // Update the overlay window frame to match the target.
        if !framesAreClose(currentPrimaryFrame, targetFrame) {
            currentPrimaryFrame = targetFrame

            if label != nil {
                // Snap candidate active: animate the frame transition smoothly.
                NSAnimationContext.runAnimationGroup { context in
                    context.duration = 0.15
                    context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                    window.animator().setFrame(nsFrame, display: true)
                }
            } else {
                // No snap candidate: follow the resize immediately without animation.
                window.setFrame(nsFrame, display: true)
            }
        }

        // Ensure the overlay is visible and fully opaque.
        if !window.isVisible {
            window.orderFrontRegardless()
        }
        window.alphaValue = 1.0
    }

    // MARK: - Hide

    /// Hides the overlay with a short fade-out animation.
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
    }

    // MARK: - Window Creation

    /// Creates the primary overlay window with its two subviews:
    /// the border/ratio view and the size label view.
    private func createPrimaryWindow(frame: NSRect) {
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

        // Layer 1: border + aspect ratio pill.
        let borderView = OverlayBorderView(frame: window.contentView!.bounds)
        borderView.autoresizingMask = [.width, .height]
        window.contentView?.addSubview(borderView)

        // Layer 2: size label pill at the drag corner.
        let sizeLabel = CornerSizeLabelView(frame: window.contentView!.bounds)
        sizeLabel.autoresizingMask = [.width, .height]
        window.contentView?.addSubview(sizeLabel)

        self.primaryBorderView = borderView
        self.sizeLabelView = sizeLabel
        self.primaryWindow = window
    }

    // MARK: - Helpers

    /// Returns the diagonally opposite corner (e.g. topLeft ↔ bottomRight).
    private func oppositeCorner(_ corner: DragCorner) -> DragCorner {
        switch corner {
        case .topLeft: return .bottomRight
        case .topRight: return .bottomLeft
        case .bottomLeft: return .topRight
        case .bottomRight: return .topLeft
        }
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

    /// Returns true if two frames differ by less than 1pt on all edges.
    /// Used to skip redundant window frame updates during rapid polling.
    private func framesAreClose(_ a: CGRect, _ b: CGRect) -> Bool {
        return abs(a.origin.x - b.origin.x) < 1
            && abs(a.origin.y - b.origin.y) < 1
            && abs(a.width - b.width) < 1
            && abs(a.height - b.height) < 1
    }
}

// MARK: - AspectRatioFormatter

/// Formats a width × height into a human-readable aspect ratio string.
///
/// Recognition order:
/// 1. Integer ratios (1:1, 4:3, 16:9, etc.) — displayed as "W : H"
/// 2. Named mathematical ratios (√2, 黄金比, 白銀比, etc.) — displayed as labels
/// 3. Fallback — displayed as decimal (e.g. "1.3 : 1")
///
/// Portrait orientations are handled by checking the inverse ratio;
/// named ratios show "1/label" and integer ratios swap W and H.
private struct AspectRatioFormatter {

    /// Well-known aspect ratios, checked in order.
    /// Integer ratios use (w, h, nil, value); named ratios use (0, 0, label, value).
    private static let knownRatios: [(w: Int, h: Int, label: String?, value: CGFloat)] = [
        // Common screen/window ratios (integer)
        (1, 1, nil, 1.0),
        (4, 3, nil, 4.0 / 3.0),
        (3, 2, nil, 3.0 / 2.0),
        (16, 10, nil, 16.0 / 10.0),
        (16, 9, nil, 16.0 / 9.0),
        (5, 4, nil, 5.0 / 4.0),
        (21, 9, nil, 21.0 / 9.0),
        (32, 9, nil, 32.0 / 9.0),
        // Named mathematical ratios (metallic means and related)
        (0, 0, "√2",      1.4142135624),  // √2 ≈ 1.414 (A-series paper / Yamato ratio)
        (0, 0, "黄金比",   1.6180339887),  // Golden ratio φ = (1+√5)/2
        (0, 0, "白銀比",   2.4142135624),  // Silver ratio δ_S = 1+√2
        (0, 0, "白金比",   1.3247179572),  // Plastic ratio ρ (real root of x³=x+1)
        (0, 0, "青銅比",   3.3027756377),  // Bronze ratio β = (3+√13)/2
    ]

    /// Maximum relative error for matching a known ratio (1.5%).
    private static let tolerance: CGFloat = 0.015

    /// Formats the aspect ratio for the given pixel dimensions.
    static func format(width: CGFloat, height: CGFloat) -> String {
        guard height > 0 && width > 0 else { return "" }

        let ratio = width / height
        let inverseRatio = height / width

        // Try to match each known ratio in both landscape and portrait orientation.
        for known in knownRatios {
            // Landscape check (width >= height).
            let relError = abs(ratio - known.value) / known.value
            if relError < tolerance {
                if let label = known.label { return label }
                return "\(known.w) : \(known.h)"
            }

            // Portrait check (height > width) — skip for 1:1.
            if known.value != 1.0 {
                let relErrorInv = abs(inverseRatio - known.value) / known.value
                if relErrorInv < tolerance {
                    if let label = known.label { return "1/\(label)" }
                    return "\(known.h) : \(known.w)"
                }
            }
        }

        // No known ratio matched — format as decimal with one decimal place.
        if ratio >= 1.0 {
            return String(format: "%.1f : 1", ratio)
        } else {
            return String(format: "1 : %.1f", 1.0 / ratio)
        }
    }
}

// MARK: - OverlayBorderView

/// Draws the overlay border and the aspect ratio label.
///
/// The border is a rounded rectangle with configurable color and line style
/// (solid or dashed), set via `updateStyle()`. The aspect ratio label is a
/// small dark pill drawn at the corner diagonally opposite from the drag,
/// set via `updateRatio()`.
private class OverlayBorderView: NSView {

    // MARK: - Border State

    /// Current border color, configurable via Settings.
    private var borderColor: NSColor = NSColor(calibratedRed: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)

    /// Whether the border is dashed (true) or solid (false).
    private var isDashed: Bool = false

    /// Updates the border color and line style, triggering a redraw.
    func updateStyle(color: NSColor, dashed: Bool) {
        borderColor = color
        isDashed = dashed
        needsDisplay = true
    }

    // MARK: - Ratio Label State

    /// The aspect ratio text to display (e.g. "16 : 9", "黄金比").
    private var ratioText: String = ""

    /// Which corner to draw the ratio label at.
    private var ratioCorner: DragCorner = .topLeft

    /// Updates the aspect ratio label text and corner position.
    func updateRatio(text: String, corner: DragCorner) {
        ratioText = text
        ratioCorner = corner
        needsDisplay = true
    }

    // MARK: - Drawing

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Draw the rounded border with semi-transparent fill.
        let insetRect = bounds.insetBy(dx: 4, dy: 4)
        let path = NSBezierPath(roundedRect: insetRect, xRadius: 8, yRadius: 8)

        // Fill: slightly more opaque when solid to distinguish from dashed.
        let fillAlpha: CGFloat = isDashed ? 0.06 : 0.12
        borderColor.withAlphaComponent(fillAlpha).setFill()
        path.fill()

        // Stroke: solid or dashed at the configured color.
        let strokeAlpha: CGFloat = isDashed ? 0.5 : 0.8
        borderColor.withAlphaComponent(strokeAlpha).setStroke()
        path.lineWidth = 3.0
        if isDashed {
            path.setLineDash([8, 6], count: 2, phase: 0)
        }
        path.stroke()

        // Draw the aspect ratio pill at the opposite corner.
        drawRatioLabel()
    }

    /// Draws a small dark pill with the aspect ratio text at `ratioCorner`.
    private func drawRatioLabel() {
        guard !ratioText.isEmpty else { return }

        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .medium),
            .foregroundColor: NSColor.white.withAlphaComponent(0.8)
        ]
        let textSize = (ratioText as NSString).size(withAttributes: attrs)

        let paddingH: CGFloat = 8
        let paddingV: CGFloat = 4
        let pillWidth = textSize.width + paddingH * 2
        let pillHeight = textSize.height + paddingV * 2
        let margin: CGFloat = 16

        // Position the pill at the specified corner inside the overlay bounds.
        let origin = pillOrigin(pillSize: NSSize(width: pillWidth, height: pillHeight),
                                corner: ratioCorner, margin: margin)

        // Dark semi-transparent pill background.
        let pillRect = NSRect(origin: origin, size: NSSize(width: pillWidth, height: pillHeight))
        let pillPath = NSBezierPath(roundedRect: pillRect,
                                    xRadius: pillHeight / 2, yRadius: pillHeight / 2)
        NSColor.black.withAlphaComponent(0.5).setFill()
        pillPath.fill()

        // White ratio text centered within the pill.
        let textRect = NSRect(
            x: origin.x + paddingH,
            y: origin.y + paddingV - 1,
            width: textSize.width,
            height: textSize.height
        )
        (ratioText as NSString).draw(in: textRect, withAttributes: attrs)
    }

    /// Computes the origin point for a pill of the given size at the specified corner.
    /// In NSView coordinates: (0,0) is bottom-left, maxY is top.
    private func pillOrigin(pillSize: NSSize, corner: DragCorner, margin: CGFloat) -> NSPoint {
        let x: CGFloat
        let y: CGFloat
        switch corner {
        case .topLeft:
            x = margin
            y = bounds.maxY - margin - pillSize.height
        case .topRight:
            x = bounds.maxX - margin - pillSize.width
            y = bounds.maxY - margin - pillSize.height
        case .bottomLeft:
            x = margin
            y = margin
        case .bottomRight:
            x = bounds.maxX - margin - pillSize.width
            y = margin
        }
        return NSPoint(x: x, y: y)
    }
}

// MARK: - CornerSizeLabelView

/// Draws a size label pill at a drag corner inside the overlay.
///
/// Two display modes:
/// - **With snap**: two-line pill — line 1 is the snap target size in large bold
///   text, line 2 is the current window size in smaller dimmed text.
/// - **Without snap**: single-line compact pill showing only the current window
///   size in small text.
private class CornerSizeLabelView: NSView {

    /// Snap target size text (empty string when no snap candidate).
    private var snapText: String = ""

    /// Current window dimensions text (e.g. "1024 × 768").
    private var currentSizeText: String?

    /// Which corner to draw the pill at.
    private var corner: DragCorner = .bottomRight

    /// Updates the displayed text and corner, triggering a redraw.
    func update(snapText: String, currentSizeText: String?, corner: DragCorner) {
        self.snapText = snapText
        self.currentSizeText = currentSizeText
        self.corner = corner
        needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard !snapText.isEmpty || currentSizeText != nil else { return }

        let largeAttrs = largeTextAttributes()
        let smallAttrs = smallTextAttributes()
        let hasSnap = !snapText.isEmpty
        let paddingH: CGFloat = hasSnap ? 14 : 8
        let paddingV: CGFloat = hasSnap ? 10 : 5
        let lineSpacing: CGFloat = 4

        // Measure text sizes to compute the pill dimensions.
        let snapSize = hasSnap
            ? (snapText as NSString).size(withAttributes: largeAttrs)
            : .zero
        let currentSize = currentSizeText.map {
            ($0 as NSString).size(withAttributes: smallAttrs)
        }

        // Pill is wide enough for the wider line, tall enough for both lines.
        let contentWidth: CGFloat
        let contentHeight: CGFloat
        if hasSnap {
            contentWidth = max(snapSize.width, currentSize?.width ?? 0)
            contentHeight = snapSize.height
                + (currentSize != nil ? lineSpacing + currentSize!.height : 0)
        } else {
            contentWidth = currentSize?.width ?? 0
            contentHeight = currentSize?.height ?? 0
        }
        let pillWidth = contentWidth + paddingH * 2
        let pillHeight = contentHeight + paddingV * 2

        // Position the pill at the drag corner inside the overlay.
        let pillOrigin = computePillOrigin(
            pillSize: NSSize(width: pillWidth, height: pillHeight)
        )

        // Draw the dark pill background.
        let pillRect = NSRect(origin: pillOrigin,
                              size: NSSize(width: pillWidth, height: pillHeight))
        let cornerRadius: CGFloat = hasSnap ? 10 : pillHeight / 2
        let pillPath = NSBezierPath(roundedRect: pillRect,
                                    xRadius: cornerRadius, yRadius: cornerRadius)
        NSColor.black.withAlphaComponent(hasSnap ? 0.7 : 0.6).setFill()
        pillPath.fill()

        // Draw snap target size (line 1, top) when a snap candidate is active.
        if hasSnap {
            let snapY = pillOrigin.y + paddingV
                + (currentSize != nil ? currentSize!.height + lineSpacing : 0)
            let snapRect = NSRect(
                x: pillOrigin.x + paddingH,
                y: snapY,
                width: snapSize.width,
                height: snapSize.height
            )
            (snapText as NSString).draw(in: snapRect, withAttributes: largeAttrs)
        }

        // Draw current window size (line 2 when snap exists, sole line otherwise).
        if let currentSizeText = currentSizeText, let csSize = currentSize {
            let csRect = NSRect(
                x: pillOrigin.x + paddingH,
                y: pillOrigin.y + paddingV,
                width: csSize.width,
                height: csSize.height
            )
            (currentSizeText as NSString).draw(in: csRect, withAttributes: smallAttrs)
        }
    }

    /// Large bold monospaced digits for the snap target size.
    private func largeTextAttributes() -> [NSAttributedString.Key: Any] {
        return [
            .font: NSFont.monospacedDigitSystemFont(ofSize: 36, weight: .bold),
            .foregroundColor: NSColor.white
        ]
    }

    /// Small dimmed monospaced digits for the current window size.
    private func smallTextAttributes() -> [NSAttributedString.Key: Any] {
        return [
            .font: NSFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular),
            .foregroundColor: NSColor.white.withAlphaComponent(0.7)
        ]
    }

    /// Computes the pill origin at the drag corner, inside the overlay bounds.
    /// In NSView coordinates: (0,0) is bottom-left, maxY is top.
    private func computePillOrigin(pillSize: NSSize) -> NSPoint {
        let margin: CGFloat = 16
        let x: CGFloat
        let y: CGFloat

        switch corner {
        case .topLeft:
            x = margin
            y = bounds.maxY - margin - pillSize.height
        case .topRight:
            x = bounds.maxX - margin - pillSize.width
            y = bounds.maxY - margin - pillSize.height
        case .bottomLeft:
            x = margin
            y = margin
        case .bottomRight:
            x = bounds.maxX - margin - pillSize.width
            y = margin
        }

        return NSPoint(x: x, y: y)
    }
}
