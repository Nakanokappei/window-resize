// SettingsWindowController.swift — NSHostingController bridge that wraps
// the SwiftUI SettingsView in an AppKit NSWindow. This is necessary because
// the app uses NSStatusItem (AppKit) for its menu bar presence, and SwiftUI
// Settings scenes are not available for LSUIElement (menu bar only) apps.
//
// The window height adjusts automatically when toggles (e.g. screenshot
// options) show or hide sub-options, using KVO on the hosting controller's
// preferredContentSize.

import AppKit
import SwiftUI

class SettingsWindowController: NSWindowController {

    /// Retains the KVO observation for the hosting controller's
    /// preferredContentSize so the window resizes when content changes.
    private var sizeObservation: NSKeyValueObservation?

    convenience init() {
        let settingsView = SettingsView()
        let hostingController = NSHostingController(rootView: settingsView)

        // Tell the hosting controller to keep its preferredContentSize
        // in sync with the SwiftUI view's ideal size (macOS 13+).
        hostingController.sizingOptions = .preferredContentSize

        let window = NSWindow(contentViewController: hostingController)
        window.title = L("settings.title")

        // Not resizable — height is driven entirely by content.
        window.styleMask = [.titled, .closable, .miniaturizable]

        // Set initial size from content, with fixed width.
        let contentHeight = hostingController.preferredContentSize.height
        window.setContentSize(NSSize(width: 400, height: max(contentHeight, 300)))
        window.center()

        self.init(window: window)

        // Observe content size changes and adjust window height with animation.
        sizeObservation = hostingController.observe(
            \.preferredContentSize,
            options: [.new]
        ) { [weak self] controller, _ in
            guard let window = self?.window else { return }
            let newContentHeight = controller.preferredContentSize.height
            guard newContentHeight > 0 else { return }

            // Calculate new window frame, keeping the top edge fixed.
            let titleBarHeight = window.frame.height - window.contentLayoutRect.height
            let newWindowHeight = newContentHeight + titleBarHeight
            var frame = window.frame
            frame.origin.y += frame.height - newWindowHeight
            frame.size.height = newWindowHeight

            window.animator().setFrame(frame, display: true)
        }
    }
}
