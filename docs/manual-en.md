# Window Resize — User Manual

## Table of Contents

1. [Initial Setup](#initial-setup)
2. [Snap Resize](#snap-resize)
3. [Keyboard Shortcuts](#keyboard-shortcuts)
4. [Settings](#settings)
5. [Troubleshooting](#troubleshooting)

---

## Initial Setup

### Granting Accessibility Permission

Window Resize uses the macOS Accessibility API to detect and resize windows. You must grant permission the first time you launch the app.

1. Launch **Window Resize**. A system dialog will appear asking you to grant Accessibility access.
2. Click **"Open System Settings"** (or go manually to **System Settings > Privacy & Security > Accessibility**).
3. Find **"Window Resize"** in the list and turn on the toggle.
4. Return to the app — the menu bar icon will appear and the app is ready to use.

> **Note:** If the dialog does not appear, you can open Accessibility settings directly from the app's Settings window (see [Accessibility Status](#accessibility-status)).

---

## Snap Resize

### How It Works

Window Resize monitors window resize operations in real time. When you drag a window edge or corner to resize it, the app detects how close the window dimensions are to any preset size.

1. **Start resizing** — drag any window's edge or corner as you normally would.
2. **Overlay appears** — when the window size approaches a preset (within 30 pixels), a colored border overlay appears around the window showing the target preset size.
3. **Release to snap** — let go of the mouse and the window snaps precisely to the preset size.
4. **Cancel** — if you move the window size away from the preset before releasing, the overlay disappears and no snap occurs.

### Move Snap

Drag a window towards a screen edge or corner to snap it into position:

- **Edge snap** (left/right) — fills the height, preserves width
- **Edge snap** (top/bottom) — fills the width, preserves height
- **Corner snap** — positions the window in the corner, preserves both dimensions

### Aspect Ratio Display

During resize, the current aspect ratio is displayed in the overlay. When the ratio matches a well-known proportion, its name is shown:

- **Golden Ratio** (1.618:1)
- **Silver Ratio** (2.414:1)
- **Platinum Ratio** (1.325:1)
- **Bronze Ratio** (3.303:1)

Other ratios are displayed as simplified fractions (e.g., "16:9", "4:3").

> This feature can be turned off in Settings (see [Appearance Tab](#appearance-tab)).

### Shift to Lock Aspect Ratio

Hold the **Shift** key while resizing to lock the aspect ratio. The window will maintain its current proportions as you drag.

> This feature can be turned off in Settings (see [General Tab](#general-tab)).

---

## Keyboard Shortcuts

All keyboard shortcuts are fully customizable in the Shortcuts tab of Settings. Defaults:

### Quick Presets

Press **Control+Option+1** through **Control+Option+9** to instantly resize the frontmost window to a named preset. A centered HUD briefly shows the preset name and size.

| Shortcut | Default Preset |
|----------|---------------|
| Control+Option+1 | Writing (1280 x 800) |
| Control+Option+2 | Reading (900 x 1200) |
| Control+Option+3 | Browsing (1440 x 900) |
| Control+Option+4 | Sidebar (720 x 900) |
| Control+Option+5 | Preview (1920 x 1080) |

Quick Presets can be edited (label, size, and shortcut) in the General tab of Settings. Up to 9 presets are supported.

### Incremental Resize

Resize the frontmost window by 10 pixels per key press, keeping the window centered:

| Shortcut | Action |
|----------|--------|
| Control+Option+Right | Grow width (+10px) |
| Control+Option+Left | Shrink width (-10px) |
| Control+Option+Up | Grow height (+10px) |
| Control+Option+Down | Shrink height (-10px) |

### Precision Mode

Hold Shift for 1-pixel adjustments:

| Shortcut | Action |
|----------|--------|
| Control+Option+Shift+Right | Grow width (+1px) |
| Control+Option+Shift+Left | Shrink width (-1px) |
| Control+Option+Shift+Up | Grow height (+1px) |
| Control+Option+Shift+Down | Shrink height (-1px) |

### Undo / Redo

| Shortcut | Action |
|----------|--------|
| Control+Option+Z | Undo last resize |
| Control+Option+Shift+Z | Redo |

Each window maintains its own undo/redo history.

### HUD Feedback

When you use a keyboard shortcut, a centered HUD pill appears on the target window:

- **Quick Preset:** shows the preset name (e.g. "Writing") with size below (e.g. "1280 x 800")
- **Incremental resize:** shows the current size (e.g. "1290 x 800")
- **Undo:** shows "Restored" with the restored size

The HUD displays for 0.8 seconds, then fades out.

---

## Settings

Open Settings from the menu bar: click the Window Resize icon, then select **"Settings..."**.

Settings are organized into 4 tabs: **General**, **Appearance**, **Shortcuts**, and **Presets**.

### General Tab

#### Quick Presets

Configure up to 9 Quick Presets that can be applied via keyboard shortcuts (Control+Option+1-9). Each preset has:

- **Shortcut** — click the shortcut field to record a new key combination
- **Label** — a descriptive name (e.g. "Writing", "Coding")
- **Size** — width and height in pixels

To add a preset, fill in the label, width, and height fields at the bottom and click **"Add"**. To remove a preset, click the X button next to it.

#### Launch at Login

Toggle **"Launch at Login"** to have Window Resize start automatically when you log in to macOS.

#### Shift to Lock Ratio

Toggle whether holding the Shift key during resize constrains the aspect ratio. Default: on.

#### Accessibility Status

A status indicator shows the current state of the Accessibility permission:

| Indicator | Meaning |
|-----------|---------|
| Green | Permission is active and working correctly. |
| Orange | Permission is granted but stale (see [Fixing Stale Permissions](#fixing-stale-permissions)). |
| Red | Permission has not been granted. |

### Appearance Tab

Configure the visual style of the snap overlay:

- **Resize border** — the border color and line style shown while resizing. Choose from 9 colors (red, orange, yellow, green, cyan, blue, purple, white, gray) and 4 styles (none, solid, dashed, animated). Default: white, animated.
- **Snap border** — the border shown when the window snaps to a preset. Default: white, solid.
- **Show aspect ratio** — toggle the aspect ratio label in the overlay. Default: on.

### Shortcuts Tab

All keyboard shortcuts are displayed in a 2-column grid and can be individually customized:

1. Click the shortcut field next to any action.
2. Press the desired key combination (must include at least one modifier key).
3. Press **Escape** to cancel recording.

If you record a shortcut that conflicts with another action in the app, an alert dialog appears offering to **Replace** (reassign the shortcut) or **Cancel**.

A warning icon appears next to shortcuts that conflict with known system shortcuts (Mission Control, Spotlight, etc.).

Click **"Reset to Defaults"** to restore all shortcuts to their original bindings.

### Presets Tab

The Presets tab shows 18 built-in preset sizes sorted by pixel area (smallest to largest). Each preset has an enable/disable toggle:

- **Enabled** — the preset is used for snap detection during resize
- **Disabled** — the preset is excluded from snap detection (shown at 50% opacity)

Built-in presets cannot be deleted, only disabled. By default, 6 Mac-specific presets (MacBook Air/Pro display sizes) are disabled, and 12 general-purpose presets are enabled.

The header shows how many presets are currently enabled (e.g. "12 of 18 enabled").

---

## Troubleshooting

### Fixing Stale Permissions

If you see an orange status indicator or the message "Accessibility: Needs Refresh", the permission has become stale. This can happen after the app is updated or rebuilt.

**To fix:**

1. Open **System Settings > Privacy & Security > Accessibility**.
2. Find **"Window Resize"** in the list.
3. Toggle it **OFF**, then toggle it back **ON**.
4. Alternatively, remove it from the list entirely, then re-launch the app to re-add it.

### Snap Not Working

If the overlay does not appear during resize:

- Check that Accessibility permission is active (green indicator in Settings).
- Make sure the window you are resizing supports standard resize (some apps restrict window sizing).
- Full-screen windows cannot be resized — exit full-screen first.
- Check the Presets tab — the target size may be disabled.

### Window Rendering Issues After Snap

In rare cases, the target window may not redraw properly after snapping. The app automatically forces a redraw, but if visual artifacts persist, try minimizing and restoring the window.
