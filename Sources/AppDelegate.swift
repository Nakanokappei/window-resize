// AppDelegate.swift — Coordinates the status bar item, menu construction,
// and snap-based window management. This is the central orchestrator that
// connects WindowTracker, AccessibilityHelper, and SettingsStore.

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var settingsWindowController: SettingsWindowController?
    private let store = SettingsStore.shared

    /// The drag tracker that monitors window resize/move operations globally
    /// and triggers snap behavior when preset sizes or screen edges are detected.
    private let windowTracker = WindowTracker()

    /// Keyboard shortcut handler for precision resize, undo/redo, and
    /// one-tap preset application (⌃⌥ + arrow/Z/digit keys).
    private let keyboardController = KeyboardResizeController()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Check Accessibility permission on launch. Two failure modes:
        // 1. Never granted → prompt the system consent dialog
        // 2. Granted but stale (app was rebuilt) → guide user to re-authorize
        if !AccessibilityHelper.isPermissionGranted() {
            AccessibilityHelper.promptForPermission()
        } else if !AccessibilityHelper.isPermissionFunctional() {
            AccessibilityHelper.promptToReauthorize()
        }

        // Configure the menu bar status item with a template icon.
        // Template images adapt automatically to light/dark menu bar.
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            if let image = NSImage(named: "MenuBarIcon") {
                image.size = NSSize(width: 16, height: 16)
                image.isTemplate = true
                button.image = image
            } else if let image = NSImage(systemSymbolName: "rectangle.expand.vertical",
                                          accessibilityDescription: L("accessibility.icon-description")) {
                image.isTemplate = true
                button.image = image
            } else {
                button.title = "WR"
            }
        }

        buildStatusMenu()

        // Start the snap tracking engine (global event monitors for drag detection).
        windowTracker.start()

        // Start the keyboard shortcut handler (⌃⌥ + arrows/Z/digits).
        keyboardController.start()
    }

    func applicationWillTerminate(_ notification: Notification) {
        windowTracker.stop()
        keyboardController.stop()
    }

    /// Constructs the status bar dropdown menu.
    /// Structure: Settings → separator → Quit
    private func buildStatusMenu() {
        let menu = NSMenu()

        let settingsItem = NSMenuItem(title: L("menu.settings"), action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: L("menu.quit"), action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    @objc private func openSettings() {
        if settingsWindowController == nil {
            settingsWindowController = SettingsWindowController()
            // When the settings window closes, release the controller to avoid
            // retaining stale references. Also observe window resignation to
            // prevent crashes when focus leaves the window in .accessory mode.
            if let window = settingsWindowController?.window {
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(settingsWindowWillClose),
                    name: NSWindow.willCloseNotification,
                    object: window
                )
            }
        }
        settingsWindowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    /// Releases the settings window controller when the window closes.
    /// This prevents crashes in .accessory policy apps where a closed
    /// window's hosting controllers can reference deallocated SwiftUI state.
    @objc private func settingsWindowWillClose(_ notification: Notification) {
        NotificationCenter.default.removeObserver(
            self,
            name: NSWindow.willCloseNotification,
            object: settingsWindowController?.window
        )
        settingsWindowController = nil
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}
