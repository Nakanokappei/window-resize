# Window Resize for macOS

A menu bar application that resizes windows to preset sizes.

Also available for Windows: [Window Resize for Windows](https://github.com/Nakanokappei/window-resize-windows)

## Features

- **Menu bar resident** — click the icon to open the menu
- **12 built-in preset sizes** — Mac Retina displays + standard resolutions
- **Custom sizes** — add your own width x height presets
- **Launch at login** — optional auto-start via SMAppService
- **Accessibility permission detection** — detects stale permissions after rebuild
- **16 languages** — English, Simplified Chinese, Spanish, Hindi, Arabic, Indonesian, Portuguese, French, Japanese, Russian, German, Vietnamese, Thai, Korean, Italian, Traditional Chinese

## Download

Download the latest release from [Releases](https://github.com/Nakanokappei/window-resize/releases).

> If blocked by Gatekeeper: `find "Window Resize.app" -exec xattr -c {} \;`

## Usage

1. Open `Window Resize.app`
2. Grant Accessibility permission when prompted (System Settings > Privacy & Security > Accessibility)
3. Click the menu bar icon
4. Select **Resize** > choose a window > select a preset size
5. Open **Settings** to add custom sizes or enable launch at login

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
