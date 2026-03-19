# Window Resize for macOS

A menu bar application that snaps windows to preset sizes as you resize them, with full keyboard control.

Also available for Windows: [Window Resize for Windows](https://github.com/Nakanokappei/window-resize-windows)

## Features

### Snap Resize
- **Snap-to-preset resize** — drag to resize any window and it snaps to the nearest preset size automatically
- **Move snap** — drag a window to a screen edge or corner to snap it into position
- **Overlay preview** — configurable border (9 colors, solid/dashed/animated) shows the target preset
- **Aspect ratio display** — current ratio shown during resize (Golden Ratio, Silver Ratio, etc.)
- **Shift to lock aspect ratio** — hold Shift while resizing to constrain proportions

### Keyboard Shortcuts
- **Quick Presets (Control+Option+1-9)** — instantly resize the frontmost window to a named preset
- **Incremental resize (Control+Option+Arrows)** — grow/shrink by 10px per press, center-anchored
- **Precision mode (Control+Option+Shift+Arrows)** — grow/shrink by 1px
- **Undo/Redo (Control+Option+Z / Control+Option+Shift+Z)** — per-window resize history
- **All shortcuts fully customizable** in Settings with conflict detection

### Centered HUD Feedback
- Keyboard operations show a centered HUD on the target window
- Label-primary display with size subtitle, 0.8 second display with fade-out

### Settings (4 tabs)
- **General** — Quick Presets (editable labels, sizes, shortcuts), Launch at Login, Language
- **Appearance** — overlay border color (9 choices), line style (solid/dashed/animated), aspect ratio label
- **Shortcuts** — all keyboard bindings customizable in 2-column grid, conflict alerts
- **Presets** — 18 built-in presets (VGA to 4K UHD) with enable/disable toggles

### Other
- **Menu bar resident** — runs quietly in the menu bar
- **Launch at login** — optional auto-start via SMAppService
- **In-app language selection** — switch between 16 languages without changing system settings
- **16 languages** — English, Japanese, Simplified Chinese, Traditional Chinese, Korean, Spanish, French, German, Italian, Portuguese, Russian, Arabic, Hindi, Indonesian, Vietnamese, Thai

## Download

Download the latest release from [Releases](https://github.com/Nakanokappei/window-resize/releases).

> If blocked by Gatekeeper: `find "Window Resize.app" -exec xattr -c {} \;`

## Usage

1. Open `Window Resize.app`
2. Grant Accessibility permission when prompted (System Settings > Privacy & Security > Accessibility)
3. **Drag resize** — drag a window edge; when the size approaches a preset, an overlay border appears. Release to snap.
4. **Keyboard** — press Control+Option+1 to apply Quick Preset 1 ("Writing" 1280x800). Use Control+Option+Arrows for fine adjustment.
5. Open **Settings** from the menu bar to customize presets, shortcuts, and overlay appearance.

## System Requirements

- macOS 13.0 (Ventura) or later
- Accessibility permission required

## Built-in Preset Sizes

18 presets sorted by pixel area (6 Mac-specific presets disabled by default):

| Size | Label | Default |
|------|-------|---------|
| 640 x 480 | VGA | On |
| 800 x 600 | SVGA | On |
| 1024 x 768 | XGA | On |
| 1280 x 720 | HD | On |
| 1280 x 800 | WXGA | On |
| 1080 x 1080 | Instagram | On |
| 1280 x 1024 | SXGA | On |
| 1440 x 900 | MacBook Air 13" | Off |
| 1024 x 1366 | iPad | On |
| 1470 x 956 | MacBook Air 13" M3 | Off |
| 1512 x 982 | MacBook Air 15" | Off |
| 1680 x 1050 | WSXGA+ | On |
| 1728 x 1117 | MacBook Pro 14" | Off |
| 1920 x 1080 | Full HD | On |
| 1920 x 1200 | WUXGA | On |
| 2560 x 1440 | QHD / iMac | Off |
| 2560 x 1600 | MacBook Pro 16" | Off |
| 3840 x 2160 | 4K UHD | On |

## Quick Preset Defaults

| Shortcut | Label | Size | Shape |
|----------|-------|------|-------|
| Control+Option+1 | Writing | 1280 x 800 | Landscape 16:10 |
| Control+Option+2 | Reading | 900 x 1200 | Portrait 3:4 |
| Control+Option+3 | Browsing | 1440 x 900 | Wide 16:10 |
| Control+Option+4 | Sidebar | 720 x 900 | Narrow 4:5 |
| Control+Option+5 | Preview | 1920 x 1080 | Full wide 16:9 |

## Build from Source

No Xcode project required — builds with `swiftc` and a shell script.

```bash
bash build.sh
open "build/Window Resize.app"
```

The build script signs the app with Developer ID, submits it for Apple notarization, and staples the ticket automatically.

### Test with a specific language

```bash
open "build/Window Resize.app" --args -AppleLanguages "(ja)"
```

## License

[MIT License](LICENSE)
