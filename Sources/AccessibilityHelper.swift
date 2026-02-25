// AccessibilityHelper.swift — Manages the Accessibility permission lifecycle.
// macOS requires explicit user consent for apps to inspect and manipulate
// other applications' windows via the AXUIElement API.

import AppKit
import ApplicationServices

class AccessibilityHelper {

    /// Checks whether the user has granted Accessibility permission to this app.
    /// Wraps AXIsProcessTrusted(), which reads from the TCC (Transparency, Consent,
    /// and Control) database. Note: this can return true even when the permission
    /// is stale — see `isPermissionFunctional()` for a reliable check.
    static func isPermissionGranted() -> Bool {
        AXIsProcessTrusted()
    }

    /// Verifies that Accessibility permission actually works by probing a live app.
    ///
    /// After an app is rebuilt with a new code signature, macOS may still report
    /// the *old* entry as trusted (AXIsProcessTrusted() == true), but actual
    /// AXUIElement operations fail with .apiDisabled. This method detects that
    /// "stale permission" state by attempting a real AXUIElement query against
    /// any running regular application (Finder, Safari, etc.).
    ///
    /// Returns true if AXUIElement operations succeed, false if the permission
    /// is missing or stale.
    static func isPermissionFunctional() -> Bool {
        guard AXIsProcessTrusted() else { return false }

        // Pick any regular app as a test target. There is almost always at least
        // one (Finder), but if none exist, we trust the API result.
        let regularApps = NSWorkspace.shared.runningApplications.filter {
            $0.activationPolicy == .regular
        }
        guard let testApp = regularApps.first else { return true }

        // Attempt to read the app's window list. If the permission is stale,
        // this returns .apiDisabled instead of .success or .noValue.
        let appElement = AXUIElementCreateApplication(testApp.processIdentifier)
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &value)

        return result != .apiDisabled
    }

    /// Triggers the system Accessibility permission dialog.
    /// The kAXTrustedCheckOptionPrompt option tells macOS to show the
    /// "allow this app to control your computer" consent prompt.
    static func promptForPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        AXIsProcessTrustedWithOptions(options)
    }

    /// Opens System Settings → Privacy & Security → Accessibility.
    /// Uses the x-apple.systempreferences URL scheme, which deep-links
    /// directly to the Accessibility pane in both System Preferences (pre-Ventura)
    /// and System Settings (Ventura+).
    static func openSystemSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }

    /// Presents an alert explaining that Accessibility permission needs to be
    /// re-granted. This happens when the app is rebuilt with a new code signature —
    /// the old TCC entry becomes stale. The user must remove and re-add the app
    /// in System Settings to fix it.
    static func promptToReauthorize() {
        let alert = NSAlert()
        alert.messageText = L("alert.stale-permission.title")
        alert.informativeText = L("alert.stale-permission.body")
        alert.alertStyle = .warning
        alert.addButton(withTitle: L("alert.button.open-settings"))
        alert.addButton(withTitle: L("alert.button.ok"))

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            openSystemSettings()
        }
    }
}
