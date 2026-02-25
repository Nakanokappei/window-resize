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
        window.styleMask = [.titled, .closable, .miniaturizable]
        window.center()

        self.init(window: window)
    }
}
