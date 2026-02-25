import AppKit
import ScreenCaptureKit

class ScreenshotHelper {

    /// ウィンドウのスクリーンショットを撮影
    /// macOS 14+: ScreenCaptureKit (SCScreenshotManager), macOS 13: CGWindowListCreateImage fallback
    static func captureWindow(_ windowID: CGWindowID, completion: @escaping (NSImage?) -> Void) {
        if #available(macOS 14.0, *) {
            Task {
                let image = await captureWithScreenCaptureKit(windowID)
                await MainActor.run { completion(image) }
            }
        } else {
            completion(captureWithCGWindowList(windowID))
        }
    }

    // MARK: - ScreenCaptureKit (macOS 14+)

    @available(macOS 14.0, *)
    private static func captureWithScreenCaptureKit(_ windowID: CGWindowID) async -> NSImage? {
        guard let content = try? await SCShareableContent.excludingDesktopWindows(
            true, onScreenWindowsOnly: true
        ) else { return nil }
        guard let window = content.windows.first(where: { $0.windowID == windowID }) else { return nil }

        let filter = SCContentFilter(desktopIndependentWindow: window)
        let config = SCStreamConfiguration()
        let scale = backingScaleForRect(window.frame)
        config.width = Int(window.frame.width * scale)
        config.height = Int(window.frame.height * scale)
        config.showsCursor = false

        guard let cgImage = try? await SCScreenshotManager.captureImage(
            contentFilter: filter, configuration: config
        ) else { return nil }

        // Retina対応: NSImage の size を論理サイズ (point) に設定
        // Set NSImage size to logical (point) dimensions for correct Retina display
        let logicalSize = NSSize(width: window.frame.width, height: window.frame.height)
        return NSImage(cgImage: cgImage, size: logicalSize)
    }

    // MARK: - CGWindowList fallback (macOS 13)

    private static func captureWithCGWindowList(_ windowID: CGWindowID) -> NSImage? {
        guard let cgImage = CGWindowListCreateImage(
            .null,
            .optionIncludingWindow,
            windowID,
            [.boundsIgnoreFraming, .bestResolution]
        ) else { return nil }

        guard cgImage.width > 0, cgImage.height > 0 else { return nil }

        // Retina対応: .bestResolution はネイティブピクセル解像度 (Retinaで2x) でキャプチャする
        // NSImage の size を論理サイズに設定して正しい表示サイズにする
        let backingScale = NSScreen.main?.backingScaleFactor ?? 2.0
        let logicalSize = NSSize(
            width: CGFloat(cgImage.width) / backingScale,
            height: CGFloat(cgImage.height) / backingScale
        )
        return NSImage(cgImage: cgImage, size: logicalSize)
    }

    // MARK: - Utility

    /// 指定された矩形（top-left原点座標系）を含むスクリーンの backingScaleFactor を返す
    private static func backingScaleForRect(_ rect: CGRect) -> CGFloat {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        for screen in NSScreen.screens {
            let frame = screen.frame
            // NSScreen は bottom-left 原点、CGWindowList/SCWindow は top-left 原点なので変換
            let topLeftFrame = CGRect(
                x: frame.origin.x,
                y: NSScreen.screens[0].frame.height - frame.origin.y - frame.height,
                width: frame.width,
                height: frame.height
            )
            if topLeftFrame.contains(center) {
                return screen.backingScaleFactor
            }
        }
        return NSScreen.main?.backingScaleFactor ?? 2.0
    }

    /// 画像をファイルとして保存する / Save image to file
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

    /// 画像をクリップボードにコピー / Copy image to clipboard
    static func copyToClipboard(_ image: NSImage) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([image])
    }
}
