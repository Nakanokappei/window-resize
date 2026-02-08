import SwiftUI

struct SettingsView: View {
    @ObservedObject private var store = SettingsStore.shared
    @State private var newWidth: String = ""
    @State private var newHeight: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L("settings.preset-sizes"))
                .font(.headline)

            // 内蔵サイズ一覧（スクロール可能） / Built-in size list (scrollable)
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
            }

            // Custom sizes
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

            // Launch at Login
            Toggle(L("settings.launch-at-login"), isOn: $store.launchAtLogin)
                .toggleStyle(.switch)

            Divider()

            // Accessibility status
            HStack {
                let apiEnabled = AccessibilityHelper.isAccessibilityEnabled()
                let actuallyWorking = AccessibilityHelper.isAccessibilityActuallyWorking()

                Circle()
                    .fill(actuallyWorking ? Color.green : (apiEnabled ? Color.orange : Color.red))
                    .frame(width: 10, height: 10)

                if actuallyWorking {
                    Text(L("settings.accessibility.enabled"))
                        .font(.caption)
                } else if apiEnabled {
                    Text(L("settings.accessibility.needs-refresh"))
                        .font(.caption)
                        .foregroundColor(.orange)
                } else {
                    Text(L("settings.accessibility.not-enabled"))
                        .font(.caption)
                }

                Spacer()

                if !actuallyWorking {
                    Button(L("alert.button.open-settings")) {
                        AccessibilityHelper.openAccessibilitySettings()
                    }
                    .font(.caption)
                }
            }
        }
        .padding()
        .frame(minWidth: 350, minHeight: 400)
    }
}
