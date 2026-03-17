// SettingsStore.swift — Single source of truth for all user preferences.
// Publishes changes via Combine (@Published) for SwiftUI bindings, and
// posts .settingsChanged notifications so AppDelegate can rebuild the menu
// when presets change.

import AppKit
import Combine
import ServiceManagement

extension Notification.Name {
    static let settingsChanged = Notification.Name("com.windowresize.settingsChanged")
}

class SettingsStore: ObservableObject {
    static let shared = SettingsStore()

    // MARK: - UserDefaults Keys

    private let defaultsKey = "customPresetSizes"
    private let launchAtLoginKey = "launchAtLogin"
    private let bringToFrontKey = "bringToFront"
    private let windowPositionKey = "windowPosition"
    private let moveToMainScreenKey = "moveToMainScreen"
    private let appLanguageKey = "appLanguage"

    // MARK: - Published Properties

    @Published var customSizes: [PresetSize] = []

    @Published var launchAtLogin: Bool = false {
        didSet {
            updateLoginItem(launchAtLogin)
            UserDefaults.standard.set(launchAtLogin, forKey: launchAtLoginKey)
        }
    }

    // Accessibility feature settings — bring to front, positioning, main screen.
    @Published var bringToFront: Bool = true {
        didSet { UserDefaults.standard.set(bringToFront, forKey: bringToFrontKey) }
    }
    @Published var windowPosition: WindowPosition? = nil {
        didSet {
            if let pos = windowPosition {
                UserDefaults.standard.set(pos.rawValue, forKey: windowPositionKey)
            } else {
                UserDefaults.standard.removeObject(forKey: windowPositionKey)
            }
        }
    }
    @Published var moveToMainScreen: Bool = false {
        didSet { UserDefaults.standard.set(moveToMainScreen, forKey: moveToMainScreenKey) }
    }

    // Language override — "system" follows OS setting, otherwise a specific locale code.
    @Published var appLanguage: String = "system" {
        didSet {
            UserDefaults.standard.set(appLanguage, forKey: appLanguageKey)
            applyLanguage()
        }
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
    init() {
        loadCustomPresets()
        launchAtLogin = UserDefaults.standard.bool(forKey: launchAtLoginKey)

        // bringToFront defaults to true if the key has never been set.
        if UserDefaults.standard.object(forKey: bringToFrontKey) != nil {
            bringToFront = UserDefaults.standard.bool(forKey: bringToFrontKey)
        }
        if let posRaw = UserDefaults.standard.string(forKey: windowPositionKey),
           let pos = WindowPosition(rawValue: posRaw) {
            windowPosition = pos
        }
        moveToMainScreen = UserDefaults.standard.bool(forKey: moveToMainScreenKey)
        if let lang = UserDefaults.standard.string(forKey: appLanguageKey) {
            appLanguage = lang
        }
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

    // MARK: - Language

    /// Sets the AppleLanguages UserDefaults key to override the app's locale.
    /// When set to "system", removes the override so the OS default is used.
    func applyLanguage() {
        if appLanguage == "system" {
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
        } else {
            UserDefaults.standard.set([appLanguage], forKey: "AppleLanguages")
        }
    }

    /// Relaunches the app by spawning a shell that waits for this process
    /// to exit, then re-opens the bundle. Used after language changes.
    func relaunchApp() {
        let path = Bundle.main.bundlePath
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/sh")
        process.arguments = ["-c", "sleep 0.5 && open \"\(path)\""]
        try? process.run()
        NSApp.terminate(nil)
    }

    /// Returns true if any accessibility feature (bring-to-front, positioning,
    /// or move-to-main-screen) is active. Used to show the "keep current size"
    /// option in the preset size menu.
    var hasActiveAccessibilityFeatures: Bool {
        bringToFront || windowPosition != nil || moveToMainScreen
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
