import AppKit
import ApplicationServices

struct WindowInfo {
    let windowID: CGWindowID
    let ownerName: String
    let windowName: String
    let ownerPID: pid_t
    let bounds: CGRect
}

class WindowManager {

    static func listWindows() -> [WindowInfo] {
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

            // Skip our own app
            guard ownerPID != myPID else { return nil }

            let windowName = dict[kCGWindowName as String] as? String ?? ""
            let bounds = CGRect(
                x: (boundsDict["X"] as? CGFloat) ?? 0,
                y: (boundsDict["Y"] as? CGFloat) ?? 0,
                width: (boundsDict["Width"] as? CGFloat) ?? 0,
                height: (boundsDict["Height"] as? CGFloat) ?? 0
            )

            // Skip windows with zero size
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

    static func resizeWindow(_ windowInfo: WindowInfo, to size: PresetSize) -> Bool {
        let appElement = AXUIElementCreateApplication(windowInfo.ownerPID)

        var windowsRef: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &windowsRef)
        guard result == .success, let windows = windowsRef as? [AXUIElement] else {
            return false
        }

        for window in windows {
            var titleRef: CFTypeRef?
            AXUIElementCopyAttributeValue(window, kAXTitleAttribute as CFString, &titleRef)
            let title = titleRef as? String ?? ""

            // Match by title, or if no title available match first window
            if title == windowInfo.windowName || (windowInfo.windowName.isEmpty && title.isEmpty) {
                var newSize = CGSize(width: CGFloat(size.width), height: CGFloat(size.height))
                guard let sizeValue = AXValueCreate(.cgSize, &newSize) else { return false }
                let sizeResult = AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, sizeValue)
                return sizeResult == .success
            }
        }

        // Fallback: if no title match, resize the first window
        if let firstWindow = windows.first {
            var newSize = CGSize(width: CGFloat(size.width), height: CGFloat(size.height))
            guard let sizeValue = AXValueCreate(.cgSize, &newSize) else { return false }
            let sizeResult = AXUIElementSetAttributeValue(firstWindow, kAXSizeAttribute as CFString, sizeValue)
            return sizeResult == .success
        }

        return false
    }
}
