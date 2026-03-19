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
            PresetsTab()
                .tabItem {
                    Label(L("settings.tab.presets"), systemImage: "rectangle.3.group")
                }
        }
        .frame(width: 540)
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

    /// Tracks which preset action ID is currently being recorded.
    @State private var recordingPresetActionID: String? = nil

    /// Controls the in-app conflict alert for preset shortcut editing.
    @State private var showPresetConflictAlert = false
    @State private var presetConflictMessage = ""
    @State private var pendingPresetActionID: String?
    @State private var pendingPresetBinding: SettingsStore.ShortcutBinding?
    @State private var conflictingPresetActionID: String?

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
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                // Quick Presets heading with Escape hint when recording.
                HStack {
                    Text(L("settings.quick-presets"))
                        .font(.headline)
                    Spacer()
                    if recordingPresetActionID != nil {
                        Text(L("settings.shortcuts.escape-to-cancel"))
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }

                GroupBox {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(Array(store.quickPresets.enumerated()), id: \.element.id) { index, preset in
                            HStack(spacing: 6) {
                                // Editable shortcut recorder (same style as Shortcuts tab).
                                presetShortcutRecorder(index: index)
                                    .frame(width: 90, height: 24)

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
                        // Horizontal positions aligned with existing preset rows:
                        // recorder(90) + spacing(6) = 96pt offset for label field.
                        if store.quickPresets.count < 9 {
                            Divider()
                            HStack(spacing: 6) {
                                // Spacer matching the shortcut recorder column width.
                                Color.clear.frame(width: 90, height: 24)

                                TextField(L("settings.quick-presets.usage-label"), text: $newQPLabel)
                                    .frame(width: 100)
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

            // Transparent tap catcher: cancels shortcut recording when the
            // user clicks anywhere outside the active recorder.
            if recordingPresetActionID != nil {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { recordingPresetActionID = nil }
            }
        }
        .alert(L("settings.language.restart-title"), isPresented: $showRestartAlert) {
            Button(L("settings.language.restart-button")) {
                store.relaunchApp()
            }
            Button(L("settings.language.restart-later"), role: .cancel) { }
        } message: {
            Text(L("settings.language.restart-body"))
        }
        .alert(L("settings.shortcuts.conflict-title"), isPresented: $showPresetConflictAlert) {
            Button(L("settings.shortcuts.conflict-replace")) {
                if let actionID = pendingPresetActionID,
                   let newBinding = pendingPresetBinding,
                   let otherID = conflictingPresetActionID {
                    store.shortcutBindings[otherID] = SettingsStore.ShortcutBinding(
                        modifiers: 0, keyCode: 0)
                    store.shortcutBindings[actionID] = newBinding
                }
            }
            Button(L("settings.shortcuts.conflict-cancel"), role: .cancel) { }
        } message: {
            Text(presetConflictMessage)
        }
    }

    // MARK: - Preset Shortcut Recorder

    /// Builds a ShortcutRecorderView for the given quick preset index.
    /// Uses the same 90×24pt size and recording behavior as the Shortcuts tab.
    private func presetShortcutRecorder(index: Int) -> some View {
        let actionID = "preset\(index + 1)"

        let binding = Binding<SettingsStore.ShortcutBinding>(
            get: {
                store.shortcutBindings[actionID]
                    ?? SettingsStore.defaultShortcutBindings[actionID]
                    ?? SettingsStore.ShortcutBinding(modifiers: 0, keyCode: 0)
            },
            set: { newValue in
                // Check for in-app conflict before applying.
                if let otherID = store.findConflictingActionID(for: newValue, excluding: actionID) {
                    let newName = SettingsStore.localizedActionName(actionID)
                    let otherName = SettingsStore.localizedActionName(otherID)
                    let shortcutStr = SettingsStore.displayString(for: newValue)
                    presetConflictMessage = String(
                        format: L("settings.shortcuts.conflict-message"),
                        shortcutStr, otherName, newName)
                    pendingPresetActionID = actionID
                    pendingPresetBinding = newValue
                    conflictingPresetActionID = otherID
                    showPresetConflictAlert = true
                } else {
                    store.shortcutBindings[actionID] = newValue
                }
            }
        )

        let isRecording = Binding<Bool>(
            get: { recordingPresetActionID == actionID },
            set: { newValue in
                recordingPresetActionID = newValue ? actionID : nil
            }
        )

        return ShortcutRecorderView(binding: binding, isRecording: isRecording)
    }

}

// MARK: - Appearance Tab

/// Controls overlay visual preferences: border color, line style (solid /
/// dashed / animated), visibility toggle for the resize overlay, aspect
/// ratio label, and Shift-to-lock-ratio behavior. Both resize and snap
/// overlays are configured here side by side.
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
                            .frame(width: 80, alignment: .leading)
                        colorPicker(selection: $store.resizeBorderColor)
                        Spacer()
                        overlayLineStylePicker(
                            colorName: store.resizeBorderColor,
                            isDashed: $store.resizeBorderDashed,
                            isAnimated: $store.resizeBorderAnimated,
                            isVisible: $store.showResizeOverlay)
                    }

                    // Snap overlay: color + line style (no "none" option).
                    HStack {
                        Text(L("settings.overlay.snap"))
                            .frame(width: 80, alignment: .leading)
                        colorPicker(selection: $store.snapBorderColor)
                        Spacer()
                        overlayLineStylePicker(
                            colorName: store.snapBorderColor,
                            isDashed: $store.snapBorderDashed,
                            isAnimated: $store.snapBorderAnimated)
                    }
                }
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Show ratio label toggle.
            Toggle(L("settings.overlay.show-ratio"), isOn: $store.showRatioLabel)
                .toggleStyle(.switch)

            // Shift to lock aspect ratio toggle.
            Toggle(L("settings.overlay.shift-lock-ratio"), isOn: $store.shiftToLockRatio)
                .toggleStyle(.switch)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }

    // MARK: - Line Style Picker (shared for resize and snap overlays)

    /// Builds a line style picker for an overlay type. Both the resize and snap
    /// overlays share the same UI structure (Solid / Dashed / Animated buttons);
    /// the only differences are:
    /// - Resize includes a "None" option that hides the overlay entirely.
    /// - Each type writes to its own set of SettingsStore properties.
    ///
    /// Factored into a single function to eliminate duplication and ensure both
    /// pickers stay visually and behaviorally consistent.
    ///
    /// - Parameters:
    ///   - colorName: The border color name from SettingsStore.
    ///   - isDashed: Binding to the dashed property.
    ///   - isAnimated: Binding to the animated property.
    ///   - isVisible: Optional binding for the visibility toggle (resize only).
    ///     When nil, the picker omits the "None" option (snap behavior).
    private func overlayLineStylePicker(
        colorName: String,
        isDashed: Binding<Bool>,
        isAnimated: Binding<Bool>,
        isVisible: Binding<Bool>? = nil
    ) -> some View {
        let nsColor = SettingsStore.nsColor(forName: colorName)
        let swiftColor = Color(nsColor: nsColor)

        // Determine the effective visibility (always true for snap).
        let visible = isVisible?.wrappedValue ?? true

        // Derive the mutually exclusive selection state from the three booleans.
        let noneSelected = !visible
        let solidSelected = visible && !isDashed.wrappedValue && !isAnimated.wrappedValue
        let dashedSelected = visible && isDashed.wrappedValue && !isAnimated.wrappedValue
        let animatedSelected = visible && isAnimated.wrappedValue

        return HStack(spacing: 8) {
            // "None" button — only present for overlays that can be hidden.
            if let isVisible = isVisible {
                lineStyleButton(dashed: false, color: .secondary.opacity(0.3),
                                isSelected: noneSelected,
                                label: L("settings.overlay.none")) {
                    isVisible.wrappedValue = false
                    isAnimated.wrappedValue = false
                }
            }

            // Solid line button.
            lineStyleButton(dashed: false, color: swiftColor,
                            isSelected: solidSelected,
                            label: L("settings.overlay.solid")) {
                isVisible?.wrappedValue = true
                isDashed.wrappedValue = false
                isAnimated.wrappedValue = false
            }

            // Static dashed line button.
            lineStyleButton(dashed: true, color: swiftColor,
                            isSelected: dashedSelected,
                            label: L("settings.overlay.dashed")) {
                isVisible?.wrappedValue = true
                isDashed.wrappedValue = true
                isAnimated.wrappedValue = false
            }

            // Animated dashed line button (marching ants).
            lineStyleButton(dashed: true, color: swiftColor,
                            isSelected: animatedSelected,
                            label: L("settings.overlay.animated"),
                            animated: true) {
                isVisible?.wrappedValue = true
                isDashed.wrappedValue = true
                isAnimated.wrappedValue = true
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

    /// A single line-style option button with a visual preview and selection ring.
    /// When `animated` is true, the line preview shows a marching ants animation.
    private func lineStyleButton(dashed: Bool, color: Color,
                                 isSelected: Bool, label: String,
                                 animated: Bool = false,
                                 action: @escaping () -> Void) -> some View {
        VStack(spacing: 2) {
            if animated {
                AnimatedLinePreview(color: color)
                    .frame(width: 30, height: 12)
            } else {
                LinePreview(dashed: dashed, color: color)
                    .frame(width: 30, height: 12)
            }
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

    /// Controls the in-app conflict alert presentation.
    @State private var showConflictAlert = false

    /// Description of the detected conflict, shown in the alert message.
    @State private var conflictMessage = ""

    /// The action ID whose binding was just changed (source of the conflict).
    @State private var pendingActionID: String?

    /// The new binding that caused the conflict.
    @State private var pendingBinding: SettingsStore.ShortcutBinding?

    /// The other action ID that already uses the same binding.
    @State private var conflictingActionID: String?

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {

                // Resize group heading with Escape hint when recording.
                HStack {
                    Text(L("settings.shortcuts.resize"))
                        .font(.headline)
                    Spacer()
                    if recordingActionID != nil {
                        Text(L("settings.shortcuts.escape-to-cancel"))
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                GroupBox {
                    twoColumnGrid(actionIDs: SettingsStore.resizeActionIDs)
                        .padding(.vertical, 4)
                }

                // Precision group (±1px) — 2-column layout.
                Text(L("settings.shortcuts.precision"))
                    .font(.headline)
                GroupBox {
                    twoColumnGrid(actionIDs: SettingsStore.precisionActionIDs)
                        .padding(.vertical, 4)
                }

                // Undo / Redo group — 2-column layout.
                Text(L("settings.shortcuts.undo-redo"))
                    .font(.headline)
                GroupBox {
                    twoColumnGrid(actionIDs: SettingsStore.undoRedoActionIDs)
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

            // Transparent tap catcher: cancels shortcut recording when the
            // user clicks anywhere outside the active recorder.
            if recordingActionID != nil {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { recordingActionID = nil }
            }
        }
        .alert(L("settings.shortcuts.conflict-title"), isPresented: $showConflictAlert) {
            // "Replace" — assign the new binding to the pending action and
            // clear the conflicting action's binding.
            Button(L("settings.shortcuts.conflict-replace")) {
                if let actionID = pendingActionID,
                   let newBinding = pendingBinding,
                   let otherID = conflictingActionID {
                    store.shortcutBindings[otherID] = SettingsStore.ShortcutBinding(
                        modifiers: 0, keyCode: 0)
                    store.shortcutBindings[actionID] = newBinding
                }
            }
            // "Cancel" — revert to the previous binding (already stored).
            Button(L("settings.shortcuts.conflict-cancel"), role: .cancel) {
                // No action needed; the binding was not changed.
            }
        } message: {
            Text(conflictMessage)
        }
    }

    /// Lays out shortcut rows in a 2-column grid. If the action count is odd,
    /// the last row has a single item spanning the left column.
    private func twoColumnGrid(actionIDs: [String]) -> some View {
        let rowCount = (actionIDs.count + 1) / 2
        return VStack(spacing: 4) {
            ForEach(0..<rowCount, id: \.self) { row in
                HStack(spacing: 16) {
                    shortcutRow(actionID: actionIDs[row * 2])
                    if row * 2 + 1 < actionIDs.count {
                        shortcutRow(actionID: actionIDs[row * 2 + 1])
                    } else {
                        Spacer()
                    }
                }
            }
        }
    }

    /// A single shortcut row: [recorder] action-name [conflict-icon].
    ///
    /// When the user records a new binding that conflicts with another
    /// action in the app, an alert is shown offering to replace the
    /// conflicting binding or cancel. The binding is only committed
    /// after the user confirms.
    private func shortcutRow(actionID: String) -> some View {
        let binding = Binding<SettingsStore.ShortcutBinding>(
            get: {
                store.shortcutBindings[actionID]
                    ?? SettingsStore.defaultShortcutBindings[actionID]
                    ?? SettingsStore.ShortcutBinding(modifiers: 0, keyCode: 0)
            },
            set: { newValue in
                // Check for in-app conflict before applying.
                if let otherID = store.findConflictingActionID(for: newValue, excluding: actionID) {
                    // Stash the pending change and show the conflict alert.
                    let newName = SettingsStore.localizedActionName(actionID)
                    let otherName = SettingsStore.localizedActionName(otherID)
                    let shortcutStr = SettingsStore.displayString(for: newValue)
                    conflictMessage = String(
                        format: L("settings.shortcuts.conflict-message"),
                        shortcutStr, otherName, newName)
                    pendingActionID = actionID
                    pendingBinding = newValue
                    conflictingActionID = otherID
                    showConflictAlert = true
                } else {
                    // No conflict — apply immediately.
                    store.shortcutBindings[actionID] = newValue
                }
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

// MARK: - Presets Tab

/// Displays the full list of built-in preset sizes with enable/disable toggles.
/// Disabled presets are excluded from drag-snap detection but remain visible
/// here so the user can re-enable them. Mac-specific Retina resolutions are
/// disabled by default since they match specific display sizes and are rarely
/// useful as general-purpose snap targets.
private struct PresetsTab: View {
    @ObservedObject private var store = SettingsStore.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section heading with enabled count.
            HStack {
                Text(L("settings.presets.built-in"))
                    .font(.headline)
                Spacer()
                let enabledCount = SettingsStore.builtInSizes.count
                    - store.disabledBuiltInIndices.count
                Text(String(format: L("settings.presets.enabled-count"),
                            enabledCount, SettingsStore.builtInSizes.count))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            GroupBox {
                // Scrollable list with vertical scrollbar, showing ~12 rows.
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 0) {
                        ForEach(Array(SettingsStore.builtInSizes.enumerated()),
                                id: \.offset) { index, preset in
                            HStack(spacing: 10) {
                                // Enable/disable toggle for this preset.
                                Toggle("", isOn: Binding(
                                    get: { store.isBuiltInEnabled(index: index) },
                                    set: { _ in store.toggleBuiltIn(index: index) }
                                ))
                                .toggleStyle(.switch)
                                .controlSize(.small)
                                .labelsHidden()

                                // Preset label (e.g. "XGA", "Full HD").
                                Text(preset.label ?? "")
                                    .frame(width: 150, alignment: .leading)

                                // Size dimensions.
                                Text("\(preset.width) × \(preset.height)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)

                                Spacer()
                            }
                            .padding(.vertical, 3)
                            .opacity(store.isBuiltInEnabled(index: index) ? 1.0 : 0.5)

                            // Divider between rows (not after the last row).
                            if index < SettingsStore.builtInSizes.count - 1 {
                                Divider()
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .frame(maxHeight: 12 * 28)  // ~12 rows visible at a time
            }
        }
        .padding()
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

/// Animated dashed line preview (marching ants effect) for the line style
/// picker button. Uses a repeating animation on the dash phase offset.
private struct AnimatedLinePreview: View {
    let color: Color
    @State private var dashPhase: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            Path { path in
                let midY = geo.size.height / 2
                path.move(to: CGPoint(x: 0, y: midY))
                path.addLine(to: CGPoint(x: geo.size.width, y: midY))
            }
            .stroke(color, style: StrokeStyle(
                lineWidth: 3,
                dash: [5, 3],
                dashPhase: dashPhase
            ))
        }
        .onAppear {
            withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
                dashPhase = 8
            }
        }
    }
}
