// KeyboardResizeController.swift — Global keyboard shortcut handler for
// precision window resizing, undo/redo, and one-tap preset application.
//
// Uses a CGEvent tap to intercept key-down events globally. Unlike
// NSEvent.addGlobalMonitorForEvents (which only observes events without
// consuming them), a CGEvent tap can suppress the event so the foreground
// app never sees it — eliminating the system beep that occurs when an app
// receives an unrecognized key combination.
//
// CGEvent taps require Accessibility permission (already granted for
// AXUIElement usage) and are NOT available inside App Sandbox. This is
// acceptable because the app uses Developer ID distribution only.
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

    /// The CGEvent tap that intercepts key-down events. Stored as a
    /// CFMachPort so it can be invalidated on stop().
    private var eventTap: CFMachPort?

    /// Run loop source for the event tap. Must be removed from the run
    /// loop when the tap is stopped.
    private var runLoopSource: CFRunLoopSource?

    /// Reference to the shared overlay controller for brief size feedback.
    private let overlay = OverlayWindowController()

    /// Timer used to auto-hide the overlay after a keyboard operation.
    private var hideTimer: Timer?

    /// Duration the overlay stays visible after a keyboard resize (seconds).
    private static let overlayDuration: TimeInterval = 0.8

    /// Step size for normal resize operations, in pixels.
    private static let normalStepPx: CGFloat = 10

    /// Step size for precision resize operations (Shift held), in pixels.
    private static let precisionStepPx: CGFloat = 1

    // MARK: - Lifecycle

    /// Installs a CGEvent tap to intercept key-down events globally.
    /// The tap suppresses matched key events so the foreground app never
    /// receives them, preventing the system beep. Call once from
    /// AppDelegate after the accessibility check passes.
    func start() {
        // Store a reference to self in an Unmanaged pointer so the C
        // callback can reach back into this Swift instance.
        let refcon = Unmanaged.passUnretained(self).toOpaque()

        // Create an event tap at the session level. We only listen for
        // keyDown events; other event types pass through untouched.
        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,      // active tap — can suppress events
            eventsOfInterest: CGEventMask(1 << CGEventType.keyDown.rawValue),
            callback: KeyboardResizeController.eventTapCallback,
            userInfo: refcon
        ) else {
            // Fallback: if CGEvent tap creation fails (should not happen
            // when Accessibility permission is granted), fall back to the
            // observe-only NSEvent monitor. The beep will still occur but
            // keyboard shortcuts will work.
            let monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) {
                [weak self] event in
                self?.handleKeyDown(event)
            }
            // Store in eventTap as nil; monitor is retained by NSEvent.
            _ = monitor
            return
        }

        eventTap = tap

        // Add the tap to the current run loop so events are delivered.
        let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
        runLoopSource = source

        // Enable the tap (it starts enabled, but be explicit).
        CGEvent.tapEnable(tap: tap, enable: true)
    }

    /// Removes the CGEvent tap and cleans up run loop resources.
    /// Call from applicationWillTerminate.
    func stop() {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
            CFMachPortInvalidate(tap)
            eventTap = nil
        }
        if let source = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .commonModes)
            runLoopSource = nil
        }
        hideTimer?.invalidate()
        overlay.hideHUD()
    }

    // MARK: - CGEvent Tap Callback

    /// C-compatible callback invoked by the CGEvent tap for each key-down
    /// event. If the key matches a registered shortcut binding, the event
    /// is consumed (returns nil) to prevent the foreground app from
    /// receiving it and playing a beep. Non-matching events pass through.
    private static let eventTapCallback: CGEventTapCallBack = {
        proxy, type, event, refcon in

        // If the system disables the tap (e.g. due to timeout), re-enable it.
        if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
            if let refcon = refcon {
                let controller = Unmanaged<KeyboardResizeController>
                    .fromOpaque(refcon).takeUnretainedValue()
                if let tap = controller.eventTap {
                    CGEvent.tapEnable(tap: tap, enable: true)
                }
            }
            return Unmanaged.passUnretained(event)
        }

        guard type == .keyDown, let refcon = refcon else {
            return Unmanaged.passUnretained(event)
        }

        let controller = Unmanaged<KeyboardResizeController>
            .fromOpaque(refcon).takeUnretainedValue()

        // Check if this key-down matches any registered shortcut.
        if controller.handleCGEvent(event) {
            // Matched — suppress the event so the foreground app never
            // sees it (no beep).
            return nil
        }

        // Not our shortcut — pass through to the foreground app.
        return Unmanaged.passUnretained(event)
    }

    // MARK: - Event Dispatch

    /// Checks a CGEvent against registered shortcut bindings. If a match
    /// is found, executes the action and returns true (caller should
    /// suppress the event). Returns false if no binding matches.
    private func handleCGEvent(_ event: CGEvent) -> Bool {
        let keyCode = UInt16(event.getIntegerValueField(.keyboardEventKeycode))
        let cgFlags = event.flags

        // Convert CGEventFlags to NSEvent.ModifierFlags for comparison.
        // Only keep device-independent modifier bits matching what
        // ShortcutRecorderView records.
        var mods = NSEvent.ModifierFlags()
        if cgFlags.contains(.maskControl)   { mods.insert(.control) }
        if cgFlags.contains(.maskAlternate) { mods.insert(.option) }
        if cgFlags.contains(.maskShift)     { mods.insert(.shift) }
        if cgFlags.contains(.maskCommand)   { mods.insert(.command) }

        let bindings = SettingsStore.shared.shortcutBindings

        for (actionID, binding) in bindings {
            let bindingMods = NSEvent.ModifierFlags(rawValue: binding.modifiers)
            if mods == bindingMods && keyCode == binding.keyCode {
                // Dispatch to the main thread since CGEvent callbacks may
                // arrive on an arbitrary thread.
                DispatchQueue.main.async { [weak self] in
                    self?.executeAction(actionID)
                }
                return true
            }
        }
        return false
    }

    /// Legacy NSEvent handler — used only as fallback if CGEvent tap
    /// creation fails.
    private func handleKeyDown(_ event: NSEvent) {
        let mods = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            .subtracting([.capsLock, .numericPad, .function])
        let keyCode = event.keyCode
        let bindings = SettingsStore.shared.shortcutBindings

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
            resizeFrontWindow(dw: -Self.normalStepPx, dh: 0)
        case "growWidth":
            resizeFrontWindow(dw: Self.normalStepPx, dh: 0)
        case "shrinkHeight":
            resizeFrontWindow(dw: 0, dh: -Self.normalStepPx)
        case "growHeight":
            resizeFrontWindow(dw: 0, dh: Self.normalStepPx)

        // Precision resize (±1px)
        case "precisionShrinkWidth":
            resizeFrontWindow(dw: -Self.precisionStepPx, dh: 0)
        case "precisionGrowWidth":
            resizeFrontWindow(dw: Self.precisionStepPx, dh: 0)
        case "precisionShrinkHeight":
            resizeFrontWindow(dw: 0, dh: -Self.precisionStepPx)
        case "precisionGrowHeight":
            resizeFrontWindow(dw: 0, dh: Self.precisionStepPx)

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

        // Center-anchored resize: keep the window's visual center (midpoint)
        // fixed while the edges expand or contract symmetrically. The origin
        // shifts by half the size delta in each axis so that the midpoint
        // remains at (oldFrame.midX, oldFrame.midY).
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

        // Clamp each edge so the window stays inside the visible area.
        // Order matters: clamp left/top first, then right/bottom, so that
        // if the window fits it stays put; if it doesn't, size clamping below
        // pins it to the origin.
        if result.origin.x < visible.origin.x {     // Left edge overflows left
            result.origin.x = visible.origin.x
        }
        if result.origin.y < visible.origin.y {     // Top edge overflows top (CG coords)
            result.origin.y = visible.origin.y
        }
        if result.maxX > visible.maxX {              // Right edge overflows right
            result.origin.x = visible.maxX - result.width
        }
        if result.maxY > visible.maxY {              // Bottom edge overflows bottom
            result.origin.y = visible.maxY - result.height
        }

        // If the window is larger than the visible area in either dimension,
        // shrink it to fit and pin to the visible origin.
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
