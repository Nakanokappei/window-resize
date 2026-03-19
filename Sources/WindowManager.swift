// WindowManager.swift — Bridge between CGWindowList (read-only enumeration)
// and AXUIElement (read-write manipulation) for managing application windows.
// Provides window discovery via CGWindowListCopyWindowInfo. Snap execution
// is handled by SnapExecutor.swift.

import AppKit
import ApplicationServices

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
}
