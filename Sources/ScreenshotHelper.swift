// ScreenshotHelper.swift — Captures, saves, and copies window screenshots.
// Uses ScreenCaptureKit (macOS 14+) as the primary capture engine, with
// CGWindowListCreateImage as a legacy fallback for macOS 13. Both paths
// produce Retina-correct images with full pixel resolution and logical sizing.

import AppKit
import ScreenCaptureKit

class ScreenshotHelper {

    /// Captures a screenshot of a specific window by its CGWindowID.
    ///
    /// On macOS 14+, uses SCScreenshotManager which is the modern, secure API
    /// designed for code-signed applications. On macOS 13, falls back to
    /// CGWindowListCreateImage (deprecated in macOS 14).
    ///
    /// The completion handler is always called on the main thread.
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

    /// Captures using SCScreenshotManager, the recommended API for signed apps.
    ///
    /// Workflow:
    /// 1. Query SCShareableContent for all on-screen windows
    /// 2. Find the target window by matching CGWindowID
    /// 3. Create a desktop-independent filter (captures the window without background)
    /// 4. Configure output dimensions at the display's native pixel density
    /// 5. Capture and wrap in an NSImage with logical (point) sizing
    @available(macOS 14.0, *)
    private static func captureWithScreenCaptureKit(_ windowID: CGWindowID) async -> NSImage? {
        guard let content = try? await SCShareableContent.excludingDesktopWindows(
            true, onScreenWindowsOnly: true
        ) else { return nil }
        guard let window = content.windows.first(where: { $0.windowID == windowID }) else { return nil }

        let filter = SCContentFilter(desktopIndependentWindow: window)
        let config = SCStreamConfiguration()

        // Calculate output dimensions at the display's native pixel density.
        // On a 2x Retina display, a 1000pt-wide window produces a 2000px image.
        let scale = displayScaleFactor(containing: window.frame)
        config.width = Int(window.frame.width * scale)
        config.height = Int(window.frame.height * scale)
        config.showsCursor = false

        guard let cgImage = try? await SCScreenshotManager.captureImage(
            contentFilter: filter, configuration: config
        ) else { return nil }

        // Set NSImage size to logical (point) dimensions so the image displays
        // at the correct size. The underlying pixel data remains at full Retina
        // resolution, producing a 144 DPI PNG when saved.
        let logicalSize = NSSize(width: window.frame.width, height: window.frame.height)
        return NSImage(cgImage: cgImage, size: logicalSize)
    }

    // MARK: - CGWindowList fallback (macOS 13)

    /// Captures using the legacy CGWindowListCreateImage API.
    ///
    /// The .bestResolution option captures at the display's native pixel density
    /// (2x on Retina). The .boundsIgnoreFraming option excludes the window shadow.
    /// This API was deprecated in macOS 14 in favor of ScreenCaptureKit.
    private static func captureWithCGWindowList(_ windowID: CGWindowID) -> NSImage? {
        guard let cgImage = CGWindowListCreateImage(
            .null,
            .optionIncludingWindow,
            windowID,
            [.boundsIgnoreFraming, .bestResolution]
        ) else { return nil }

        guard cgImage.width > 0, cgImage.height > 0 else { return nil }

        // Correct Retina scaling: CGWindowListCreateImage with .bestResolution
        // returns an image at native pixel density (e.g. 2000px for a 1000pt window
        // on a 2x display). Dividing by the backing scale factor gives us the
        // logical size, so the NSImage displays at the correct dimensions.
        let backingScale = NSScreen.main?.backingScaleFactor ?? 2.0
        let logicalSize = NSSize(
            width: CGFloat(cgImage.width) / backingScale,
            height: CGFloat(cgImage.height) / backingScale
        )
        return NSImage(cgImage: cgImage, size: logicalSize)
    }

    // MARK: - Display Utilities

    /// Returns the backing scale factor of the display containing the given rect.
    ///
    /// Handles the coordinate system mismatch: SCWindow and CGWindowList use
    /// top-left origin, while NSScreen uses bottom-left origin (Quartz coordinate
    /// system). We convert NSScreen frames to top-left origin before hit-testing.
    /// Falls back to the main screen's scale if no screen contains the rect.
    private static func displayScaleFactor(containing rect: CGRect) -> CGFloat {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        for screen in NSScreen.screens {
            let frame = screen.frame
            // Convert NSScreen's bottom-left origin to top-left origin by
            // flipping Y relative to the primary screen's height.
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

    // MARK: - Export

    /// Saves the image as a timestamped PNG file to the specified directory.
    ///
    /// The conversion pipeline is NSImage → TIFF representation → NSBitmapImageRep
    /// → PNG data. This preserves the full pixel resolution while embedding DPI
    /// metadata (144 DPI for Retina captures), so the PNG displays at the correct
    /// logical size in image viewers.
    ///
    /// Filename format: MMddHHmmss_AppName_WindowTitle.png
    /// All symbols are stripped; only letters, digits, and underscores remain.
    static func exportAsPNG(_ image: NSImage, to location: ScreenshotSaveLocation,
                            windowInfo: WindowInfo? = nil) -> Bool {
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

        let filename = buildFilename(windowInfo: windowInfo)
        let fileURL = directory.appendingPathComponent(filename)

        do {
            try pngData.write(to: fileURL)
            return true
        } catch {
            return false
        }
    }

    /// Builds a compact filename from the current date/time and window identity.
    ///
    /// Format: MMddHHmmss_AppName_WindowTitle.png
    /// e.g. "0227193012_Safari_Apple.png"
    ///
    /// All punctuation and symbols are stripped from app name and window title,
    /// keeping only letters, digits, and spaces (spaces become underscores).
    private static func buildFilename(windowInfo: WindowInfo?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddHHmmss"

        var parts = [formatter.string(from: Date())]

        if let info = windowInfo {
            let appName = sanitizeForFilename(info.ownerName)
            if !appName.isEmpty { parts.append(appName) }

            let windowTitle = sanitizeForFilename(info.windowName)
            if !windowTitle.isEmpty { parts.append(windowTitle) }
        }

        return parts.joined(separator: "_") + ".png"
    }

    /// Strips all characters except letters, digits, and spaces from a string,
    /// then replaces spaces with underscores for use in filenames.
    private static func sanitizeForFilename(_ name: String) -> String {
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: " "))
        return name.unicodeScalars
            .filter { allowed.contains($0) }
            .map { String($0) }
            .joined()
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: " ", with: "_")
    }

    /// Copies the image to the system clipboard via NSPasteboard.
    static func copyToClipboard(_ image: NSImage) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([image])
    }
}
