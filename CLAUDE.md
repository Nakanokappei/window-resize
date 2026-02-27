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

### Developer ID (direct distribution)
```bash
bash build.sh
open "build/Window Resize.app"
```
- Builds in /tmp staging area (avoids iCloud Drive xattr issues with codesign)
- Developer ID signing + Hardened Runtime (`--options runtime`)
- Apple Notarization + Staple automated in build.sh
- Keychain profile `notarytool-profile` stores notarization credentials

### App Store
```bash
bash build-appstore.sh
```
- Signs with Apple Distribution certificate + App Sandbox entitlements
- Creates installer .pkg with `productbuild`
- Upload via `xcrun altool` or Transporter
- Requires: provisioning profile at `./WindowResize_AppStore.provisionprofile`

### Testing
- Language test: `open "build/Window Resize.app" --args -AppleLanguages "(ja)"`

## Project Structure
```
Window Resize/
├── CLAUDE.md
├── Info.plist               # App metadata (LSUIElement, BundleID, LSApplicationCategoryType)
├── WindowResize.entitlements # App Sandbox entitlements (App Store build only)
├── build.sh                 # Developer ID build (swiftc → sign → notarize → staple)
├── build-appstore.sh        # App Store build (swiftc → sign w/ entitlements → .pkg)
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
│   ├── SettingsStore.swift  # UserDefaults persistence, SMAppService, screenshot folder bookmark
│   ├── SettingsView.swift   # SwiftUI settings panel (fixed width, auto-height)
│   ├── SettingsWindowController.swift  # NSHostingController wrapper (400pt wide, auto-height via KVO)
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
- **SettingsStore** (ObservableObject, singleton) — `builtInSizes` (12) + `customSizes`, `launchAtLogin`, screenshot settings
- UserDefaults keys: `"customPresetSizes"`, `"launchAtLogin"`, `"screenshotEnabled"`, `"screenshotSaveToFile"`, `"screenshotSaveFolderBookmark"`, `"screenshotCopyToClipboard"`
- Screenshot folder: security-scoped bookmark via NSOpenPanel + `URL.bookmarkData(options: .withSecurityScope)`
- Migrates legacy `"screenshotSaveLocation"` (Desktop/Pictures enum) to bookmark on first run
- Posts `.settingsChanged` notification on change → AppDelegate rebuilds menu

### ScreenshotHelper.swift
- **ScreenshotHelper** — `captureWindow(_:completion:)` / `exportAsPNG(_:to:windowInfo:)` / `copyToClipboard(_:)` static methods
- macOS 14+: `SCScreenshotManager` (ScreenCaptureKit) for code-signed apps
- macOS 13: `CGWindowListCreateImage` fallback (deprecated API)
- Retina: NSImage size set to logical (point) dimensions, pixel data at full resolution
- Filename: `MMddHHmmss_AppName_WindowTitle.png` (all non-alphanumeric chars stripped)
- `exportAsPNG` accepts a `URL` directory, uses `startAccessingSecurityScopedResource()` for sandbox compatibility

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

### Code Signing & Distribution
- **Developer ID** (build.sh): Developer ID Application certificate, Hardened Runtime, notarization + staple
- **App Store** (build-appstore.sh): Apple Distribution certificate, App Sandbox entitlements, .pkg via productbuild
- Team ID: G466Q9TVYB
- Keychain profile `notarytool-profile` stores Apple ID + app-specific password (Developer ID only)

### App Sandbox (App Store)
- Entitlements: `com.apple.security.app-sandbox` + `com.apple.security.files.user-selected.read-write`
- Accessibility (AXUIElement) and Screen Recording (ScreenCaptureKit) work under sandbox via TCC
- Screenshot save folder: user selects via NSOpenPanel, persisted as security-scoped bookmark
- NSPasteboard, SMAppService, UserDefaults work without additional entitlements

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
- Save folder: user-selected via NSOpenPanel, persisted as security-scoped bookmark in UserDefaults
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
- Fixed width: 400pt; height auto-adjusts to content (not user-resizable)
- `NSHostingController.sizingOptions = .preferredContentSize` reports ideal height
- KVO on `preferredContentSize` triggers animated window resize when toggles show/hide sub-options
- `.frame(width: 400)` only — no height constraints, content determines natural height

### Settings Persistence
- UserDefaults for custom presets (JSONEncoder/Decoder)
- SMAppService for launch-at-login
- Screenshot folder: security-scoped bookmark (Data) in UserDefaults

## Bundle ID
`com.windowresize.app`

## Conventions
- Localization keys use dot notation: `menu.resize`, `settings.width`, `alert.resize-failed.title`
- Avoid NSMenu property name collisions (e.g. `size` → `presetSize`)
- `resizeSelectedWindow` is called from WindowListMenu, so it cannot be `private`
- Source code total: ~1200 lines (10 files including Localization.swift)
- `.af` files (Pixelmator Pro) are source artwork — not bundled in the app
- `.icon` file (Icon Composer) IS bundled for future macOS 26 support

## Pending / Future
- App Store: certificates, provisioning profile, and App Store Connect setup needed before first submission
