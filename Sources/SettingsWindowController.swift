// SettingsWindowController.swift — NSHostingController bridge that wraps
// the SwiftUI SettingsView in an AppKit NSWindow. This is necessary because
// the app uses NSStatusItem (AppKit) for its menu bar presence, and SwiftUI
// Settings scenes are not available for LSUIElement (menu bar only) apps.

import AppKit
import SwiftUI

class SettingsWindowController: NSWindowController {

    convenience init() {
        let settingsView = SettingsView()
        let hostingController = NSHostingController(rootView: settingsView)

        let window = NSWindow(contentViewController: hostingController)
        window.title = L("settings.title")
        window.setContentSize(NSSize(width: 400, height: 500))
        // Allow the window to resize vertically so it can grow when
        // screenshot options are revealed, without shrinking the preset list.
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        window.minSize = NSSize(width: 400, height: 400)
        window.maxSize = NSSize(width: 400, height: 800)
        window.center()

        self.init(window: window)
    }
}
