// SnapExecutor.swift — Executes the actual window snap by setting the window's
// size and position via the AXUIElement accessibility API.
//
// After applying the target frame, a brief size nudge (+1px then back) is
// performed to force the target application to fully redraw its content.
// Some apps don't repaint correctly when resized purely via AXUIElement
// because they miss the normal NSWindowDidResize notification path.

import AppKit
import ApplicationServices

struct SnapExecutor {

    /// Snaps a window to the specified target frame using AXUIElement.
    /// Locates the target window by PID + title matching, then sets both
    /// position and size, followed by a redraw nudge.
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
            guard sizeResult == .success else { return false }
        } else {
            return false
        }

        // Force the target app to redraw by nudging the size (+1px then back).
        // This triggers the app's layout engine to recalculate, fixing cases
        // where AXUIElement-based resize leaves stale content artifacts.
        forceRedraw(window: window, targetSize: targetFrame.size)

        return true
    }

    /// Nudges the window size by 1px and immediately restores it.
    /// The brief size change forces the target app to perform a full
    /// layout pass and redraw, clearing any rendering artifacts.
    private static func forceRedraw(window: AXUIElement, targetSize: CGSize) {
        // Nudge: expand by 1px in both dimensions.
        var nudgedSize = CGSize(width: targetSize.width + 1, height: targetSize.height + 1)
        if let nudgeValue = AXValueCreate(.cgSize, &nudgedSize) {
            AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, nudgeValue)
        }

        // Restore: set back to the exact target size.
        var restoreSize = targetSize
        if let restoreValue = AXValueCreate(.cgSize, &restoreSize) {
            AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, restoreValue)
        }
    }
}
