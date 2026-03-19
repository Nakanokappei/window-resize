# Window Resize for macOS

A menu bar application that snaps windows to preset sizes as you resize them.

Also available for Windows: [Window Resize for Windows](https://github.com/Nakanokappei/window-resize-windows)

## Features

- **Snap-to-preset resize** — drag to resize any window and it snaps to the nearest preset size automatically
- **Overlay preview** — a border overlay shows the target preset before you release the mouse
- **Aspect ratio display** — the current aspect ratio is shown during resize (with named ratios: Golden Ratio, Silver Ratio, etc.)
- **Shift to lock aspect ratio** — hold Shift while resizing to constrain the aspect ratio
- **12 built-in preset sizes** — Mac Retina displays + standard resolutions
- **Custom sizes** — add your own width x height presets
- **Configurable overlay** — choose border color (6 options) and line style (solid/dashed) for resize and snap overlays independently
- **Menu bar resident** — runs quietly in the menu bar
- **Launch at login** — optional auto-start via SMAppService
- **In-app language selection** — switch between 16 languages without changing system settings
- **Accessibility permission detection** — detects stale permissions after rebuild
- **16 languages** — English, Japanese, Simplified Chinese, Traditional Chinese, Korean, Spanish, French, German, Italian, Portuguese, Russian, Arabic, Hindi, Indonesian, Vietnamese, Thai

## Download

Download the latest release from [Releases](https://github.com/Nakanokappei/window-resize/releases).

> If blocked by Gatekeeper: `find "Window Resize.app" -exec xattr -c {} \;`

## Usage

1. Open `Window Resize.app`
2. Grant Accessibility permission when prompted (System Settings > Privacy & Security > Accessibility)
3. Drag to resize any window — when the size approaches a preset, an overlay border appears
4. Release the mouse to snap to the preset size
5. Open **Settings** from the menu bar to add custom sizes, configure overlay appearance, or change the language

## System Requirements

- macOS 13.0 (Ventura) or later
- Accessibility permission required

## Preset Sizes

| Size | Label |
|------|-------|
| 2560 x 1600 | MacBook Pro 16" |
| 2560 x 1440 | QHD / iMac |
| 1728 x 1117 | MacBook Pro 14" |
| 1512 x 982 | MacBook Air 15" |
| 1470 x 956 | MacBook Air 13" M3 |
| 1440 x 900 | MacBook Air 13" |
| 1920 x 1080 | Full HD |
| 1680 x 1050 | WSXGA+ |
| 1280 x 800 | WXGA |
| 1280 x 720 | HD |
| 1024 x 768 | XGA |
| 800 x 600 | SVGA |

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
