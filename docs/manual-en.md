# Window Resize — User Manual

## Table of Contents

1. [Initial Setup](#initial-setup)
2. [Resizing a Window](#resizing-a-window)
3. [Settings](#settings)
4. [Troubleshooting](#troubleshooting)

---

## Initial Setup

### Granting Accessibility Permission

Window Resize uses the macOS Accessibility API to resize windows. You must grant permission the first time you launch the app.

1. Launch **Window Resize**. A system dialog will appear asking you to grant Accessibility access.
2. Click **"Open System Settings"** (or go manually to **System Settings > Privacy & Security > Accessibility**).
3. Find **"Window Resize"** in the list and turn on the toggle.
4. Return to the app — the menu bar icon will appear and the app is ready to use.

> **Note:** If the dialog does not appear, you can open Accessibility settings directly from the app's Settings window (see [Accessibility Status](#accessibility-status)).

---

## Resizing a Window

### Step-by-Step

1. Click the **Window Resize icon** in the menu bar.
2. Hover over **"Resize"** to open the window list.
3. All currently open windows are listed with their **application icon** and name as **[App Name] Window Title**. Long titles are automatically truncated to keep the menu readable.
4. Hover over a window to see the available preset sizes.
5. Click a size to resize the window immediately.

### How Sizes Are Displayed

Each size entry in the menu shows:

```
1920 x 1080          Full HD
```

- **Left:** Width x Height (in pixels)
- **Right:** Label (device name or standard name), displayed in gray

### Sizes That Exceed the Screen

If a preset size is larger than the display where the window is located, that size will be **grayed out and unselectable**. This prevents you from resizing a window beyond the screen boundaries.

> **Multi-display:** The app detects which display each window is on and adjusts the available sizes accordingly.

---

## Settings

Open Settings from the menu bar: click the Window Resize icon, then select **"Settings..."** (shortcut: **⌘,**).

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
3. The new size appears in the custom list and is immediately available in the resize menu.

To remove a custom size, click the red **"Remove"** button next to it.

> Custom sizes appear in the resize menu after the built-in sizes.

### Launch at Login

Toggle **"Launch at Login"** to have Window Resize start automatically when you log in to macOS.

### Screenshot

Toggle **"Take screenshot after resize"** to automatically capture the window after resizing.

When enabled, the following options are available:

- **Save to file** — Save the screenshot as a PNG file. When enabled, choose the save location:
  > **Filename format:** `MMddHHmmss_AppName_WindowTitle.png` (e.g. `0227193012_Safari_Apple.png`). Symbols are removed; only letters, digits, and underscores are used.
  - **Desktop** — Save to your Desktop folder.
  - **Pictures** — Save to your Pictures folder.
- **Copy to clipboard** — Copy the screenshot to the clipboard for pasting into other apps.

Both options can be enabled independently. For example, you can copy to the clipboard without saving to a file.

> **Note:** The screenshot feature requires **Screen Recording** permission. When you first use this feature, macOS will prompt you to grant permission in **System Settings > Privacy & Security > Screen Recording**.

### Accessibility Status

At the bottom of the Settings window, a status indicator shows the current state of the Accessibility permission:

| Indicator | Meaning |
|-----------|---------|
| 🟢 **Accessibility: Enabled** | Permission is active and working correctly. |
| 🟠 **Accessibility: Needs Refresh** | The system reports permission as granted, but it is no longer valid (see [Fixing Stale Permissions](#fixing-stale-permissions)). An **"Open Settings"** button is shown. |
| 🔴 **Accessibility: Not Enabled** | Permission has not been granted. An **"Open Settings"** button is shown. |

---

## Troubleshooting

### Fixing Stale Permissions

If you see an orange status indicator or the message "Accessibility: Needs Refresh", the permission has become stale. This can happen after the app is updated or rebuilt.

**To fix:**

1. Open **System Settings > Privacy & Security > Accessibility**.
2. Find **"Window Resize"** in the list.
3. Toggle it **OFF**, then toggle it back **ON**.
4. Alternatively, remove it from the list entirely, then re-launch the app to re-add it.

### Resize Failed

If you see a "Resize Failed" alert, possible causes include:

- The target application does not support Accessibility-based resizing.
- The window is in **full-screen mode** (exit full-screen first).
- The Accessibility permission is not active (check the status in Settings).

### Window Not Appearing in the List

The resize menu only shows windows that are:

- Currently visible on screen
- Not part of the desktop (e.g., Finder desktop is excluded)
- Not the Window Resize app's own windows

If a window is minimized to the Dock, it will not appear in the list.

### Screenshot Not Working

If screenshots are not being captured:

- Grant **Screen Recording** permission in **System Settings > Privacy & Security > Screen Recording**.
- Ensure at least one of **"Save to file"** or **"Copy to clipboard"** is enabled.
