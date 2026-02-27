# Window Resize - macOS Menu Bar App

## Overview
A menu bar app that resizes running application windows to preset sizes on macOS.

## Tech Stack
- **Language:** Swift (SwiftUI + AppKit)
- **Build:** `swiftc` + shell script (no Xcode project)
- **Signing:** Developer ID Application (Team: G466Q9TVYB) + Apple Notarization
- **Minimum OS:** macOS 13.0 (Ventura)
- **Architecture:** Apple Silicon (arm64) / Intel (x86_64) auto-detected

## Build & Run
```bash
bash build.sh
open "build/Window Resize.app"
```
- Builds in /tmp staging area (avoids iCloud Drive xattr issues with codesign)
- Developer ID signing + Hardened Runtime (`--options runtime`)
- Apple Notarization + Staple automated in build.sh
- Keychain profile `notarytool-profile` stores notarization credentials
- Language test: `open "build/Window Resize.app" --args -AppleLanguages "(ja)"`

## Project Structure
```
Window Resize/
├── CLAUDE.md
├── Info.plist               # App metadata (LSUIElement, BundleID, CFBundleIconName)
├── build.sh                 # Build script (swiftc → /tmp staging → sign → notarize → .app bundle)
├── README.md
├── LICENSE                  # MIT License
├── appicon.af               # App icon source (Pixelmator Pro, not bundled)
├── Window Size App Icon.af  # App icon source (Pixelmator Pro, not bundled)
├── Window Size App Icon.icon/ # Icon Composer package (macOS 26+ Liquid Glass, bundled)
├── Window Resize MenuBar Icon.af # Menu bar icon source (Pixelmator Pro, not bundled)
├── docs/                    # User manuals (16 languages, markdown)
├── Sources/
│   ├── main.swift           # Entry point (.accessory policy, duplicate instance guard)
│   ├── AppDelegate.swift    # NSStatusItem, menu construction, resize orchestration
│   ├── WindowManager.swift  # CGWindowList enumeration + AXUIElement resize
│   ├── PresetSize.swift     # Dimension model (Codable, Identifiable, labeled)
│   ├── SettingsStore.swift  # UserDefaults persistence, SMAppService login item, screenshot config
│   ├── SettingsView.swift   # SwiftUI settings panel (top-aligned, fixed width, flexible height)
│   ├── SettingsWindowController.swift  # NSHostingController wrapper (400pt wide, 400-800pt tall)
│   ├── ScreenshotHelper.swift          # SCScreenshotManager (macOS 14+) / CGWindowList fallback + Retina
│   ├── AccessibilityHelper.swift       # Permission check, stale detection, re-auth guidance
│   └── Localization.swift   # L() shorthand for NSLocalizedString
└── Resources/
    ├── AppIcon.icns          # App icon (generated from Icon Composer export via sips + iconutil)
    ├── Assets.xcassets/      # Asset Catalog (AppIcon with light/dark/tinted variants)
    ├── MenuBarIcon.png       # Menu bar icon (16×16)
    ├── MenuBarIcon@2x.png    # Menu bar icon Retina (32×32)
    ├── en.lproj/             # English (base)
    ├── ja.lproj/             # Japanese
    ├── zh-Hans.lproj/        # Simplified Chinese
    ├── zh-Hant.lproj/        # Traditional Chinese
    ├── es.lproj/             # Spanish
    ├── fr.lproj/             # French
    ├── de.lproj/             # German
    ├── it.lproj/             # Italian
    ├── pt.lproj/             # Portuguese
    ├── ru.lproj/             # Russian
    ├── ar.lproj/             # Arabic
    ├── hi.lproj/             # Hindi
    ├── id.lproj/             # Indonesian
    ├── ko.lproj/             # Korean
    ├── vi.lproj/             # Vietnamese
    └── th.lproj/             # Thai
```

## Key Types & Classes

### AppDelegate.swift
- **ResizeAction** (NSObject) — Carrier attached to NSMenuItem.representedObject, bundles WindowInfo + PresetSize
- **AppDelegate** — NSStatusItem management, menu construction, `resizeSelectedWindow()` execution
- **WindowListMenu** (NSMenu, NSMenuDelegate) — Lazily populates window list via `menuNeedsUpdate()`; truncates long titles to ≤ 1/4 screen width; shows app icons (16×16) per entry
- **PresetSizeMenu** (NSMenu) — Lists preset sizes per window, disables sizes exceeding screen bounds

### WindowManager.swift
- **WindowInfo** (struct) — windowID, ownerName, windowName, ownerPID, bounds
- **WindowManager** — `discoverWindows()` / `resizeWindow(_:to:)` static methods

### SettingsStore.swift
- **ScreenshotSaveLocation** (enum) — `.desktop` / `.pictures`
- **SettingsStore** (ObservableObject, singleton) — `builtInSizes` (12) + `customSizes`, `launchAtLogin`, screenshot settings
- UserDefaults keys: `"customPresetSizes"`, `"launchAtLogin"`, `"screenshotEnabled"`, `"screenshotSaveToFile"`, `"screenshotSaveLocation"`, `"screenshotCopyToClipboard"`
- Posts `.settingsChanged` notification on change → AppDelegate rebuilds menu

### ScreenshotHelper.swift
- **ScreenshotHelper** — `captureWindow(_:completion:)` / `exportAsPNG(_:to:windowInfo:)` / `copyToClipboard(_:)` static methods
- macOS 14+: `SCScreenshotManager` (ScreenCaptureKit) for code-signed apps
- macOS 13: `CGWindowListCreateImage` fallback (deprecated API)
- Retina: NSImage size set to logical (point) dimensions, pixel data at full resolution
- Filename: `MMddHHmmss_AppName_WindowTitle.png` (all non-alphanumeric chars stripped)
- `buildFilename(windowInfo:)` generates filename; `sanitizeForFilename(_:)` strips symbols

### AccessibilityHelper.swift
- **AccessibilityHelper** — `isPermissionGranted()` / `isPermissionFunctional()` / `promptForPermission()` / `promptToReauthorize()`

## Key Architecture Decisions

### Window Enumeration & Resize
- `CGWindowListCopyWindowInfo` for window enumeration
- `AXUIElement` API for resize execution (Accessibility permission required)
- PID + window title matching (no direct CGWindowID → AXUIElement mapping exists)
- Falls back to first window when title doesn't match

### Menu UI
- Menu item width limited to 1/4 of display width; long titles truncated with "…"
- `NSString.size(withAttributes:)` measures rendered text width for accurate truncation
- App icons retrieved via `NSRunningApplication(processIdentifier:)?.icon` (16×16)
- Menu bar icon: 16×16pt (standard macOS size), loaded as template image

### Coordinate Systems
- **CGWindowList / SCWindow**: top-left origin
- **NSScreen**: bottom-left origin (Quartz coordinate system)
- `PresetSizeMenu.displayBounds(containing:)` converts between them for multi-display support

### Code Signing & Notarization
- Developer ID Application certificate (Team ID: G466Q9TVYB)
- Hardened Runtime enabled (`--options runtime`) — required for notarization
- `xcrun notarytool` submits to Apple, `xcrun stapler` attaches the ticket
- Keychain profile `notarytool-profile` stores Apple ID + app-specific password
- build.sh automates: build → sign → notarize → staple

### App Icon Strategy
- `.icns` generated from Icon Composer export (1024×1024 PNG → sips → iconutil)
- Asset Catalog (`Assets.xcassets`) compiled with `actool`, includes dark/tinted variants
- `.icon` package (Icon Composer format) bundled for macOS 26 Tahoe Liquid Glass support
- Dark mode app icons NOT effective until macOS 26; `.icon` format required (not Asset Catalog)
- Info.plist has both `CFBundleIconFile` (AppIcon) and `CFBundleIconName` (AppIcon)

### Accessibility Permission
- `AXIsProcessTrusted()` can return true even when stale after rebuild
- `isPermissionFunctional()` probes a live AXUIElement operation to verify

### Screenshot Feature
- Waits 0.5s after resize for window to finish redrawing
- macOS 14+: `SCScreenshotManager` (ScreenCaptureKit) — secure API for signed apps
- macOS 13: `CGWindowListCreateImage` fallback (deprecated)
- Retina: full-resolution pixels preserved, NSImage.size set to logical dimensions (144 DPI PNG output)
- Filename: `MMddHHmmss_AppName_WindowTitle.png` — all symbols stripped via `CharacterSet.alphanumerics`
- Save location: Desktop or Pictures (user setting)
- Clipboard copy: independent toggle
- Fails silently on permission denial (OS shows its own permission dialog)

### Localization (i18n)
- `NSLocalizedString` + `.lproj/Localizable.strings` (16 languages)
- Some languages include `InfoPlist.strings` for accessibility description
- `L("key")` shorthand helper
- Preset size labels (e.g. "MacBook Pro 16\"", "XGA") are not translated (product/standard names)

### Menu Structure
- NSStatusItem + NSMenu (AppKit)
- Tab-stop layout (230pt) for right-aligned labels (NSAttributedString + NSTextTab)
- WindowListMenu: NSMenuDelegate for lazy window enumeration
- Sizes exceeding screen resolution are automatically disabled

### Settings Window
- SwiftUI → NSHostingController → NSWindow
- Fixed width: 400pt; resizable height: 400–800pt
- Content top-aligned so expanding screenshot options does not shrink the preset list
- `.frame(width: 400)` + `.frame(minHeight: 400, idealHeight: 600, maxHeight: .infinity, alignment: .top)`

### Settings Persistence
- UserDefaults for custom presets (JSONEncoder/Decoder)
- SMAppService for launch-at-login

## Bundle ID
`com.windowresize.app`

## Conventions
- Localization keys use dot notation: `menu.resize`, `settings.width`, `alert.resize-failed.title`
- Avoid NSMenu property name collisions (e.g. `size` → `presetSize`)
- `resizeSelectedWindow` is called from WindowListMenu, so it cannot be `private`
- Source code total: ~1100 lines (10 files including Localization.swift)
- `.af` files (Pixelmator Pro) are source artwork — not bundled in the app
- `.icon` file (Icon Composer) IS bundled for future macOS 26 support

## Pending / Future
- User mentioned a 3rd UI improvement item (not yet specified — "3はあとで書きます")
- App Store publishing discussed but not started (requires sandbox, receipt validation, etc.)
