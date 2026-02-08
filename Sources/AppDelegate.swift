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
        // Permission check: AXIsProcessTrusted may return true even when stale after rebuild
        if !AccessibilityHelper.isAccessibilityEnabled() {
            AccessibilityHelper.requestAccessibilityPermission()
        } else if !AccessibilityHelper.isAccessibilityActuallyWorking() {
            // AXIsProcessTrusted() は true だが実際は動かない → stale
            // AXIsProcessTrusted() returns true but actually not working → stale
            AccessibilityHelper.showStalePermissionAlert()
        }

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            // メニューバーアイコン: Resources/MenuBarIcon.png を使用（テンプレート画像）
            // Menu bar icon: use Resources/MenuBarIcon.png (template image)
            if let image = NSImage(named: "MenuBarIcon") {
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

        // Resize submenu: ウィンドウ一覧 → サイズ選択 / Window list → Size selection
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
    weak var resizeTarget: AppDelegate?

    init(target: AppDelegate) {
        self.resizeTarget = target
        super.init(title: L("menu.resize"))
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
            let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")

            // サイズ一覧をサブメニューとして追加 / Add size list as submenu
            let sizeSubmenu = SizeListMenu(windowInfo: windowInfo, target: resizeTarget!)
            item.submenu = sizeSubmenu
            menu.addItem(item)
        }
    }
}

// A submenu that shows preset sizes for a given window
class SizeListMenu: NSMenu {
    init(windowInfo: WindowInfo, target: AppDelegate) {
        super.init(title: "")

        // ウィンドウが属するスクリーンの解像度を取得 / Get the screen resolution for the window's display
        let screenSize = screenSizeForWindow(windowInfo)

        let store = SettingsStore.shared
        for size in store.allSizes {
            let exceedsScreen = CGFloat(size.width) > screenSize.width || CGFloat(size.height) > screenSize.height

            let item = NSMenuItem(title: "", action: exceedsScreen ? nil : #selector(AppDelegate.resizeSelectedWindow(_:)), keyEquivalent: "")
            item.target = exceedsScreen ? nil : target
            item.isEnabled = !exceedsScreen

            // サイズ名とラベルを右揃えで表示する AttributedString を作成
            // Build AttributedString with right-aligned label for size name
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

    /// ウィンドウの中心座標が属するスクリーンのサイズを返す
    /// Returns the screen size of the display containing the window's center point
    private func screenSizeForWindow(_ windowInfo: WindowInfo) -> CGSize {
        let windowCenter = CGPoint(
            x: windowInfo.bounds.midX,
            y: windowInfo.bounds.midY
        )
        // CGWindowList の座標系は左上原点、NSScreen は左下原点なので変換して比較
        // CGWindowList uses top-left origin, NSScreen uses bottom-left; convert for comparison
        for screen in NSScreen.screens {
            let frame = screen.frame
            // NSScreen座標 → 左上原点に変換 / Convert NSScreen coords to top-left origin
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
        // フォールバック: メインスクリーン / Fallback: main screen
        return NSScreen.main?.frame.size ?? CGSize(width: 1920, height: 1080)
    }
}
