// PresetSize.swift — Value type representing a window dimension preset.
// Used for both the 12 built-in sizes (Mac Retina + standard resolutions)
// and user-defined custom sizes. Persisted via Codable/JSONEncoder.

import Foundation

struct PresetSize: Codable, Equatable, Identifiable {
    let id: UUID
    var width: Int
    var height: Int
    var label: String?

    var displayName: String {
        "\(width) x \(height)"
    }

    /// Formatted string with a tab-separated label for menu display.
    /// The tab character is consumed by NSTextTab in the menu's
    /// NSAttributedString to produce right-aligned labels (e.g. "1024 x 768\tXGA").
    var displayNameWithLabel: String {
        if let label = label, !label.isEmpty {
            return "\(width) x \(height)\t\(label)"
        }
        return "\(width) x \(height)"
    }

    init(width: Int, height: Int, label: String? = nil) {
        self.id = UUID()
        self.width = width
        self.height = height
        self.label = label
    }
}
