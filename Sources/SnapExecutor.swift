// SnapExecutor.swift — Executes the actual window snap by setting the window's
// size and position via the AXUIElement accessibility API.
// Separated from detection logic so snap execution can be tested independently.

import AppKit
import ApplicationServices

struct SnapExecutor {

    /// Snaps a window to the specified target frame using AXUIElement.
    /// Locates the target window by PID + title matching (same strategy as
    /// WindowManager.resizeWindow), then sets both position and size.
    ///
    /// Returns true if the snap was applied successfully.
    static func execute(windowInfo: WindowInfo, targetFrame: CGRect) -> Bool {
        // Verify Accessibility permission is functional before attempting.
        guard AccessibilityHelper.isPermissionFunctional() else { return false }

        let appElement = AXUIElementCreateApplication(windowInfo.ownerPID)

        // Retrieve the list of AX windows for this application.
        var windowsRef: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &windowsRef)
        guard result == .success, let windows = windowsRef as? [AXUIElement] else {
            return false
        }

        // Find the target window by matching titles.
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

        // Fallback: use the first window if no title match found.
        if targetWindow == nil { targetWindow = windows.first }
        guard let window = targetWindow else { return false }

        // Set position first, then size. This order prevents the window from
        // briefly appearing at the wrong position with the new size.
        var origin = targetFrame.origin
        if let posValue = AXValueCreate(.cgPoint, &origin) {
            AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, posValue)
        }

        var size = targetFrame.size
        if let sizeValue = AXValueCreate(.cgSize, &size) {
            let sizeResult = AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, sizeValue)
            return sizeResult == .success
        }

        return false
    }
}
