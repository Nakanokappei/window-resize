// AppDelegate.swift — Coordinates the status bar item, menu construction,
// window resize execution, and post-resize screenshot capture. This is the
// central orchestrator that connects WindowManager, ScreenshotHelper,
// AccessibilityHelper, and SettingsStore.

import AppKit
import SwiftUI

/// Carrier object attached to each NSMenuItem via representedObject.
/// Bundles the target window and desired dimensions so the resize action
/// handler can access both without global state.
class ResizeAction: NSObject {
    let windowInfo: WindowInfo
    let size: PresetSize
    init(windowInfo: WindowInfo, size: PresetSize) {
        self.windowInfo = windowInfo
        self.size = size
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var settingsWindowController: SettingsWindowController?
    private let store = SettingsStore.shared

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
                image.size = NSSize(width: 18, height: 18)
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

        // Rebuild the menu whenever settings change (e.g. custom presets added/removed).
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(settingsDidChange),
            name: .settingsChanged,
            object: nil
        )
    }

    /// Constructs the status bar dropdown menu.
    /// Structure: Resize (submenu) → separator → Settings → separator → Quit
    private func buildStatusMenu() {
        let menu = NSMenu()

        // The Resize item opens a submenu that lazily lists running windows.
        let resizeItem = NSMenuItem(title: L("menu.resize"), action: nil, keyEquivalent: "")
        let resizeSubmenu = WindowListMenu(target: self)
        resizeItem.submenu = resizeSubmenu
        menu.addItem(resizeItem)

        menu.addItem(NSMenuItem.separator())

        let settingsItem = NSMenuItem(title: L("menu.settings"), action: #selector(openSettings), keyEquivalent: ",")
        settingsItem.target = self
        menu.addItem(settingsItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: L("menu.quit"), action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    /// Resize action handler, called when the user selects a preset size.
    /// Re-checks Accessibility permission before each resize because the
    /// permission could have been revoked since the menu was opened.
    @objc func resizeSelectedWindow(_ sender: NSMenuItem) {
        guard let action = sender.representedObject as? ResizeAction else { return }

        if !AccessibilityHelper.isPermissionGranted() {
            AccessibilityHelper.promptForPermission()
            return
        }

        if !AccessibilityHelper.isPermissionFunctional() {
            AccessibilityHelper.promptToReauthorize()
            return
        }

        let success = WindowManager.resizeWindow(action.windowInfo, to: action.size)
        if !success {
            let alert = NSAlert()
            alert.messageText = L("alert.resize-failed.title")
            alert.informativeText = L("alert.resize-failed.body")
            alert.alertStyle = .warning
            alert.runModal()
            return
        }

        // After a successful resize, wait 0.5 seconds for the window to finish
        // its redraw/animation, then capture a screenshot if enabled.
        if store.screenshotEnabled {
            let windowID = action.windowInfo.windowID
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                ScreenshotHelper.captureWindow(windowID) { image in
                    guard let image = image else { return }

                    if self.store.screenshotSaveToFile {
                        _ = ScreenshotHelper.exportAsPNG(image, to: self.store.screenshotSaveLocation)
                    }

                    if self.store.screenshotCopyToClipboard {
                        ScreenshotHelper.copyToClipboard(image)
                    }
                }
            }
        }
    }

    @objc private func openSettings() {
        if settingsWindowController == nil {
            settingsWindowController = SettingsWindowController()
        }
        settingsWindowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }

    @objc private func settingsDidChange() {
        buildStatusMenu()
    }
}

// MARK: - WindowListMenu

/// A submenu that lazily populates the list of running application windows.
/// Uses NSMenuDelegate so the window list is refreshed each time the user
/// opens the Resize submenu, rather than being stale from app launch.
class WindowListMenu: NSMenu, NSMenuDelegate {
    weak var resizeTarget: AppDelegate?

    init(target: AppDelegate) {
        self.resizeTarget = target
        super.init(title: L("menu.resize"))
        self.delegate = self

        // A placeholder item is required for the parent menu to show
        // the submenu arrow indicator.
        self.addItem(NSMenuItem(title: L("menu.loading"), action: nil, keyEquivalent: ""))
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Called by AppKit each time the submenu is about to open.
    /// Replaces all items with the current window list.
    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.removeAllItems()

        let windows = WindowManager.discoverWindows()

        if windows.isEmpty {
            let noWindowsItem = NSMenuItem(title: L("menu.no-windows"), action: nil, keyEquivalent: "")
            noWindowsItem.isEnabled = false
            menu.addItem(noWindowsItem)
            return
        }

        // Each window gets a submenu of available preset sizes.
        for windowInfo in windows {
            let displayName = windowInfo.windowName.isEmpty ? L("menu.untitled") : windowInfo.windowName
            let title = "[\(windowInfo.ownerName)] \(displayName)"
            let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")

            let sizeSubmenu = PresetSizeMenu(windowInfo: windowInfo, target: resizeTarget!)
            item.submenu = sizeSubmenu
            menu.addItem(item)
        }
    }
}

// MARK: - PresetSizeMenu

/// A submenu listing all available preset sizes for a specific window.
/// Sizes that exceed the window's display resolution are shown but disabled,
/// preventing the user from resizing a window larger than its screen.
class PresetSizeMenu: NSMenu {
    init(windowInfo: WindowInfo, target: AppDelegate) {
        super.init(title: "")

        let screenSize = displayBounds(containing: windowInfo)

        let store = SettingsStore.shared
        for size in store.allPresets {
            let exceedsScreen = CGFloat(size.width) > screenSize.width || CGFloat(size.height) > screenSize.height

            let item = NSMenuItem(title: "", action: exceedsScreen ? nil : #selector(AppDelegate.resizeSelectedWindow(_:)), keyEquivalent: "")
            item.target = exceedsScreen ? nil : target
            item.isEnabled = !exceedsScreen

            // Build an attributed string with a right-aligned label using
            // NSTextTab. This produces a layout like:
            //   "1920 x 1080                    Full HD"
            // where the label is right-aligned at the 230pt tab stop.
            let paragraphStyle = NSMutableParagraphStyle()
            let tabStop = NSTextTab(textAlignment: .right, location: 230)
            paragraphStyle.tabStops = [tabStop]

            let baseAttrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.menuFont(ofSize: 14),
                .paragraphStyle: paragraphStyle
            ]

            let sizeText = NSMutableAttributedString(string: size.displayName, attributes: baseAttrs)

            if let label = size.label, !label.isEmpty {
                let labelAttrs: [NSAttributedString.Key: Any] = [
                    .font: NSFont.menuFont(ofSize: 11),
                    .foregroundColor: NSColor.secondaryLabelColor,
                    .paragraphStyle: paragraphStyle
                ]
                sizeText.append(NSAttributedString(string: "\t\(label)", attributes: labelAttrs))
            }

            item.attributedTitle = sizeText
            item.representedObject = ResizeAction(windowInfo: windowInfo, size: size)
            addItem(item)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Returns the screen dimensions of the display containing the window.
    ///
    /// Handles the coordinate system mismatch between CGWindowList (top-left
    /// origin) and NSScreen (bottom-left origin) by converting NSScreen frames
    /// to top-left origin before hit-testing the window's center point.
    /// Falls back to the main screen if no match is found.
    private func displayBounds(containing windowInfo: WindowInfo) -> CGSize {
        let windowCenter = CGPoint(
            x: windowInfo.bounds.midX,
            y: windowInfo.bounds.midY
        )

        for screen in NSScreen.screens {
            let frame = screen.frame
            // Flip Y: NSScreen bottom-left origin → top-left origin.
            let screenTopLeft = CGRect(
                x: frame.origin.x,
                y: NSScreen.screens[0].frame.height - frame.origin.y - frame.height,
                width: frame.width,
                height: frame.height
            )
            if screenTopLeft.contains(windowCenter) {
                return frame.size
            }
        }

        return NSScreen.main?.frame.size ?? CGSize(width: 1920, height: 1080)
    }
}
