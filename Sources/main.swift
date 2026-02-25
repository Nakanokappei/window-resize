// main.swift — Application entry point.
// Configures the app as a menu-bar-only accessory (no Dock icon, no main window)
// and prevents multiple instances from running simultaneously.

import AppKit

// Prevent duplicate instances: if another process with the same bundle ID
// is already running (even from a different path), exit immediately.
// This handles the case where the user opens a new build while the old one
// is still in the menu bar.
if let bundleID = Bundle.main.bundleIdentifier {
    let running = NSRunningApplication.runningApplications(withBundleIdentifier: bundleID)
    if running.count > 1 {
        exit(0)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

// .accessory policy: no Dock icon, no main menu bar, no app switcher entry.
// The app is only visible via its NSStatusItem in the system menu bar.
app.setActivationPolicy(.accessory)
app.run()
