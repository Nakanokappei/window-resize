import AppKit
import SwiftUI

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
        // 権限チェック: AXIsProcessTrusted が true でもリビルド後は stale の場合がある
        if !AccessibilityHelper.isAccessibilityEnabled() {
            AccessibilityHelper.requestAccessibilityPermission()
        } else if !AccessibilityHelper.isAccessibilityActuallyWorking() {
            // AXIsProcessTrusted() は true だが実際は動かない → stale
            AccessibilityHelper.showStalePermissionAlert()
        }

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            if let image = NSImage(systemSymbolName: "rectangle.expand.vertical",
                                   accessibilityDescription: L("accessibility.icon-description")) {
                image.isTemplate = true
                button.image = image
            } else {
                button.title = "WR"
            }
        }

        rebuildMenu()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(settingsDidChange),
            name: .settingsChanged,
            object: nil
        )
    }

    private func rebuildMenu() {
        let menu = NSMenu()

        // Resize submenu
        let resizeItem = NSMenuItem(title: L("menu.resize"), action: nil, keyEquivalent: "")
        let resizeSubmenu = NSMenu()

        for size in store.allSizes {
            let sizeItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")

            // サイズ名とラベルを右揃えで表示する AttributedString を作成
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

            sizeItem.attributedTitle = sizeText

            let windowSubmenu = WindowListMenu(size: size, target: self)
            sizeItem.submenu = windowSubmenu
            resizeSubmenu.addItem(sizeItem)
        }

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

    @objc func resizeSelectedWindow(_ sender: NSMenuItem) {
        guard let action = sender.representedObject as? ResizeAction else { return }

        if !AccessibilityHelper.isAccessibilityEnabled() {
            AccessibilityHelper.requestAccessibilityPermission()
            return
        }

        if !AccessibilityHelper.isAccessibilityActuallyWorking() {
            AccessibilityHelper.showStalePermissionAlert()
            return
        }

        let success = WindowManager.resizeWindow(action.windowInfo, to: action.size)
        if !success {
            let alert = NSAlert()
            alert.messageText = L("alert.resize-failed.title")
            alert.informativeText = L("alert.resize-failed.body")
            alert.alertStyle = .warning
            alert.runModal()
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
        rebuildMenu()
    }
}

// A submenu that lazily populates window list when opened
class WindowListMenu: NSMenu, NSMenuDelegate {
    let presetSize: PresetSize
    weak var resizeTarget: AppDelegate?

    init(size: PresetSize, target: AppDelegate) {
        self.presetSize = size
        self.resizeTarget = target
        super.init(title: size.displayName)
        self.delegate = self
        // Add placeholder so the submenu arrow shows
        self.addItem(NSMenuItem(title: L("menu.loading"), action: nil, keyEquivalent: ""))
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.removeAllItems()

        let windows = WindowManager.listWindows()

        if windows.isEmpty {
            let noWindowsItem = NSMenuItem(title: L("menu.no-windows"), action: nil, keyEquivalent: "")
            noWindowsItem.isEnabled = false
            menu.addItem(noWindowsItem)
            return
        }

        for windowInfo in windows {
            let displayName = windowInfo.windowName.isEmpty ? L("menu.untitled") : windowInfo.windowName
            let title = "[\(windowInfo.ownerName)] \(displayName)"
            let item = NSMenuItem(
                title: title,
                action: #selector(AppDelegate.resizeSelectedWindow(_:)),
                keyEquivalent: ""
            )
            item.target = resizeTarget
            item.representedObject = ResizeAction(windowInfo: windowInfo, size: presetSize)
            menu.addItem(item)
        }
    }
}
