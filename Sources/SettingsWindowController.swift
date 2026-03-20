// SettingsWindowController.swift — Wraps the SwiftUI settings tabs in an
// AppKit NSTabViewController to get native toolbar-style tabs with icons.
// This is necessary because SwiftUI's TabView on macOS does not reliably
// display SF Symbol icons in tab items; NSTabViewController with
// .toolbarStyle provides the standard macOS Settings appearance.
//
// Each tab is an NSHostingController embedding one SwiftUI tab view.
// The window height adjusts automatically via KVO on each hosting
// controller's preferredContentSize when toggles show or hide sub-options.

import AppKit
import SwiftUI

/// NSWindow subclass that locks the title once set, ignoring subsequent
/// changes from NSTabViewController's .toolbar style tab switches.
/// This prevents the title from flickering or showing "Untitled" when
/// the user switches tabs.
private class TitleLockedWindow: NSWindow {
    private var lockedTitle: String?

    /// Sets the title and locks it. All subsequent title changes are ignored.
    func lockTitle(_ title: String) {
        lockedTitle = title
        super.title = title
    }

    override var title: String {
        get { super.title }
        set {
            // Only accept title changes before the title is locked.
            if lockedTitle == nil {
                super.title = newValue
            }
        }
    }
}

class SettingsWindowController: NSWindowController {

    /// Retains the KVO observations for each hosting controller's
    /// preferredContentSize so the window resizes when content changes.
    private var sizeObservations: [NSKeyValueObservation] = []

    // UserDefaults keys for persisting the settings window position.
    // The screen resolution is saved alongside so the position is only
    // restored when the display configuration has not changed.
    private static let originXKey = "settingsWindowOriginX"
    private static let originYKey = "settingsWindowOriginY"
    private static let screenWidthKey = "settingsWindowScreenWidth"
    private static let screenHeightKey = "settingsWindowScreenHeight"

    convenience init() {
        // Build the NSTabViewController with toolbar-style tabs (icons + labels).
        let tabVC = NSTabViewController()
        tabVC.tabStyle = .toolbar

        // Tab definitions: (label, SF Symbol name, SwiftUI view).
        let tabs: [(String, String, AnyView)] = [
            (L("settings.tab.general"),    "gearshape",          AnyView(GeneralTab())),
            (L("settings.tab.appearance"), "paintbrush",         AnyView(AppearanceTab())),
            (L("settings.tab.shortcuts"),  "keyboard",           AnyView(ShortcutsTab())),
            (L("settings.tab.presets"),    "rectangle.3.group",  AnyView(PresetsTab())),
        ]

        for (label, icon, view) in tabs {
            let hostingController = NSHostingController(rootView:
                view.frame(width: 540)
            )
            // Keep preferredContentSize in sync with the SwiftUI view (macOS 13+).
            hostingController.sizingOptions = .preferredContentSize

            let tabItem = NSTabViewItem(viewController: hostingController)
            tabItem.label = label
            tabItem.image = NSImage(systemSymbolName: icon, accessibilityDescription: label)

            tabVC.addTabViewItem(tabItem)
        }

        let window = TitleLockedWindow(contentViewController: tabVC)
        window.lockTitle(L("settings.title"))

        // Not user-resizable — height is driven entirely by content.
        window.styleMask = [.titled, .closable, .miniaturizable]

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

        // Observe content size changes on each tab's hosting controller
        // and adjust window height with animation.
        for item in tabVC.tabViewItems {
            guard let hosting = item.viewController as? NSHostingController<AnyView> else { continue }
            let obs = hosting.observe(
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
            sizeObservations.append(obs)
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

