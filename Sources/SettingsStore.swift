// SettingsStore.swift — Single source of truth for all user preferences.
// Publishes changes via Combine (@Published) for SwiftUI bindings.

import AppKit
import Combine
import ServiceManagement

class SettingsStore: ObservableObject {
    static let shared = SettingsStore()

    // MARK: - UserDefaults Keys

    private let defaultsKey = "customPresetSizes"
    private let launchAtLoginKey = "launchAtLogin"
    private let appLanguageKey = "appLanguage"
    private let resizeBorderColorKey = "resizeBorderColor"
    private let resizeBorderDashedKey = "resizeBorderDashed"
    private let snapBorderColorKey = "snapBorderColor"
    private let snapBorderDashedKey = "snapBorderDashed"
    private let showResizeOverlayKey = "showResizeOverlay"
    private let showRatioLabelKey = "showRatioLabel"
    private let shiftToLockRatioKey = "shiftToLockRatio"
    private let quickPresetsKey = "quickPresets"
    private let shortcutBindingsKey = "shortcutBindings"

    // MARK: - Published Properties

    @Published var customSizes: [PresetSize] = []

    @Published var launchAtLogin: Bool = false {
        didSet {
            updateLoginItem(launchAtLogin)
            UserDefaults.standard.set(launchAtLogin, forKey: launchAtLoginKey)
        }
    }

    // Language override — "system" follows OS setting, otherwise a specific locale code.
    @Published var appLanguage: String = "system" {
        didSet {
            UserDefaults.standard.set(appLanguage, forKey: appLanguageKey)
            applyLanguage()
        }
    }

    // MARK: - Overlay Appearance Settings

    /// Border color name for resize overlay (no snap candidate).
    @Published var resizeBorderColor: String = "orange" {
        didSet { UserDefaults.standard.set(resizeBorderColor, forKey: resizeBorderColorKey) }
    }

    /// Whether the resize overlay border is dashed (true) or solid (false).
    @Published var resizeBorderDashed: Bool = true {
        didSet { UserDefaults.standard.set(resizeBorderDashed, forKey: resizeBorderDashedKey) }
    }

    /// Border color name for snap overlay (snap candidate active).
    @Published var snapBorderColor: String = "orange" {
        didSet { UserDefaults.standard.set(snapBorderColor, forKey: snapBorderColorKey) }
    }

    /// Whether the snap overlay border is dashed (true) or solid (false).
    @Published var snapBorderDashed: Bool = false {
        didSet { UserDefaults.standard.set(snapBorderDashed, forKey: snapBorderDashedKey) }
    }

    /// Whether to show the overlay border during resize (non-snap).
    /// When false, the overlay is only shown when a snap candidate is detected.
    @Published var showResizeOverlay: Bool = true {
        didSet { UserDefaults.standard.set(showResizeOverlay, forKey: showResizeOverlayKey) }
    }

    /// Whether to show the aspect ratio label at the opposite corner during resize.
    @Published var showRatioLabel: Bool = true {
        didSet { UserDefaults.standard.set(showRatioLabel, forKey: showRatioLabelKey) }
    }

    /// Whether holding Shift during resize constrains the aspect ratio.
    @Published var shiftToLockRatio: Bool = true {
        didSet { UserDefaults.standard.set(shiftToLockRatio, forKey: shiftToLockRatioKey) }
    }

    // MARK: - Quick Presets (Keyboard Shortcuts ⌃⌥1–9)

    /// User-configurable quick presets applied via ⌃⌥1–9 keyboard shortcuts.
    /// Each preset has a usage-based label (e.g. "📝 Writing") and a target
    /// size. Maximum 9 entries.
    @Published var quickPresets: [PresetSize] = [] {
        didSet { persistQuickPresets() }
    }

    /// Default quick presets provided on first launch — usage-based labels
    /// with sizes chosen for common workflows.
    static let defaultQuickPresets: [PresetSize] = [
        PresetSize(width: 1280, height: 800,  label: "Writing"),
        PresetSize(width: 1440, height: 900,  label: "Coding"),
        PresetSize(width: 1200, height: 900,  label: "Browsing"),
        PresetSize(width: 900,  height: 1200, label: "Chat"),
        PresetSize(width: 1920, height: 1080, label: "Preview"),
    ]

    // MARK: - Keyboard Shortcut Bindings

    /// A single keyboard shortcut binding: modifier flags + key code.
    struct ShortcutBinding: Codable, Equatable {
        var modifiers: UInt      // NSEvent.ModifierFlags.rawValue (device-independent)
        var keyCode: UInt16      // macOS virtual key code
    }

    /// User-customizable keyboard shortcut bindings.
    /// Keys are action IDs (e.g. "growWidth", "preset1"), values are bindings.
    @Published var shortcutBindings: [String: ShortcutBinding] = [:] {
        didSet { persistShortcutBindings() }
    }

    /// All action IDs in display order, grouped by category.
    static let resizeActionIDs = ["growWidth", "shrinkWidth", "growHeight", "shrinkHeight"]
    static let precisionActionIDs = ["precisionGrowWidth", "precisionShrinkWidth",
                                     "precisionGrowHeight", "precisionShrinkHeight"]
    static let undoRedoActionIDs = ["undo", "redo"]
    static let presetActionIDs = (1...9).map { "preset\($0)" }

    /// Control + Option modifier flags value (used as base for defaults).
    private static let ctrlOpt = NSEvent.ModifierFlags([.control, .option])
        .intersection(.deviceIndependentFlagsMask).rawValue
    private static let ctrlOptShift = NSEvent.ModifierFlags([.control, .option, .shift])
        .intersection(.deviceIndependentFlagsMask).rawValue

    /// Default shortcut bindings matching the original hard-coded shortcuts.
    static let defaultShortcutBindings: [String: ShortcutBinding] = {
        var map: [String: ShortcutBinding] = [:]

        // Resize (±10px): ⌃⌥ + arrows
        map["growWidth"]    = ShortcutBinding(modifiers: ctrlOpt, keyCode: 124) // →
        map["shrinkWidth"]  = ShortcutBinding(modifiers: ctrlOpt, keyCode: 123) // ←
        map["growHeight"]   = ShortcutBinding(modifiers: ctrlOpt, keyCode: 126) // ↑
        map["shrinkHeight"] = ShortcutBinding(modifiers: ctrlOpt, keyCode: 125) // ↓

        // Precision (±1px): ⌃⌥⇧ + arrows
        map["precisionGrowWidth"]    = ShortcutBinding(modifiers: ctrlOptShift, keyCode: 124)
        map["precisionShrinkWidth"]  = ShortcutBinding(modifiers: ctrlOptShift, keyCode: 123)
        map["precisionGrowHeight"]   = ShortcutBinding(modifiers: ctrlOptShift, keyCode: 126)
        map["precisionShrinkHeight"] = ShortcutBinding(modifiers: ctrlOptShift, keyCode: 125)

        // Undo / Redo
        map["undo"] = ShortcutBinding(modifiers: ctrlOpt, keyCode: 6)      // ⌃⌥Z
        map["redo"] = ShortcutBinding(modifiers: ctrlOptShift, keyCode: 6)  // ⌃⌥⇧Z

        // Quick presets: ⌃⌥ + digit keys (1-9)
        let digitKeyCodes: [UInt16] = [18, 19, 20, 21, 23, 22, 26, 28, 25]
        for i in 0..<9 {
            map["preset\(i + 1)"] = ShortcutBinding(modifiers: ctrlOpt, keyCode: digitKeyCodes[i])
        }

        return map
    }()

    /// Known macOS system shortcuts used for conflict detection.
    /// This list covers common defaults; it is not exhaustive.
    static let knownSystemShortcuts: [ShortcutBinding] = {
        let ctrl = NSEvent.ModifierFlags([.control])
            .intersection(.deviceIndependentFlagsMask).rawValue
        let ctrlOpt = NSEvent.ModifierFlags([.control, .option])
            .intersection(.deviceIndependentFlagsMask).rawValue
        let cmd = NSEvent.ModifierFlags([.command])
            .intersection(.deviceIndependentFlagsMask).rawValue
        let cmdShift = NSEvent.ModifierFlags([.command, .shift])
            .intersection(.deviceIndependentFlagsMask).rawValue

        return [
            // Mission Control
            ShortcutBinding(modifiers: ctrl, keyCode: 126),     // ⌃↑
            ShortcutBinding(modifiers: ctrl, keyCode: 125),     // ⌃↓
            ShortcutBinding(modifiers: ctrl, keyCode: 123),     // ⌃← (Spaces left)
            ShortcutBinding(modifiers: ctrl, keyCode: 124),     // ⌃→ (Spaces right)
            // Spotlight
            ShortcutBinding(modifiers: cmd, keyCode: 49),       // ⌘Space
            // Screenshots
            ShortcutBinding(modifiers: cmdShift, keyCode: 20),  // ⌘⇧3
            ShortcutBinding(modifiers: cmdShift, keyCode: 21),  // ⌘⇧4
            ShortcutBinding(modifiers: cmdShift, keyCode: 23),  // ⌘⇧5
            // App Switcher
            ShortcutBinding(modifiers: cmd, keyCode: 48),       // ⌘Tab
            // Input source switch
            ShortcutBinding(modifiers: ctrl, keyCode: 49),      // ⌃Space
            ShortcutBinding(modifiers: ctrlOpt, keyCode: 49),   // ⌃⌥Space
        ]
    }()

    /// Returns true if the given binding conflicts with a known system shortcut.
    func conflictsWithSystem(_ binding: ShortcutBinding) -> Bool {
        Self.knownSystemShortcuts.contains(binding)
    }

    /// Returns the localized display name of another action that uses the same
    /// binding, or nil if there is no conflict. The `excluding` parameter is
    /// the action ID being edited (to avoid self-conflict).
    func conflictsWithOtherAction(_ binding: ShortcutBinding,
                                   excluding actionID: String) -> String? {
        for (otherID, otherBinding) in shortcutBindings {
            if otherID != actionID && otherBinding == binding {
                return Self.localizedActionName(otherID)
            }
        }
        return nil
    }

    /// Human-readable display string for a shortcut binding (e.g. "⌃⌥→").
    static func displayString(for binding: ShortcutBinding) -> String {
        let mods = NSEvent.ModifierFlags(rawValue: binding.modifiers)
        var result = ""
        if mods.contains(.control) { result += "⌃" }
        if mods.contains(.option)  { result += "⌥" }
        if mods.contains(.shift)   { result += "⇧" }
        if mods.contains(.command) { result += "⌘" }
        result += keyName(for: binding.keyCode)
        return result
    }

    /// Display string for a specific action ID, using its current binding.
    func shortcutDisplayString(for actionID: String) -> String {
        guard let binding = shortcutBindings[actionID] else { return "—" }
        return Self.displayString(for: binding)
    }

    /// Resets all shortcut bindings to their factory defaults.
    func resetShortcutsToDefaults() {
        shortcutBindings = Self.defaultShortcutBindings
    }

    /// Localized display name for an action ID (used in conflict messages).
    static func localizedActionName(_ actionID: String) -> String {
        switch actionID {
        case "growWidth":               return L("settings.shortcuts.grow-width")
        case "shrinkWidth":             return L("settings.shortcuts.shrink-width")
        case "growHeight":              return L("settings.shortcuts.grow-height")
        case "shrinkHeight":            return L("settings.shortcuts.shrink-height")
        case "precisionGrowWidth":      return L("settings.shortcuts.grow-width")
        case "precisionShrinkWidth":    return L("settings.shortcuts.shrink-width")
        case "precisionGrowHeight":     return L("settings.shortcuts.grow-height")
        case "precisionShrinkHeight":   return L("settings.shortcuts.shrink-height")
        case "undo":                    return L("settings.shortcuts.undo")
        case "redo":                    return L("settings.shortcuts.redo")
        default:
            if actionID.hasPrefix("preset") {
                let num = actionID.dropFirst(6)
                return "Quick Preset \(num)"
            }
            return actionID
        }
    }

    /// Converts a macOS virtual key code to a human-readable key name.
    private static func keyName(for keyCode: UInt16) -> String {
        switch keyCode {
        // Arrow keys
        case 123: return "←"
        case 124: return "→"
        case 125: return "↓"
        case 126: return "↑"
        // Letter keys
        case 0: return "A"
        case 11: return "B"
        case 8: return "C"
        case 2: return "D"
        case 14: return "E"
        case 3: return "F"
        case 5: return "G"
        case 4: return "H"
        case 34: return "I"
        case 38: return "J"
        case 40: return "K"
        case 37: return "L"
        case 46: return "M"
        case 45: return "N"
        case 31: return "O"
        case 35: return "P"
        case 12: return "Q"
        case 15: return "R"
        case 1: return "S"
        case 17: return "T"
        case 32: return "U"
        case 9: return "V"
        case 13: return "W"
        case 7: return "X"
        case 16: return "Y"
        case 6: return "Z"
        // Digit keys (main keyboard row)
        case 29: return "0"
        case 18: return "1"
        case 19: return "2"
        case 20: return "3"
        case 21: return "4"
        case 23: return "5"
        case 22: return "6"
        case 26: return "7"
        case 28: return "8"
        case 25: return "9"
        // Function keys
        case 122: return "F1"
        case 120: return "F2"
        case 99:  return "F3"
        case 118: return "F4"
        case 96:  return "F5"
        case 97:  return "F6"
        case 98:  return "F7"
        case 100: return "F8"
        case 101: return "F9"
        case 109: return "F10"
        case 103: return "F11"
        case 111: return "F12"
        // Special keys
        case 49: return "Space"
        case 48: return "Tab"
        case 36: return "Return"
        case 51: return "Delete"
        case 53: return "Esc"
        case 71: return "Clear"
        case 76: return "Enter"
        // Numpad digits
        case 82: return "Num 0"
        case 83: return "Num 1"
        case 84: return "Num 2"
        case 85: return "Num 3"
        case 86: return "Num 4"
        case 87: return "Num 5"
        case 88: return "Num 6"
        case 89: return "Num 7"
        case 91: return "Num 8"
        case 92: return "Num 9"
        // Punctuation
        case 27: return "-"
        case 24: return "="
        case 33: return "["
        case 30: return "]"
        case 42: return "\\"
        case 41: return ";"
        case 39: return "'"
        case 43: return ","
        case 47: return "."
        case 44: return "/"
        case 50: return "`"
        default: return "Key \(keyCode)"
        }
    }

    /// Loads shortcut bindings from UserDefaults. Falls back to defaults
    /// on first launch.
    private func loadShortcutBindings() {
        guard let data = UserDefaults.standard.data(forKey: shortcutBindingsKey) else {
            shortcutBindings = Self.defaultShortcutBindings
            return
        }
        if let decoded = try? JSONDecoder().decode([String: ShortcutBinding].self, from: data) {
            // Merge with defaults so new actions added in updates get their defaults.
            var merged = Self.defaultShortcutBindings
            for (key, value) in decoded { merged[key] = value }
            shortcutBindings = merged
        } else {
            shortcutBindings = Self.defaultShortcutBindings
        }
    }

    /// Persists shortcut bindings to UserDefaults as JSON.
    private func persistShortcutBindings() {
        if let encoded = try? JSONEncoder().encode(shortcutBindings) {
            UserDefaults.standard.set(encoded, forKey: shortcutBindingsKey)
        }
    }

    /// Predefined color options for overlay borders.
    /// Each entry has an internal name, a localization key, and an NSColor.
    static let borderColorOptions: [(name: String, locKey: String, color: NSColor)] = [
        ("orange", "settings.color.orange", NSColor(calibratedRed: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)),
        ("blue",   "settings.color.blue",   NSColor.systemBlue),
        ("green",  "settings.color.green",  NSColor.systemGreen),
        ("red",    "settings.color.red",    NSColor.systemRed),
        ("purple", "settings.color.purple", NSColor.systemPurple),
        ("white",  "settings.color.white",  NSColor.white),
    ]

    /// Converts a color name to an NSColor for overlay rendering.
    static func nsColor(forName name: String) -> NSColor {
        switch name {
        case "blue":   return NSColor.systemBlue
        case "green":  return NSColor.systemGreen
        case "red":    return NSColor.systemRed
        case "purple": return NSColor.systemPurple
        case "white":  return NSColor.white
        default:       return NSColor(calibratedRed: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)
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

    /// All available presets for drag snap detection: built-in sizes plus
    /// quick presets. Quick presets are included so that drag-resizing near
    /// a quick preset size also triggers a snap.
    var allPresets: [PresetSize] {
        Self.builtInSizes + customSizes + quickPresets
    }

    // MARK: - Initialization

    /// Loads all saved preferences from UserDefaults.
    init() {
        loadCustomPresets()
        launchAtLogin = UserDefaults.standard.bool(forKey: launchAtLoginKey)
        if let lang = UserDefaults.standard.string(forKey: appLanguageKey) {
            appLanguage = lang
        }

        // Load overlay appearance settings (use defaults if not yet stored).
        let defaults = UserDefaults.standard
        if let color = defaults.string(forKey: resizeBorderColorKey) {
            resizeBorderColor = color
        }
        if defaults.object(forKey: resizeBorderDashedKey) != nil {
            resizeBorderDashed = defaults.bool(forKey: resizeBorderDashedKey)
        }
        if let color = defaults.string(forKey: snapBorderColorKey) {
            snapBorderColor = color
        }
        if defaults.object(forKey: snapBorderDashedKey) != nil {
            snapBorderDashed = defaults.bool(forKey: snapBorderDashedKey)
        }
        if defaults.object(forKey: showResizeOverlayKey) != nil {
            showResizeOverlay = defaults.bool(forKey: showResizeOverlayKey)
        }
        if defaults.object(forKey: showRatioLabelKey) != nil {
            showRatioLabel = defaults.bool(forKey: showRatioLabelKey)
        }
        if defaults.object(forKey: shiftToLockRatioKey) != nil {
            shiftToLockRatio = defaults.bool(forKey: shiftToLockRatioKey)
        }

        // Load quick presets; use defaults on first launch.
        loadQuickPresets()

        // Load keyboard shortcut bindings; use defaults on first launch.
        loadShortcutBindings()
    }

    // MARK: - Custom Preset Management

    /// Appends a new custom preset and persists to UserDefaults.
    func addSize(_ size: PresetSize) {
        customSizes.append(size)
        persistCustomPresets()
    }

    /// Removes custom presets at the given offsets and persists to UserDefaults.
    func removeSize(at offsets: IndexSet) {
        customSizes.remove(atOffsets: offsets)
        persistCustomPresets()
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

    // MARK: - Quick Preset Management

    /// Loads quick presets from UserDefaults. Falls back to the built-in
    /// defaults on first launch (key absent).
    private func loadQuickPresets() {
        guard let data = UserDefaults.standard.data(forKey: quickPresetsKey) else {
            // First launch: populate with defaults.
            quickPresets = Self.defaultQuickPresets
            return
        }
        if let decoded = try? JSONDecoder().decode([PresetSize].self, from: data) {
            quickPresets = decoded
        } else {
            quickPresets = Self.defaultQuickPresets
        }
    }

    /// Persists the current quick presets array to UserDefaults as JSON.
    private func persistQuickPresets() {
        if let encoded = try? JSONEncoder().encode(quickPresets) {
            UserDefaults.standard.set(encoded, forKey: quickPresetsKey)
        }
    }

    /// Adds a quick preset. Maximum 9 entries; extras are silently ignored.
    func addQuickPreset(_ preset: PresetSize) {
        guard quickPresets.count < 9 else { return }
        quickPresets.append(preset)
    }

    /// Removes the quick preset at the given index.
    func removeQuickPreset(at index: Int) {
        guard quickPresets.indices.contains(index) else { return }
        quickPresets.remove(at: index)
    }

    /// Updates the quick preset at the given index with new values.
    func updateQuickPreset(at index: Int, preset: PresetSize) {
        guard quickPresets.indices.contains(index) else { return }
        quickPresets[index] = preset
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
