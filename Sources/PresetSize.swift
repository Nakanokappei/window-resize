import Foundation

struct PresetSize: Codable, Equatable, Identifiable {
    let id: UUID
    var width: Int
    var height: Int
    var label: String?

    var displayName: String {
        "\(width) x \(height)"
    }

    /// サイズ名ラベル付きの表示名（例: "1024 x 768  XGA"）
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
