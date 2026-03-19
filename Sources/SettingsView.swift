// SettingsView.swift — SwiftUI settings panel with three tabs:
//   General    — Quick Presets, Launch at Login, Language, Accessibility
//   Appearance — Overlay border color/style, ratio label, Shift-lock
//   Shortcuts  — Customizable keyboard shortcut bindings with conflict detection

import SwiftUI

// MARK: - Root View (TabView)

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralTab()
                .tabItem {
                    Label(L("settings.tab.general"), systemImage: "gearshape")
                }
            AppearanceTab()
                .tabItem {
                    Label(L("settings.tab.appearance"), systemImage: "paintbrush")
                }
            ShortcutsTab()
                .tabItem {
                    Label(L("settings.tab.shortcuts"), systemImage: "keyboard")
                }
        }
        .frame(width: 480)
    }
}

// MARK: - General Tab

private struct GeneralTab: View {
    @ObservedObject private var store = SettingsStore.shared
    @State private var showRestartAlert = false

    // Quick preset editing state.
    @State private var newQPLabel: String = ""
    @State private var newQPWidth: String = ""
    @State private var newQPHeight: String = ""

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
            // Quick Presets: keyboard-activated presets.
            // Usage-based labels are shown prominently; sizes are secondary info.
            // Also used as snap candidates during drag resize.
            Text(L("settings.quick-presets"))
                .font(.headline)

            GroupBox {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(store.quickPresets.enumerated()), id: \.element.id) { index, preset in
                        HStack(spacing: 6) {
                            // Shortcut badge (dynamic from bindings).
                            Text(store.shortcutDisplayString(for: "preset\(index + 1)"))
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .foregroundColor(.secondary)
                                .frame(width: 38)

                            // Editable usage label (primary info).
                            TextField(L("settings.quick-presets.usage-label"), text: Binding(
                                get: { preset.label ?? "" },
                                set: { newLabel in
                                    var updated = preset
                                    updated.label = newLabel.isEmpty ? nil : newLabel
                                    store.updateQuickPreset(at: index, preset: updated)
                                }
                            ))
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 100)

                            // Size display (secondary info).
                            Text("\(preset.width) × \(preset.height)")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Spacer()

                            // Remove button.
                            Button(action: { store.removeQuickPreset(at: index) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.borderless)
                        }
                        .padding(.vertical, 2)
                    }

                    // Add new quick preset form (when fewer than 9 exist).
                    if store.quickPresets.count < 9 {
                        Divider()
                        HStack(spacing: 4) {
                            TextField(L("settings.quick-presets.usage-label"), text: $newQPLabel)
                                .frame(width: 90)
                                .textFieldStyle(.roundedBorder)
                            TextField(L("settings.width"), text: $newQPWidth)
                                .frame(width: 50)
                                .textFieldStyle(.roundedBorder)
                            Text("×")
                            TextField(L("settings.height"), text: $newQPHeight)
                                .frame(width: 50)
                                .textFieldStyle(.roundedBorder)
                            Button(L("settings.add")) {
                                guard let w = Int(newQPWidth), let h = Int(newQPHeight),
                                      w > 0, h > 0 else { return }
                                let label = newQPLabel.trimmingCharacters(in: .whitespaces)
                                store.addQuickPreset(PresetSize(
                                    width: w, height: h,
                                    label: label.isEmpty ? nil : label))
                                newQPLabel = ""
                                newQPWidth = ""
                                newQPHeight = ""
                            }
                            .disabled(Int(newQPWidth) == nil || Int(newQPHeight) == nil)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.vertical, 4)
            }

            Divider()

            // Launch at Login toggle — uses SMAppService under the hood.
            Toggle(L("settings.launch-at-login"), isOn: $store.launchAtLogin)
                .toggleStyle(.switch)

            Divider()

            // Language picker — allows overriding the app language.
            // Requires restart to take effect.
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
        .alert(L("settings.language.restart-title"), isPresented: $showRestartAlert) {
            Button(L("settings.language.restart-button")) {
                store.relaunchApp()
            }
            Button(L("settings.language.restart-later"), role: .cancel) { }
        } message: {
            Text(L("settings.language.restart-body"))
        }
    }
}

// MARK: - Appearance Tab

private struct AppearanceTab: View {
    @ObservedObject private var store = SettingsStore.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Overlay appearance settings.
            Text(L("settings.overlay"))
                .font(.headline)

            GroupBox {
                VStack(alignment: .leading, spacing: 8) {
                    // Resize overlay: color + line style (with "none" option).
                    HStack {
                        Text(L("settings.overlay.resize"))
                            .frame(width: 120, alignment: .leading)
                        colorPicker(selection: $store.resizeBorderColor)
                        resizeLineStylePicker()
                    }

                    // Snap overlay: color + line style (no "none" option).
                    HStack {
                        Text(L("settings.overlay.snap"))
                            .frame(width: 120, alignment: .leading)
                        colorPicker(selection: $store.snapBorderColor)
                        lineStylePicker(selection: $store.snapBorderDashed,
                                        colorName: store.snapBorderColor)
                    }
                }
                .padding(.vertical, 4)
            }

            // Show ratio label toggle.
            Toggle(L("settings.overlay.show-ratio"), isOn: $store.showRatioLabel)
                .toggleStyle(.switch)

            // Shift to lock aspect ratio toggle.
            Toggle(L("settings.overlay.shift-lock-ratio"), isOn: $store.shiftToLockRatio)
                .toggleStyle(.switch)
        }
        .padding()
    }

    // MARK: - Resize Line Style Picker (with "None" option)

    /// Line style picker for the resize overlay that includes a "None"
    /// option. Selecting "None" hides the overlay border during non-snap
    /// resize. Selecting solid or dashed re-enables it.
    private func resizeLineStylePicker() -> some View {
        let nsColor = SettingsStore.nsColor(forName: store.resizeBorderColor)
        let swiftColor = Color(nsColor: nsColor)

        return HStack(spacing: 8) {
            // "None" button — disables resize overlay border.
            lineStyleButton(dashed: false, color: .secondary.opacity(0.3),
                            isSelected: !store.showResizeOverlay,
                            label: L("settings.overlay.none")) {
                store.showResizeOverlay = false
            }

            // Solid line button — enables resize overlay with solid border.
            lineStyleButton(dashed: false, color: swiftColor,
                            isSelected: store.showResizeOverlay && !store.resizeBorderDashed,
                            label: L("settings.overlay.solid")) {
                store.showResizeOverlay = true
                store.resizeBorderDashed = false
            }

            // Dashed line button — enables resize overlay with dashed border.
            lineStyleButton(dashed: true, color: swiftColor,
                            isSelected: store.showResizeOverlay && store.resizeBorderDashed,
                            label: L("settings.overlay.dashed")) {
                store.showResizeOverlay = true
                store.resizeBorderDashed = true
            }
        }
    }

    // MARK: - Color Picker with Inline Swatches

    /// A horizontal row of color swatch circles. Tapping selects the color.
    /// The selected swatch gets a highlight ring.
    private func colorPicker(selection: Binding<String>) -> some View {
        HStack(spacing: 6) {
            ForEach(SettingsStore.borderColorOptions, id: \.name) { opt in
                Circle()
                    .fill(Color(nsColor: opt.color))
                    .frame(width: 16, height: 16)
                    .overlay(
                        Circle()
                            .strokeBorder(Color.primary, lineWidth: selection.wrappedValue == opt.name ? 2 : 0)
                            .frame(width: 20, height: 20)
                    )
                    .help(L(opt.locKey))
                    .onTapGesture { selection.wrappedValue = opt.name }
            }
        }
    }

    // MARK: - Line Style Picker with Inline Preview

    /// A horizontal row of line style previews (solid and dashed) drawn in the
    /// selected overlay color. Tapping toggles the style.
    private func lineStylePicker(selection: Binding<Bool>, colorName: String) -> some View {
        let nsColor = SettingsStore.nsColor(forName: colorName)
        let swiftColor = Color(nsColor: nsColor)

        return HStack(spacing: 8) {
            // Solid line button.
            lineStyleButton(dashed: false, color: swiftColor,
                            isSelected: !selection.wrappedValue,
                            label: L("settings.overlay.solid")) {
                selection.wrappedValue = false
            }

            // Dashed line button.
            lineStyleButton(dashed: true, color: swiftColor,
                            isSelected: selection.wrappedValue,
                            label: L("settings.overlay.dashed")) {
                selection.wrappedValue = true
            }
        }
    }

    /// A single line-style option button with a visual preview and selection ring.
    private func lineStyleButton(dashed: Bool, color: Color,
                                 isSelected: Bool, label: String,
                                 action: @escaping () -> Void) -> some View {
        VStack(spacing: 2) {
            LinePreview(dashed: dashed, color: color)
                .frame(width: 30, height: 12)
            Text(label)
                .font(.system(size: 9))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(Color.primary.opacity(isSelected ? 0.5 : 0),
                              lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
    }
}

// MARK: - Shortcuts Tab

private struct ShortcutsTab: View {
    @ObservedObject private var store = SettingsStore.shared

    /// Tracks which action ID is currently being recorded, if any.
    @State private var recordingActionID: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Resize group (±10px).
            Text(L("settings.shortcuts.resize"))
                .font(.headline)
            GroupBox {
                VStack(spacing: 4) {
                    ForEach(SettingsStore.resizeActionIDs, id: \.self) { actionID in
                        shortcutRow(actionID: actionID)
                    }
                }
                .padding(.vertical, 4)
            }

            // Precision group (±1px).
            Text(L("settings.shortcuts.precision"))
                .font(.headline)
            GroupBox {
                VStack(spacing: 4) {
                    ForEach(SettingsStore.precisionActionIDs, id: \.self) { actionID in
                        shortcutRow(actionID: actionID)
                    }
                }
                .padding(.vertical, 4)
            }

            // Undo / Redo group.
            Text(L("settings.shortcuts.undo-redo"))
                .font(.headline)
            GroupBox {
                VStack(spacing: 4) {
                    ForEach(SettingsStore.undoRedoActionIDs, id: \.self) { actionID in
                        shortcutRow(actionID: actionID)
                    }
                }
                .padding(.vertical, 4)
            }

            // Reset to defaults button.
            HStack {
                Spacer()
                Button(L("settings.shortcuts.reset")) {
                    store.resetShortcutsToDefaults()
                }
                .font(.caption)
            }
        }
        .padding()
    }

    /// A single shortcut row: [recorder] action-name [conflict-icon].
    private func shortcutRow(actionID: String) -> some View {
        let binding = Binding<SettingsStore.ShortcutBinding>(
            get: {
                store.shortcutBindings[actionID]
                    ?? SettingsStore.defaultShortcutBindings[actionID]
                    ?? SettingsStore.ShortcutBinding(modifiers: 0, keyCode: 0)
            },
            set: { newValue in
                store.shortcutBindings[actionID] = newValue
            }
        )

        let isRecording = Binding<Bool>(
            get: { recordingActionID == actionID },
            set: { newValue in
                recordingActionID = newValue ? actionID : nil
            }
        )

        // Check for conflicts.
        let currentBinding = binding.wrappedValue
        let systemConflict = store.conflictsWithSystem(currentBinding)
        let appConflict = store.conflictsWithOtherAction(currentBinding, excluding: actionID)
        let hasConflict = systemConflict || appConflict != nil

        return HStack(spacing: 8) {
            // Shortcut recorder button.
            ShortcutRecorderView(binding: binding, isRecording: isRecording)
                .frame(width: 90, height: 24)

            // Action name.
            Text(SettingsStore.localizedActionName(actionID))
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)

            // Conflict warning icon.
            if hasConflict {
                let tooltip: String = {
                    if systemConflict {
                        return L("settings.shortcuts.conflict-system")
                    } else if let otherName = appConflict {
                        return L("settings.shortcuts.conflict-app") + ": " + otherName
                    }
                    return ""
                }()
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 12))
                    .help(tooltip)
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - LinePreview

/// A small view that draws a horizontal line sample (dashed or solid)
/// in the specified color. Used in the inline line style picker buttons.
private struct LinePreview: View {
    let dashed: Bool
    let color: Color

    var body: some View {
        GeometryReader { geo in
            Path { path in
                let midY = geo.size.height / 2
                path.move(to: CGPoint(x: 0, y: midY))
                path.addLine(to: CGPoint(x: geo.size.width, y: midY))
            }
            .stroke(color, style: StrokeStyle(
                lineWidth: 3,
                dash: dashed ? [5, 3] : []
            ))
        }
    }
}
