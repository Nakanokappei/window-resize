// WindowManager.swift — Bridge between CGWindowList (read-only enumeration)
// and AXUIElement (read-write manipulation) for managing application windows.
// These two APIs have no shared window identifier, so matching is done via
// PID + window title.

import AppKit
import ApplicationServices

/// Represents the 9 anchor positions where a window can be placed on screen.
/// Positions form a 3x3 grid matching the screen edges and center.
/// Clockwise from top-left: topLeft, top, topRight, right, bottomRight,
/// bottom, bottomLeft, left, plus center.
enum WindowPosition: String, Codable, CaseIterable {
    case topLeft, top, topRight
    case left, center, right
    case bottomLeft, bottom, bottomRight
}

/// Lightweight snapshot of a window's identity and geometry, sourced from
/// CGWindowListCopyWindowInfo. Coordinates use the top-left screen origin.
struct WindowInfo {
    let windowID: CGWindowID
    let ownerName: String
    let windowName: String
    let ownerPID: pid_t
    let bounds: CGRect
}

class WindowManager {

    /// Standard macOS title bar height, used as margin when positioning
    /// windows near screen edges so they don't sit flush against the
    /// boundary and remain easy to interact with.
    private static let titleBarMargin: CGFloat = 28.0

    /// Enumerates all visible, resizable application windows on screen.
    ///
    /// Applies several filters to the raw CGWindowList output:
    /// - On-screen only, excluding desktop elements (Dock, wallpaper)
    /// - Layer 0 only (standard application windows; menus, tooltips, etc. live on other layers)
    /// - Excludes this app's own windows
    /// - Excludes zero-size windows (e.g. hidden helper windows)
    static func discoverWindows() -> [WindowInfo] {
        let options: CGWindowListOption = [.optionOnScreenOnly, .excludeDesktopElements]
        guard let windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as? [[String: Any]] else {
            return []
        }

        let myPID = ProcessInfo.processInfo.processIdentifier

        return windowList.compactMap { dict -> WindowInfo? in
            guard let windowID = dict[kCGWindowNumber as String] as? CGWindowID,
                  let ownerName = dict[kCGWindowOwnerName as String] as? String,
                  let ownerPID = dict[kCGWindowOwnerPID as String] as? Int32,
                  let layer = dict[kCGWindowLayer as String] as? Int,
                  layer == 0,
                  let boundsDict = dict[kCGWindowBounds as String] as? [String: Any]
            else { return nil }

            guard ownerPID != myPID else { return nil }

            let windowName = dict[kCGWindowName as String] as? String ?? ""
            let bounds = CGRect(
                x: (boundsDict["X"] as? CGFloat) ?? 0,
                y: (boundsDict["Y"] as? CGFloat) ?? 0,
                width: (boundsDict["Width"] as? CGFloat) ?? 0,
                height: (boundsDict["Height"] as? CGFloat) ?? 0
            )

            guard bounds.width > 0 && bounds.height > 0 else { return nil }

            return WindowInfo(
                windowID: windowID,
                ownerName: ownerName,
                windowName: windowName,
                ownerPID: ownerPID,
                bounds: bounds
            )
        }
    }

    /// Resizes a window to the given preset dimensions using the AXUIElement API,
    /// with optional positioning, bring-to-front, and move-to-main-screen.
    ///
    /// There is no direct mapping from CGWindowID to AXUIElement, so we locate
    /// the target window by matching the PID and title from CGWindowList against
    /// the AXUIElement window list for the same process.
    ///
    /// If the title doesn't match any AX window (e.g. the title changed between
    /// enumeration and resize), we fall back to resizing the first window of the
    /// application — a reasonable default since most apps have one main window.
    static func resizeWindow(_ windowInfo: WindowInfo, to size: PresetSize,
                              position: WindowPosition? = nil,
                              bringToFront: Bool = false,
                              moveToMainScreen: Bool = false) -> Bool {
        let appElement = AXUIElementCreateApplication(windowInfo.ownerPID)

        var windowsRef: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &windowsRef)
        guard result == .success, let windows = windowsRef as? [AXUIElement] else {
            return false
        }

        // Try to find the exact window by matching titles.
        var targetWindow: AXUIElement?
        for window in windows {
            var titleRef: CFTypeRef?
            AXUIElementCopyAttributeValue(window, kAXTitleAttribute as CFString, &titleRef)
            let title = titleRef as? String ?? ""

            if title == windowInfo.windowName || (windowInfo.windowName.isEmpty && title.isEmpty) {
                targetWindow = window
                break
            }
        }

        // Fallback: no title match found — use the first window of this app.
        if targetWindow == nil { targetWindow = windows.first }
        guard let window = targetWindow else { return false }

        // Apply the new window size.
        var newSize = CGSize(width: CGFloat(size.width), height: CGFloat(size.height))
        guard let sizeValue = AXValueCreate(.cgSize, &newSize) else { return false }
        let sizeResult = AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, sizeValue)
        guard sizeResult == .success else { return false }

        // Reposition the window if a target position or main-screen move is requested.
        // When no explicit position is given but move-to-main-screen is on,
        // default to centering on the main screen.
        if position != nil || moveToMainScreen {
            let targetScreen = moveToMainScreen ? NSScreen.main : screenContaining(windowInfo)
            if let screen = targetScreen ?? NSScreen.main {
                let anchorPosition = position ?? .center
                let origin = calculateOrigin(for: anchorPosition, windowSize: newSize, on: screen)
                var point = origin
                if let posValue = AXValueCreate(.cgPoint, &point) {
                    AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, posValue)
                }
            }
        }

        // Bring the window to front by raising it and activating its owning app.
        if bringToFront {
            AXUIElementPerformAction(window, kAXRaiseAction as CFString)
            if let app = NSRunningApplication(processIdentifier: windowInfo.ownerPID) {
                app.activate(options: .activateIgnoringOtherApps)
            }
        }

        return true
    }

    // MARK: - Screen Detection

    /// Returns the NSScreen containing the center of the given window.
    /// Converts between CGWindowList coordinates (top-left origin) and
    /// NSScreen coordinates (bottom-left origin) for accurate hit-testing.
    /// Falls back to the main screen if no match is found.
    private static func screenContaining(_ windowInfo: WindowInfo) -> NSScreen? {
        let primaryHeight = NSScreen.screens.first?.frame.height ?? 0
        let windowCenter = CGPoint(x: windowInfo.bounds.midX, y: windowInfo.bounds.midY)

        for screen in NSScreen.screens {
            let frame = screen.frame
            // Convert NSScreen bottom-left origin to top-left origin for hit-testing.
            let screenTopLeft = CGRect(
                x: frame.origin.x,
                y: primaryHeight - frame.origin.y - frame.height,
                width: frame.width,
                height: frame.height
            )
            if screenTopLeft.contains(windowCenter) {
                return screen
            }
        }

        return NSScreen.main
    }

    // MARK: - Position Calculation

    /// Calculates the window origin for a given anchor position on the target
    /// screen. Uses the screen's visible frame (excluding menu bar and Dock)
    /// and adds a title-bar-height margin from edges so windows don't sit
    /// flush against screen boundaries.
    ///
    /// Coordinates are returned in the AXUIElement/CGWindowList coordinate
    /// system (top-left origin of the primary screen).
    private static func calculateOrigin(for position: WindowPosition,
                                         windowSize: CGSize,
                                         on screen: NSScreen) -> CGPoint {
        let primaryHeight = NSScreen.screens.first?.frame.height ?? 0
        let visible = screen.visibleFrame
        let margin = titleBarMargin

        // Convert NSScreen visible frame (bottom-left origin) to top-left origin.
        let top = primaryHeight - visible.maxY
        let left = visible.origin.x
        let width = visible.width
        let height = visible.height

        let x: CGFloat
        let y: CGFloat

        // Horizontal position: left edge, center, or right edge.
        switch position {
        case .topLeft, .left, .bottomLeft:
            x = left + margin
        case .top, .center, .bottom:
            x = left + (width - windowSize.width) / 2
        case .topRight, .right, .bottomRight:
            x = left + width - windowSize.width - margin
        }

        // Vertical position: top edge, middle, or bottom edge.
        switch position {
        case .topLeft, .top, .topRight:
            y = top + margin
        case .left, .center, .right:
            y = top + (height - windowSize.height) / 2
        case .bottomLeft, .bottom, .bottomRight:
            y = top + height - windowSize.height - margin
        }

        return CGPoint(x: x, y: y)
    }
}
