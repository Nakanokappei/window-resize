// KeyboardResizeController.swift — Global keyboard shortcut handler for
// precision window resizing, undo/redo, and one-tap preset application.
//
// Shortcut bindings are loaded from SettingsStore.shortcutBindings,
// allowing users to customize all key combinations. Defaults:
//
//   ⌃⌥ →/←       Width  ±10px       (center anchored)
//   ⌃⌥ ↑/↓       Height ±10px       (↑=grow, ↓=shrink — intuitive, not CG-axis)
//   ⌃⌥⇧ →/←/↑/↓  Same at ±1px      (precision mode)
//   ⌃⌥ Z          Undo last resize
//   ⌃⌥⇧ Z         Redo
//   ⌃⌥ 1–9        Apply quick preset
//
// All resize operations keep the window centered on its original midpoint.
// If the resulting frame would exceed the screen's visible area, it is
// clamped to fit within the bounds.

import AppKit
import ApplicationServices

class KeyboardResizeController {

    // MARK: - Properties

    /// Global event monitor for key-down events.
    private var keyMonitor: Any?

    /// Reference to the shared overlay controller for brief size feedback.
    private let overlay = OverlayWindowController()

    /// Timer used to auto-hide the overlay after a keyboard operation.
    private var hideTimer: Timer?

    /// Duration the overlay stays visible after a keyboard resize (seconds).
    private static let overlayDuration: TimeInterval = 0.8

    /// Step size for normal resize operations (pixels).
    private static let normalStep: CGFloat = 10

    /// Step size for precision resize operations (Shift held, pixels).
    private static let precisionStep: CGFloat = 1

    // MARK: - Lifecycle

    /// Installs a global key-down monitor. Call once from AppDelegate after
    /// the accessibility check passes.
    func start() {
        keyMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyDown(event)
        }
    }

    /// Removes the global key-down monitor. Call from applicationWillTerminate.
    func stop() {
        if let monitor = keyMonitor {
            NSEvent.removeMonitor(monitor)
            keyMonitor = nil
        }
        hideTimer?.invalidate()
        overlay.hideHUD()
    }

    // MARK: - Event Dispatch (Dynamic Binding Lookup)

    /// Routes a key-down event to the appropriate handler by looking up the
    /// pressed key combination in the user's shortcut bindings map.
    private func handleKeyDown(_ event: NSEvent) {
        // Strip device-dependent, caps-lock, numericPad, and function flags
        // so that comparisons match the user-configured modifier set exactly.
        let mods = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            .subtracting([.capsLock, .numericPad, .function])
        let keyCode = event.keyCode
        let bindings = SettingsStore.shared.shortcutBindings

        // Walk all registered bindings and find the first exact match.
        for (actionID, binding) in bindings {
            let bindingMods = NSEvent.ModifierFlags(rawValue: binding.modifiers)
            if mods == bindingMods && keyCode == binding.keyCode {
                executeAction(actionID)
                return
            }
        }
    }

    /// Dispatches the named action to the appropriate handler method.
    private func executeAction(_ actionID: String) {
        switch actionID {
        // Normal resize (±10px)
        case "shrinkWidth":
            resizeFrontWindow(dw: -Self.normalStep, dh: 0)
        case "growWidth":
            resizeFrontWindow(dw: Self.normalStep, dh: 0)
        case "shrinkHeight":
            resizeFrontWindow(dw: 0, dh: -Self.normalStep)
        case "growHeight":
            resizeFrontWindow(dw: 0, dh: Self.normalStep)

        // Precision resize (±1px)
        case "precisionShrinkWidth":
            resizeFrontWindow(dw: -Self.precisionStep, dh: 0)
        case "precisionGrowWidth":
            resizeFrontWindow(dw: Self.precisionStep, dh: 0)
        case "precisionShrinkHeight":
            resizeFrontWindow(dw: 0, dh: -Self.precisionStep)
        case "precisionGrowHeight":
            resizeFrontWindow(dw: 0, dh: Self.precisionStep)

        // Undo / Redo
        case "undo":
            performUndo()
        case "redo":
            performRedo()

        // Quick presets (preset1 through preset9)
        default:
            if actionID.hasPrefix("preset"),
               let digit = Int(actionID.dropFirst(6)),
               digit >= 1 && digit <= 9 {
                applyQuickPreset(index: digit - 1)
            }
        }
    }

    // MARK: - Resize

    /// Adjusts the frontmost window's size by (dw, dh) pixels while keeping
    /// the window centered on its original midpoint.
    private func resizeFrontWindow(dw: CGFloat, dh: CGFloat) {
        guard let window = frontmostWindow() else { return }

        let oldFrame = window.bounds

        // Record the current frame for undo before applying the change.
        ResizeHistory.shared.pushState(windowID: window.windowID, frame: oldFrame)

        // Compute the new size, clamped to a minimum of 50×50.
        let newWidth = max(oldFrame.width + dw, 50)
        let newHeight = max(oldFrame.height + dh, 50)

        // Center-anchored: the midpoint stays fixed, so the origin shifts
        // by half the delta in each dimension.
        let newX = oldFrame.origin.x - (newWidth - oldFrame.width) / 2
        let newY = oldFrame.origin.y - (newHeight - oldFrame.height) / 2

        var newFrame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)

        // Clamp to the visible area of the screen containing the window center.
        newFrame = clampToScreen(newFrame)

        // Apply the new frame via AXUIElement.
        let success = SnapExecutor.execute(windowInfo: window, targetFrame: newFrame)
        if success {
            showOverlayBriefly(frame: newFrame, label: nil,
                               currentSize: newFrame.size)
        }
    }

    // MARK: - Undo / Redo

    /// Restores the frontmost window to its previous size from the undo stack.
    private func performUndo() {
        guard let window = frontmostWindow() else { return }

        guard let previousFrame = ResizeHistory.shared.undo(windowID: window.windowID) else {
            return
        }

        // Save the current frame to the redo stack before restoring.
        ResizeHistory.shared.pushRedo(windowID: window.windowID, frame: window.bounds)

        let success = SnapExecutor.execute(windowInfo: window, targetFrame: previousFrame)
        if success {
            showOverlayBriefly(frame: previousFrame, label: L("overlay.restored"),
                               currentSize: previousFrame.size)
        }
    }

    /// Re-applies a previously undone resize.
    private func performRedo() {
        guard let window = frontmostWindow() else { return }

        guard let nextFrame = ResizeHistory.shared.redo(windowID: window.windowID) else {
            return
        }

        // Save the current frame to the undo stack (without clearing redo).
        ResizeHistory.shared.pushUndoOnly(windowID: window.windowID, frame: window.bounds)

        let success = SnapExecutor.execute(windowInfo: window, targetFrame: nextFrame)
        if success {
            showOverlayBriefly(frame: nextFrame, label: nil,
                               currentSize: nextFrame.size)
        }
    }

    // MARK: - Quick Presets

    /// Applies the quick preset at the given index (0-based) to the
    /// frontmost window.
    private func applyQuickPreset(index: Int) {
        let presets = SettingsStore.shared.quickPresets
        guard index < presets.count else { return }
        guard let window = frontmostWindow() else { return }

        let preset = presets[index]

        // Record the current frame for undo.
        ResizeHistory.shared.pushState(windowID: window.windowID, frame: window.bounds)

        // Center the new size on the window's current midpoint.
        let midX = window.bounds.midX
        let midY = window.bounds.midY
        let newWidth = CGFloat(preset.width)
        let newHeight = CGFloat(preset.height)

        var newFrame = CGRect(
            x: midX - newWidth / 2,
            y: midY - newHeight / 2,
            width: newWidth,
            height: newHeight
        )

        newFrame = clampToScreen(newFrame)

        let success = SnapExecutor.execute(windowInfo: window, targetFrame: newFrame)
        if success {
            // Build label with usage name and dimensions.
            let label = preset.label ?? "\(preset.width) × \(preset.height)"
            showOverlayBriefly(frame: newFrame, label: label,
                               currentSize: newFrame.size)
        }
    }

    // MARK: - Frontmost Window

    /// Returns the topmost visible window from another application.
    ///
    /// Identification logic:
    /// 1. CGWindowListCopyWindowInfo with .optionOnScreenOnly + .excludeDesktopElements
    /// 2. Filter: layer==0, not self, width>0, height>0
    /// 3. First element in the filtered array = Z-order frontmost
    private func frontmostWindow() -> WindowInfo? {
        let windows = WindowManager.discoverWindows()
        return windows.first
    }

    // MARK: - Screen Clamping

    /// Adjusts a frame so it fits entirely within the visible area of the
    /// screen that contains the frame's center point. The visible frame
    /// excludes the menu bar and Dock.
    private func clampToScreen(_ frame: CGRect) -> CGRect {
        let center = CGPoint(x: frame.midX, y: frame.midY)
        guard let screen = ScreenGeometry.screenContaining(cgPoint: center) else {
            return frame
        }

        let visible = ScreenGeometry.visibleFrameInCG(for: screen)
        var result = frame

        // Clamp position so the window stays inside the visible area.
        if result.origin.x < visible.origin.x {
            result.origin.x = visible.origin.x
        }
        if result.origin.y < visible.origin.y {
            result.origin.y = visible.origin.y
        }
        if result.maxX > visible.maxX {
            result.origin.x = visible.maxX - result.width
        }
        if result.maxY > visible.maxY {
            result.origin.y = visible.maxY - result.height
        }

        // If the window is wider or taller than the screen, clamp size too.
        if result.width > visible.width {
            result.size.width = visible.width
            result.origin.x = visible.origin.x
        }
        if result.height > visible.height {
            result.size.height = visible.height
            result.origin.y = visible.origin.y
        }

        return result
    }

    // MARK: - Overlay Feedback

    /// Shows a centered HUD on the target window briefly after a keyboard
    /// operation, then fades it out after the configured duration.
    ///
    /// - Parameters:
    ///   - frame: The window frame in CG coordinates.
    ///   - label: Primary text (preset name, "Undo", etc.). Nil for resize.
    ///   - currentSize: The window's dimensions, shown as subtitle.
    private func showOverlayBriefly(frame: CGRect, label: String?,
                                     currentSize: CGSize) {
        // Cancel any pending hide timer from a previous operation.
        hideTimer?.invalidate()

        let sizeText = "\(Int(currentSize.width)) × \(Int(currentSize.height))"

        // When a named label exists (Quick Preset, Undo), show label as
        // primary and size as subtitle. For incremental resize (no label),
        // promote the size text to the primary position for readability.
        if let label = label {
            overlay.showHUD(on: frame, label: label, subtitle: sizeText)
        } else {
            overlay.showHUD(on: frame, label: sizeText, subtitle: nil)
        }

        // Schedule automatic hide after the brief display period.
        hideTimer = Timer.scheduledTimer(withTimeInterval: Self.overlayDuration,
                                         repeats: false) { [weak self] _ in
            self?.overlay.hideHUD()
        }
    }
}
