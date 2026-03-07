// SettingsView.swift — SwiftUI settings panel displayed in a standalone
// NSWindow (via SettingsWindowController). Provides UI for viewing built-in
// presets, managing custom presets, configuring launch-at-login, screenshot
// options, and Accessibility permission status.

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var store = SettingsStore.shared
    @State private var newWidth: String = ""
    @State private var newHeight: String = ""
    @State private var showRestartAlert = false

    /// Supported languages shown with their native names so users can
    /// identify them regardless of the current app language.
    private let supportedLanguages: [(code: String, name: String)] = [
        ("en", "English"),
        ("ja", "日本語"),
        ("zh-Hans", "简体中文"),
        ("zh-Hant", "繁體中文"),
        ("ko", "한국어"),
        ("es", "Español"),
        ("fr", "Français"),
        ("de", "Deutsch"),
        ("it", "Italiano"),
        ("pt", "Português"),
        ("ru", "Русский"),
        ("ar", "العربية"),
        ("hi", "हिन्दी"),
        ("id", "Bahasa Indonesia"),
        ("vi", "Tiếng Việt"),
        ("th", "ไทย"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L("settings.preset-sizes"))
                .font(.headline)

            // Built-in presets: read-only list of the 12 default sizes.
            GroupBox(label: Text(L("settings.built-in")).font(.subheadline)) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(SettingsStore.builtInSizes) { size in
                            HStack {
                                Text(size.displayName)
                                Spacer()
                                if let label = size.label {
                                    Text(label)
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                        .frame(width: 150, alignment: .trailing)
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .frame(maxHeight: 130)
            }

            // Custom presets: user-defined sizes with add/remove controls.
            GroupBox(label: Text(L("settings.custom")).font(.subheadline)) {
                VStack(alignment: .leading, spacing: 4) {
                    if store.customSizes.isEmpty {
                        Text(L("settings.no-custom-sizes"))
                            .foregroundColor(.secondary)
                            .font(.caption)
                            .padding(.vertical, 4)
                    } else {
                        ForEach(store.customSizes) { size in
                            HStack {
                                Text(size.displayName)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Button(L("settings.remove")) {
                                    if let idx = store.customSizes.firstIndex(where: { $0.id == size.id }) {
                                        store.removeSize(at: IndexSet(integer: idx))
                                    }
                                }
                                .foregroundColor(.red)
                                .buttonStyle(.borderless)
                            }
                            .padding(.vertical, 2)
                        }
                    }

                    Divider()

                    // Input fields for adding a new custom size.
                    // Validates that both width and height are positive integers.
                    HStack {
                        TextField(L("settings.width"), text: $newWidth)
                            .frame(width: 80)
                            .textFieldStyle(.roundedBorder)
                        Text(L("settings.dimension-separator"))
                        TextField(L("settings.height"), text: $newHeight)
                            .frame(width: 80)
                            .textFieldStyle(.roundedBorder)
                        Button(L("settings.add")) {
                            guard let w = Int(newWidth), let h = Int(newHeight),
                                  w > 0, h > 0 else { return }
                            store.addSize(PresetSize(width: w, height: h))
                            newWidth = ""
                            newHeight = ""
                        }
                        .disabled(Int(newWidth) == nil || Int(newHeight) == nil)
                    }
                    .padding(.vertical, 4)
                }
                .padding(.vertical, 4)
            }

            Divider()

            // Launch at Login toggle — uses SMAppService under the hood.
            Toggle(L("settings.launch-at-login"), isOn: $store.launchAtLogin)
                .toggleStyle(.switch)

            Divider()

            // Accessibility features: bring-to-front, move-to-main-screen, positioning.
            Toggle(L("settings.bring-to-front"), isOn: $store.bringToFront)
                .toggleStyle(.switch)

            Toggle(L("settings.move-to-main-screen"), isOn: $store.moveToMainScreen)
                .toggleStyle(.switch)

            // Window position: horizontal row of 9 buttons using inset-rectangle
            // SF Symbols, grouped visually as top / middle / bottom rows.
            HStack {
                Text(L("settings.window-position"))
                Spacer()
                if store.windowPosition != nil {
                    Button(L("settings.window-position.none")) {
                        store.windowPosition = nil
                    }
                    .font(.caption)
                    .buttonStyle(.borderless)
                }
            }
            positionRow

            Divider()

            // Screenshot settings — the master toggle gates visibility of sub-options.
            // Save-to-file and copy-to-clipboard can be enabled independently.
            Toggle(L("settings.screenshot.enabled"), isOn: $store.screenshotEnabled)
                .toggleStyle(.switch)

            if store.screenshotEnabled {
                Toggle(L("settings.screenshot.save-to-file"), isOn: $store.screenshotSaveToFile)
                    .toggleStyle(.switch)
                    .font(.caption)

                if store.screenshotSaveToFile {
                    HStack {
                        Image(systemName: "folder")
                            .font(.caption)
                        Text(store.screenshotSaveFolderPath ?? L("settings.screenshot.no-folder-selected"))
                            .font(.caption)
                            .foregroundColor(store.screenshotSaveFolderPath != nil ? .primary : .secondary)
                            .lineLimit(1)
                            .truncationMode(.middle)
                        Spacer()
                        Button(L("settings.screenshot.choose-folder.button")) {
                            store.selectScreenshotFolder()
                        }
                        .font(.caption)
                    }
                    .padding(.leading, 20)
                    .onChange(of: store.screenshotSaveToFile) { newValue in
                        // Auto-show folder picker when save-to-file is enabled
                        // but no folder is selected yet.
                        if newValue && store.screenshotSaveFolderPath == nil {
                            if !store.selectScreenshotFolder() {
                                store.screenshotSaveToFile = false
                            }
                        }
                    }
                }

                Toggle(L("settings.screenshot.copy-to-clipboard"), isOn: $store.screenshotCopyToClipboard)
                    .toggleStyle(.switch)
                    .font(.caption)
            }

            Divider()

            // Language picker — allows overriding the app language for
            // screenshots and testing. Requires restart to take effect.
            HStack {
                Text(L("settings.language"))
                Spacer()
                Picker("", selection: $store.appLanguage) {
                    Text(L("settings.language.system")).tag("system")
                    Divider()
                    ForEach(supportedLanguages, id: \.code) { lang in
                        Text(lang.name).tag(lang.code)
                    }
                }
                .frame(width: 180)
                .onChange(of: store.appLanguage) { _ in
                    showRestartAlert = true
                }
            }

            Divider()

            // Accessibility permission status indicator.
            // Green = working, Orange = granted but stale, Red = not granted.
            HStack {
                let granted = AccessibilityHelper.isPermissionGranted()
                let functional = AccessibilityHelper.isPermissionFunctional()

                Circle()
                    .fill(functional ? Color.green : (granted ? Color.orange : Color.red))
                    .frame(width: 10, height: 10)

                if functional {
                    Text(L("settings.accessibility.enabled"))
                        .font(.caption)
                } else if granted {
                    Text(L("settings.accessibility.needs-refresh"))
                        .font(.caption)
                        .foregroundColor(.orange)
                } else {
                    Text(L("settings.accessibility.not-enabled"))
                        .font(.caption)
                }

                Spacer()

                if !functional {
                    Button(L("alert.button.open-settings")) {
                        AccessibilityHelper.openSystemSettings()
                    }
                    .font(.caption)
                }
            }
        }
        .padding()
        .frame(width: 400)
        .alert(L("settings.language.restart-title"), isPresented: $showRestartAlert) {
            Button(L("settings.language.restart-button")) {
                store.relaunchApp()
            }
            Button(L("settings.language.restart-later"), role: .cancel) { }
        } message: {
            Text(L("settings.language.restart-body"))
        }
    }

    // MARK: - Position Row

    /// A horizontal row of 9 buttons representing the window anchor positions.
    /// Uses inset-rectangle SF Symbols to show where the window will be placed.
    /// Grouped visually as top-row / middle-row / bottom-row with wider gaps.
    private var positionRow: some View {
        HStack(spacing: 2) {
            // Top row: top-left, top, top-right
            positionButton(.topLeft, symbol: "inset.filled.topleft.rectangle")
            positionButton(.top, symbol: "inset.filled.tophalf.rectangle")
            positionButton(.topRight, symbol: "inset.filled.topright.rectangle")

            Spacer().frame(width: 6)

            // Middle row: left, center, right
            positionButton(.left, symbol: "inset.filled.leadinghalf.rectangle")
            positionButton(.center, symbol: "inset.filled.center.rectangle")
            positionButton(.right, symbol: "inset.filled.trailinghalf.rectangle")

            Spacer().frame(width: 6)

            // Bottom row: bottom-left, bottom, bottom-right
            positionButton(.bottomLeft, symbol: "inset.filled.bottomleft.rectangle")
            positionButton(.bottom, symbol: "inset.filled.bottomhalf.rectangle")
            positionButton(.bottomRight, symbol: "inset.filled.bottomright.rectangle")
        }
    }

    /// A single position button with toggle behavior.
    private func positionButton(_ position: WindowPosition, symbol: String) -> some View {
        let isSelected = store.windowPosition == position
        return Button(action: {
            store.windowPosition = isSelected ? nil : position
        }) {
            Image(systemName: symbol)
                .font(.system(size: 14))
                .frame(width: 28, height: 28)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isSelected ? Color.accentColor.opacity(0.3) : Color.secondary.opacity(0.1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 1)
                )
        }
        .buttonStyle(.borderless)
    }
}
