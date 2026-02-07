import AppKit
import ApplicationServices

class AccessibilityHelper {

    /// AXIsProcessTrusted() の結果（stale の可能性あり）
    static func isAccessibilityEnabled() -> Bool {
        AXIsProcessTrusted()
    }

    /// 実際にAXUIElementを操作して権限が有効か検証する
    /// AXIsProcessTrusted() が true でもリビルド後は stale になることがある
    static func isAccessibilityActuallyWorking() -> Bool {
        // まず API レベルのチェック
        guard AXIsProcessTrusted() else { return false }

        // 実際に AXUIElement 操作を試して確認
        // Finder は常に起動しているので、テスト対象として使う
        let runningApps = NSWorkspace.shared.runningApplications.filter {
            $0.activationPolicy == .regular
        }

        guard let testApp = runningApps.first else {
            // 通常アプリが無い場合はAPI結果を信用する
            return true
        }

        let appElement = AXUIElementCreateApplication(testApp.processIdentifier)
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &value)

        // .apiDisabled = 権限が実際には無い (stale)
        // .success = 権限あり
        // .noValue = 権限はあるがウィンドウが無い（これもOK）
        return result != .apiDisabled
    }

    static func requestAccessibilityPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        AXIsProcessTrustedWithOptions(options)
    }

    static func openAccessibilitySettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }

    /// 権限が stale の場合にユーザーへガイドを表示
    static func showStalePermissionAlert() {
        let alert = NSAlert()
        alert.messageText = L("alert.stale-permission.title")
        alert.informativeText = L("alert.stale-permission.body")
        alert.alertStyle = .warning
        alert.addButton(withTitle: L("alert.button.open-settings"))
        alert.addButton(withTitle: L("alert.button.ok"))

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            openAccessibilitySettings()
        }
    }
}
