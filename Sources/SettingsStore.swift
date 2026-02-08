import Foundation
import Combine
import ServiceManagement

extension Notification.Name {
    static let settingsChanged = Notification.Name("com.windowresize.settingsChanged")
}

class SettingsStore: ObservableObject {
    static let shared = SettingsStore()

    private let defaultsKey = "customPresetSizes"
    private let launchAtLoginKey = "launchAtLogin"

    @Published var customSizes: [PresetSize] = []
    @Published var launchAtLogin: Bool = false {
        didSet {
            setLaunchAtLogin(launchAtLogin)
            UserDefaults.standard.set(launchAtLogin, forKey: launchAtLoginKey)
        }
    }

    static let builtInSizes: [PresetSize] = [
        // Retina Mac 解像度（論理ピクセル） / Retina Mac resolutions (logical pixels)
        PresetSize(width: 2560, height: 1600, label: "MacBook Pro 16\""),
        PresetSize(width: 2560, height: 1440, label: "QHD / iMac"),
        PresetSize(width: 1728, height: 1117, label: "MacBook Pro 14\""),
        PresetSize(width: 1512, height: 982,  label: "MacBook Air 15\""),
        PresetSize(width: 1470, height: 956,  label: "MacBook Air 13\" M3"),
        PresetSize(width: 1440, height: 900,  label: "MacBook Air 13\""),
        // 標準解像度 / Standard resolutions
        PresetSize(width: 1920, height: 1080, label: "Full HD"),
        PresetSize(width: 1680, height: 1050, label: "WSXGA+"),
        PresetSize(width: 1280, height: 800,  label: "WXGA"),
        PresetSize(width: 1280, height: 720,  label: "HD"),
        PresetSize(width: 1024, height: 768,  label: "XGA"),
        PresetSize(width: 800,  height: 600,  label: "SVGA"),
    ]

    var allSizes: [PresetSize] {
        Self.builtInSizes + customSizes
    }

    init() {
        loadFromDefaults()
        launchAtLogin = UserDefaults.standard.bool(forKey: launchAtLoginKey)
    }

    func addSize(_ size: PresetSize) {
        customSizes.append(size)
        saveToDefaults()
        NotificationCenter.default.post(name: .settingsChanged, object: nil)
    }

    func removeSize(at offsets: IndexSet) {
        customSizes.remove(atOffsets: offsets)
        saveToDefaults()
        NotificationCenter.default.post(name: .settingsChanged, object: nil)
    }

    private func loadFromDefaults() {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey) else { return }
        if let decoded = try? JSONDecoder().decode([PresetSize].self, from: data) {
            customSizes = decoded
        }
    }

    private func saveToDefaults() {
        if let encoded = try? JSONEncoder().encode(customSizes) {
            UserDefaults.standard.set(encoded, forKey: defaultsKey)
        }
    }

    private func setLaunchAtLogin(_ enabled: Bool) {
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
