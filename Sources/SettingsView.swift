// SettingsView.swift — SwiftUI settings panel displayed in a standalone
// NSWindow (via SettingsWindowController). Provides UI for viewing built-in
// presets, managing custom presets, configuring launch-at-login, screenshot
// options, and Accessibility permission status.

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var store = SettingsStore.shared
    @State private var newWidth: String = ""
    @State private var newHeight: String = ""

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
                .frame(maxHeight: 200)
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
                        Text(L("settings.screenshot.save-to"))
                            .font(.caption)
                        Picker("", selection: $store.screenshotSaveLocation) {
                            Text(L("settings.screenshot.desktop")).tag(ScreenshotSaveLocation.desktop)
                            Text(L("settings.screenshot.pictures")).tag(ScreenshotSaveLocation.pictures)
                        }
                        .labelsHidden()
                        .pickerStyle(.segmented)
                        .frame(maxWidth: 200)
                    }
                    .padding(.leading, 20)
                }

                Toggle(L("settings.screenshot.copy-to-clipboard"), isOn: $store.screenshotCopyToClipboard)
                    .toggleStyle(.switch)
                    .font(.caption)
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
        .frame(minWidth: 350, minHeight: 400)
    }
}
