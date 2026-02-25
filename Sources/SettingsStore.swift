// SettingsStore.swift — Single source of truth for all user preferences.
// Publishes changes via Combine (@Published) for SwiftUI bindings, and
// posts .settingsChanged notifications so AppDelegate can rebuild the menu
// when presets change.

import Foundation
import Combine
import ServiceManagement

extension Notification.Name {
    static let settingsChanged = Notification.Name("com.windowresize.settingsChanged")
}

/// Where to save screenshot files.
enum ScreenshotSaveLocation: String, CaseIterable {
    case desktop
    case pictures
}

class SettingsStore: ObservableObject {
    static let shared = SettingsStore()

    // MARK: - UserDefaults Keys

    private let defaultsKey = "customPresetSizes"
    private let launchAtLoginKey = "launchAtLogin"
    private let screenshotEnabledKey = "screenshotEnabled"
    private let screenshotSaveToFileKey = "screenshotSaveToFile"
    private let screenshotSaveLocationKey = "screenshotSaveLocation"
    private let screenshotCopyToClipboardKey = "screenshotCopyToClipboard"

    // MARK: - Published Properties

    @Published var customSizes: [PresetSize] = []

    @Published var launchAtLogin: Bool = false {
        didSet {
            updateLoginItem(launchAtLogin)
            UserDefaults.standard.set(launchAtLogin, forKey: launchAtLoginKey)
        }
    }

    // Screenshot settings — each persists immediately on change.
    @Published var screenshotEnabled: Bool = false {
        didSet { UserDefaults.standard.set(screenshotEnabled, forKey: screenshotEnabledKey) }
    }
    @Published var screenshotSaveToFile: Bool = true {
        didSet { UserDefaults.standard.set(screenshotSaveToFile, forKey: screenshotSaveToFileKey) }
    }
    @Published var screenshotSaveLocation: ScreenshotSaveLocation = .desktop {
        didSet { UserDefaults.standard.set(screenshotSaveLocation.rawValue, forKey: screenshotSaveLocationKey) }
    }
    @Published var screenshotCopyToClipboard: Bool = false {
        didSet { UserDefaults.standard.set(screenshotCopyToClipboard, forKey: screenshotCopyToClipboardKey) }
    }

    // MARK: - Built-in Presets

    /// The 12 built-in presets covering Mac Retina logical resolutions and
    /// common standard display sizes. These are not editable by the user.
    static let builtInSizes: [PresetSize] = [
        // Retina Mac resolutions (logical pixels)
        PresetSize(width: 2560, height: 1600, label: "MacBook Pro 16\""),
        PresetSize(width: 2560, height: 1440, label: "QHD / iMac"),
        PresetSize(width: 1728, height: 1117, label: "MacBook Pro 14\""),
        PresetSize(width: 1512, height: 982,  label: "MacBook Air 15\""),
        PresetSize(width: 1470, height: 956,  label: "MacBook Air 13\" M3"),
        PresetSize(width: 1440, height: 900,  label: "MacBook Air 13\""),
        // Standard resolutions
        PresetSize(width: 1920, height: 1080, label: "Full HD"),
        PresetSize(width: 1680, height: 1050, label: "WSXGA+"),
        PresetSize(width: 1280, height: 800,  label: "WXGA"),
        PresetSize(width: 1280, height: 720,  label: "HD"),
        PresetSize(width: 1024, height: 768,  label: "XGA"),
        PresetSize(width: 800,  height: 600,  label: "SVGA"),
    ]

    /// All available presets: built-in followed by user-defined custom sizes.
    var allPresets: [PresetSize] {
        Self.builtInSizes + customSizes
    }

    // MARK: - Initialization

    /// Loads all saved preferences from UserDefaults.
    /// screenshotSaveToFile defaults to true when no saved value exists.
    init() {
        loadCustomPresets()
        launchAtLogin = UserDefaults.standard.bool(forKey: launchAtLoginKey)
        screenshotEnabled = UserDefaults.standard.bool(forKey: screenshotEnabledKey)

        // screenshotSaveToFile defaults to true if the key has never been set.
        if UserDefaults.standard.object(forKey: screenshotSaveToFileKey) != nil {
            screenshotSaveToFile = UserDefaults.standard.bool(forKey: screenshotSaveToFileKey)
        }
        if let raw = UserDefaults.standard.string(forKey: screenshotSaveLocationKey),
           let loc = ScreenshotSaveLocation(rawValue: raw) {
            screenshotSaveLocation = loc
        }
        screenshotCopyToClipboard = UserDefaults.standard.bool(forKey: screenshotCopyToClipboardKey)
    }

    // MARK: - Custom Preset Management

    func addSize(_ size: PresetSize) {
        customSizes.append(size)
        persistCustomPresets()
        NotificationCenter.default.post(name: .settingsChanged, object: nil)
    }

    func removeSize(at offsets: IndexSet) {
        customSizes.remove(atOffsets: offsets)
        persistCustomPresets()
        NotificationCenter.default.post(name: .settingsChanged, object: nil)
    }

    /// Loads custom presets from UserDefaults (JSON-encoded [PresetSize] array).
    private func loadCustomPresets() {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey) else { return }
        if let decoded = try? JSONDecoder().decode([PresetSize].self, from: data) {
            customSizes = decoded
        }
    }

    /// Persists custom presets to UserDefaults as JSON.
    private func persistCustomPresets() {
        if let encoded = try? JSONEncoder().encode(customSizes) {
            UserDefaults.standard.set(encoded, forKey: defaultsKey)
        }
    }

    // MARK: - Login Item

    /// Registers or unregisters this app as a login item via SMAppService.
    /// SMAppService is the modern replacement for SMLoginItemSetEnabled,
    /// available from macOS 13+.
    private func updateLoginItem(_ enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Launch at login error: \(error)")
            }
        }
    }
}
