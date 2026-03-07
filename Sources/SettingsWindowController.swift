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

    // UserDefaults keys for persisting the settings window position.
    // The screen resolution is saved alongside so the position is only
    // restored when the display configuration has not changed.
    private static let originXKey = "settingsWindowOriginX"
    private static let originYKey = "settingsWindowOriginY"
    private static let screenWidthKey = "settingsWindowScreenWidth"
    private static let screenHeightKey = "settingsWindowScreenHeight"

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

        // Restore saved position if the display resolution matches,
        // otherwise center the window on screen.
        if Self.restoreSavedPosition(to: window) == false {
            window.center()
        }

        self.init(window: window)

        // Save the window position whenever the user moves it.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidMove),
            name: NSWindow.didMoveNotification,
            object: window
        )

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

    // MARK: - Window Position Persistence

    /// Saves the current window origin and screen resolution to UserDefaults.
    @objc private func windowDidMove(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        guard let screenSize = window.screen?.frame.size else { return }

        let defaults = UserDefaults.standard
        defaults.set(Double(window.frame.origin.x), forKey: Self.originXKey)
        defaults.set(Double(window.frame.origin.y), forKey: Self.originYKey)
        defaults.set(Double(screenSize.width), forKey: Self.screenWidthKey)
        defaults.set(Double(screenSize.height), forKey: Self.screenHeightKey)
    }

    /// Restores the saved window position if the current screen resolution
    /// matches the resolution at the time the position was saved.
    /// Returns true if the position was restored, false otherwise.
    @discardableResult
    private static func restoreSavedPosition(to window: NSWindow) -> Bool {
        let defaults = UserDefaults.standard

        // All four values must be present.
        guard defaults.object(forKey: originXKey) != nil,
              defaults.object(forKey: originYKey) != nil,
              defaults.object(forKey: screenWidthKey) != nil,
              defaults.object(forKey: screenHeightKey) != nil else {
            return false
        }

        let savedX = defaults.double(forKey: originXKey)
        let savedY = defaults.double(forKey: originYKey)
        let savedScreenWidth = defaults.double(forKey: screenWidthKey)
        let savedScreenHeight = defaults.double(forKey: screenHeightKey)

        // Compare the saved resolution against the current main screen.
        guard let currentScreenSize = NSScreen.main?.frame.size else { return false }
        if abs(currentScreenSize.width - savedScreenWidth) > 1.0 ||
           abs(currentScreenSize.height - savedScreenHeight) > 1.0 {
            return false
        }

        // Set the origin, keeping the window's current size.
        var frame = window.frame
        frame.origin = NSPoint(x: savedX, y: savedY)
        window.setFrame(frame, display: false)
        return true
    }
}
