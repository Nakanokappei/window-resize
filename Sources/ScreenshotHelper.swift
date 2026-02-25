import AppKit

class ScreenshotHelper {

    /// CGWindowID を指定してウィンドウのスクリーンショットを撮影
    /// Capture a screenshot of a specific window by CGWindowID
    static func captureWindow(_ windowID: CGWindowID) -> NSImage? {
        guard let cgImage = CGWindowListCreateImage(
            .null,
            .optionIncludingWindow,
            windowID,
            [.boundsIgnoreFraming, .bestResolution]
        ) else { return nil }

        // 画像が空（全透明）の場合はスクリーンレコーディング権限がない可能性
        // If the image is empty (all transparent), Screen Recording permission may be missing
        let size = NSSize(width: cgImage.width, height: cgImage.height)
        guard size.width > 0, size.height > 0 else { return nil }

        return NSImage(cgImage: cgImage, size: size)
    }

    /// 画像をファイルとして保存する
    /// Save image to file
    static func saveToFile(_ image: NSImage, location: ScreenshotSaveLocation) -> Bool {
        guard let tiffData = image.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData),
              let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
            return false
        }

        let directory: URL
        switch location {
        case .desktop:
            directory = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        case .pictures:
            directory = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH.mm.ss"
        let timestamp = formatter.string(from: Date())
        let filename = "Window Resize \(timestamp).png"
        let fileURL = directory.appendingPathComponent(filename)

        do {
            try pngData.write(to: fileURL)
            return true
        } catch {
            return false
        }
    }

    /// 画像をクリップボードにコピー
    /// Copy image to clipboard
    static func copyToClipboard(_ image: NSImage) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([image])
    }
}
