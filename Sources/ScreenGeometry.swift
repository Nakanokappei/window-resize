// ScreenGeometry.swift — Coordinate conversion utilities between CGWindowList
// (top-left origin) and NSScreen (bottom-left origin) coordinate systems.
// Provides snap zone definitions for screen edges and corners.

import AppKit

/// Defines the screen zones where edge/corner snapping activates.
/// Each zone maps to a target frame (half-screen or quarter-screen).
enum SnapZone: Equatable {
    case leftHalf
    case rightHalf
    case topHalf
    case bottomHalf
    case topLeftQuarter
    case topRightQuarter
    case bottomLeftQuarter
    case bottomRightQuarter
    case fullScreen

    /// Returns the target window frame for this snap zone on the given screen,
    /// expressed in CGWindowList coordinates (top-left origin).
    ///
    /// Edge snaps preserve one dimension of the window:
    /// - Left/Right edge: width stays the same, height fills screen, pinned to edge
    /// - Top/Bottom edge: height stays the same, width fills screen, pinned to edge
    /// Corner snaps preserve both dimensions, positioning the window in the corner.
    func targetFrame(on screen: NSScreen, windowSize: CGSize) -> CGRect {
        let visible = ScreenGeometry.visibleFrameInCG(for: screen)

        switch self {
        // Edge snaps: one axis fills screen, other preserves window size.
        case .leftHalf:
            return CGRect(x: visible.minX, y: visible.minY,
                          width: windowSize.width, height: visible.height)
        case .rightHalf:
            return CGRect(x: visible.maxX - windowSize.width, y: visible.minY,
                          width: windowSize.width, height: visible.height)
        case .topHalf:
            return CGRect(x: visible.minX, y: visible.minY,
                          width: visible.width, height: windowSize.height)
        case .bottomHalf:
            return CGRect(x: visible.minX, y: visible.maxY - windowSize.height,
                          width: visible.width, height: windowSize.height)

        // Corner snaps: preserve both dimensions, position in corner.
        case .topLeftQuarter:
            return CGRect(x: visible.minX, y: visible.minY,
                          width: windowSize.width, height: windowSize.height)
        case .topRightQuarter:
            return CGRect(x: visible.maxX - windowSize.width, y: visible.minY,
                          width: windowSize.width, height: windowSize.height)
        case .bottomLeftQuarter:
            return CGRect(x: visible.minX, y: visible.maxY - windowSize.height,
                          width: windowSize.width, height: windowSize.height)
        case .bottomRightQuarter:
            return CGRect(x: visible.maxX - windowSize.width, y: visible.maxY - windowSize.height,
                          width: windowSize.width, height: windowSize.height)

        case .fullScreen:
            return visible
        }
    }
}

struct ScreenGeometry {

    /// Height of the primary screen, used as the baseline for coordinate
    /// conversion between NSScreen (bottom-left) and CG (top-left) systems.
    static var primaryScreenHeight: CGFloat {
        NSScreen.screens.first?.frame.height ?? 0
    }

    /// Converts an NSScreen visible frame (bottom-left origin) to CGWindowList
    /// coordinates (top-left origin). The visible frame excludes the menu bar
    /// and Dock area.
    static func visibleFrameInCG(for screen: NSScreen) -> CGRect {
        let visible = screen.visibleFrame
        let primaryHeight = primaryScreenHeight
        return CGRect(
            x: visible.origin.x,
            y: primaryHeight - visible.origin.y - visible.height,
            width: visible.width,
            height: visible.height
        )
    }

    /// Converts an NSScreen full frame (bottom-left origin) to CGWindowList
    /// coordinates (top-left origin).
    static func fullFrameInCG(for screen: NSScreen) -> CGRect {
        let frame = screen.frame
        let primaryHeight = primaryScreenHeight
        return CGRect(
            x: frame.origin.x,
            y: primaryHeight - frame.origin.y - frame.height,
            width: frame.width,
            height: frame.height
        )
    }

    /// Converts a CG point (top-left origin) to NSScreen coordinates
    /// (bottom-left origin).
    static func cgPointToNS(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x, y: primaryScreenHeight - point.y)
    }

    /// Converts an NSScreen point (bottom-left origin) to CG coordinates
    /// (top-left origin). NSEvent.mouseLocation uses NSScreen coordinates.
    static func nsPointToCG(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x, y: primaryScreenHeight - point.y)
    }

    /// Returns the NSScreen containing the given point in CG coordinates.
    /// Falls back to the main screen if no match is found.
    static func screenContaining(cgPoint: CGPoint) -> NSScreen? {
        for screen in NSScreen.screens {
            let cgFrame = fullFrameInCG(for: screen)
            if cgFrame.contains(cgPoint) {
                return screen
            }
        }
        return NSScreen.main
    }

    /// Edge detection threshold in points — the mouse must be within this
    /// distance of a screen edge to trigger edge/corner snapping.
    static let edgeThreshold: CGFloat = 15.0

    /// Determines the snap zone based on the mouse position relative to the
    /// screen edges. Returns nil if the mouse is not near any edge.
    /// Mouse position is in CG coordinates (top-left origin).
    static func detectEdgeZone(mouseInCG: CGPoint, on screen: NSScreen) -> SnapZone? {
        let frame = fullFrameInCG(for: screen)
        let threshold = edgeThreshold

        // Determine which edges the mouse is near.
        let nearLeft = mouseInCG.x <= frame.minX + threshold
        let nearRight = mouseInCG.x >= frame.maxX - threshold
        let nearTop = mouseInCG.y <= frame.minY + threshold
        let nearBottom = mouseInCG.y >= frame.maxY - threshold

        // Corners take priority over edges (two edges met = corner).
        if nearLeft && nearTop { return .topLeftQuarter }
        if nearRight && nearTop { return .topRightQuarter }
        if nearLeft && nearBottom { return .bottomLeftQuarter }
        if nearRight && nearBottom { return .bottomRightQuarter }

        // Single edge: half-screen snap.
        if nearLeft { return .leftHalf }
        if nearRight { return .rightHalf }
        if nearTop { return .topHalf }
        if nearBottom { return .bottomHalf }

        return nil
    }
}
