// ScreenGeometry.swift — Coordinate conversion utilities between CGWindowList
// (top-left origin) and NSScreen (bottom-left origin) coordinate systems.

import AppKit

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
}
