# Window Resize — User Manual

## Table of Contents

1. [Initial Setup](#initial-setup)
2. [Snap Resize](#snap-resize)
3. [Settings](#settings)
4. [Troubleshooting](#troubleshooting)

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

### Aspect Ratio Display

During resize, the current aspect ratio is displayed in the overlay. When the ratio matches a well-known proportion, its name is shown:

- **Golden Ratio** (1.618:1)
- **Silver Ratio** (2.414:1)
- **Platinum Ratio** (1.325:1)
- **Bronze Ratio** (3.303:1)

Other ratios are displayed as simplified fractions (e.g., "16:9", "4:3").

> This feature can be turned off in Settings (see [Show Aspect Ratio](#overlay-appearance)).

### Shift to Lock Aspect Ratio

Hold the **Shift** key while resizing to lock the aspect ratio. The window will maintain its current proportions as you drag.

> This feature can be turned off in Settings (see [Shift to Lock Ratio](#overlay-appearance)).

---

## Settings

Open Settings from the menu bar: click the Window Resize icon, then select **"Settings..."** (shortcut: **Cmd+,**).

### Built-in Sizes

The app includes 12 built-in preset sizes:

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

Built-in sizes cannot be removed or edited.

### Custom Sizes

You can add your own sizes to the list:

1. In the **"Custom"** section, enter the **Width** and **Height** in pixels.
2. Click **"Add"**.
3. The new size is immediately available for snap detection during resize.

To remove a custom size, click the red **"Remove"** button next to it.

### Overlay Appearance

Configure the visual style of the snap overlay:

- **Resize border** — the border color and line style (solid or dashed) shown when resizing near a preset. Default: orange, dashed.
- **Snap border** — the border color and line style shown when the window snaps to a preset. Default: orange, solid.
- **Show aspect ratio** — toggle the aspect ratio label in the overlay. Default: on.
- **Shift to lock ratio** — toggle whether holding Shift constrains the aspect ratio during resize. Default: on.

Available border colors: Orange, Blue, Green, Red, Purple, White.

### Launch at Login

Toggle **"Launch at Login"** to have Window Resize start automatically when you log in to macOS.

### Language

Select the app display language from the **Language** dropdown. Choose from 16 languages or **"System Default"** to follow the macOS system language. Changing the language requires an app restart.

### Accessibility Status

At the bottom of the Settings window, a status indicator shows the current state of the Accessibility permission:

| Indicator | Meaning |
|-----------|---------|
| Green | Permission is active and working correctly. |
| Orange | The system reports permission as granted, but it is no longer valid (see [Fixing Stale Permissions](#fixing-stale-permissions)). An "Open Settings" button is shown. |
| Red | Permission has not been granted. An "Open Settings" button is shown. |

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

### Window Rendering Issues After Snap

In rare cases, the target window may not redraw properly after snapping. The app automatically forces a redraw, but if visual artifacts persist, try minimizing and restoring the window.
