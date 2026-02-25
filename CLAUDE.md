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
├── Info.plist               # App metadata (LSUIElement, BundleID, Localizations)
├── build.sh                 # Build script (swiftc → /tmp staging → sign → notarize → .app bundle)
├── README.md
├── LICENSE                  # MIT License
├── appicon.af               # App icon source (not bundled)
├── Window Size App Icon.icon/ # App icon source (not bundled)
├── docs/                    # User manuals (16 languages, markdown)
├── Sources/
│   ├── main.swift           # Entry point (.accessory policy, duplicate instance guard)
│   ├── AppDelegate.swift    # NSStatusItem, menu construction, resize orchestration
│   ├── WindowManager.swift  # CGWindowList enumeration + AXUIElement resize
│   ├── PresetSize.swift     # Dimension model (Codable, Identifiable, labeled)
│   ├── SettingsStore.swift  # UserDefaults persistence, SMAppService login item, screenshot config
│   ├── SettingsView.swift   # SwiftUI settings panel
│   ├── SettingsWindowController.swift  # NSHostingController wrapper
│   ├── ScreenshotHelper.swift          # SCScreenshotManager (macOS 14+) / CGWindowList fallback + Retina
│   ├── AccessibilityHelper.swift       # Permission check, stale detection, re-auth guidance
│   └── Localization.swift   # L() shorthand for NSLocalizedString
└── Resources/
    ├── AppIcon.icns          # App icon
    ├── MenuBarIcon.png       # Menu bar icon (18×18)
    ├── MenuBarIcon@2x.png    # Menu bar icon Retina (36×36)
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
- **WindowListMenu** (NSMenu, NSMenuDelegate) — Lazily populates window list via `menuNeedsUpdate()`
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
- **ScreenshotHelper** — `captureWindow(_:completion:)` / `exportAsPNG(_:to:)` / `copyToClipboard(_:)` static methods
- macOS 14+: `SCScreenshotManager` (ScreenCaptureKit) for code-signed apps
- macOS 13: `CGWindowListCreateImage` fallback (deprecated API)
- Retina: NSImage size set to logical (point) dimensions, pixel data at full resolution

### AccessibilityHelper.swift
- **AccessibilityHelper** — `isPermissionGranted()` / `isPermissionFunctional()` / `promptForPermission()` / `promptToReauthorize()`

## Key Architecture Decisions

### Window Enumeration & Resize
- `CGWindowListCopyWindowInfo` for window enumeration
- `AXUIElement` API for resize execution (Accessibility permission required)
- PID + window title matching (no direct CGWindowID → AXUIElement mapping exists)
- Falls back to first window when title doesn't match

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

### Accessibility Permission
- `AXIsProcessTrusted()` can return true even when stale after rebuild
- `isPermissionFunctional()` probes a live AXUIElement operation to verify

### Screenshot Feature
- Waits 0.5s after resize for window to finish redrawing
- macOS 14+: `SCScreenshotManager` (ScreenCaptureKit) — secure API for signed apps
- macOS 13: `CGWindowListCreateImage` fallback (deprecated)
- Retina: full-resolution pixels preserved, NSImage.size set to logical dimensions (144 DPI PNG output)
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

### Settings Persistence
- UserDefaults for custom presets (JSONEncoder/Decoder)
- SMAppService for launch-at-login
- Settings window: SwiftUI → NSHostingController → NSWindow (400×500 fixed size)

## Bundle ID
`com.windowresize.app`

## Conventions
- Localization keys use dot notation: `menu.resize`, `settings.width`, `alert.resize-failed.title`
- Avoid NSMenu property name collisions (e.g. `size` → `presetSize`)
- `resizeSelectedWindow` is called from WindowListMenu, so it cannot be `private`
- Source code total: ~850 lines (10 files including Localization.swift)
