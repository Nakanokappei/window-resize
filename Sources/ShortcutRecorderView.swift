// ShortcutRecorderView.swift — NSViewRepresentable that captures keyboard
// input for customizing global shortcut bindings.
//
// The view displays the current binding (e.g. "⌃⌥→") as a clickable button.
// On click it enters recording mode, captures the next key-down event
// (modifier flags + key code), and updates the binding. Escape cancels.
// Only events with at least one modifier key are accepted; bare keys are
// rejected to prevent accidental overrides of normal typing.

import AppKit
import SwiftUI

// MARK: - SwiftUI Wrapper

struct ShortcutRecorderView: NSViewRepresentable {
    @Binding var binding: SettingsStore.ShortcutBinding
    let isRecording: Binding<Bool>

    func makeNSView(context: Context) -> KeyRecorderNSView {
        let view = KeyRecorderNSView()
        view.onRecordingStarted = {
            isRecording.wrappedValue = true
        }
        view.onBindingChanged = { newBinding in
            binding = newBinding
            isRecording.wrappedValue = false
        }
        view.onCancelled = {
            isRecording.wrappedValue = false
        }
        view.displayString = SettingsStore.displayString(for: binding)
        return view
    }

    func updateNSView(_ nsView: KeyRecorderNSView, context: Context) {
        // Update the displayed string when the binding changes externally.
        nsView.displayString = SettingsStore.displayString(for: binding)

        // Start or stop recording based on the SwiftUI binding state.
        if isRecording.wrappedValue && !nsView.isRecording {
            nsView.startRecording()
        } else if !isRecording.wrappedValue && nsView.isRecording {
            nsView.stopRecording()
        }
    }
}

// MARK: - AppKit View

/// An NSView that captures key-down events when in recording mode.
/// It renders as a rounded rectangle button showing the current shortcut
/// or a "press shortcut…" prompt when recording.
class KeyRecorderNSView: NSView {

    /// Callback invoked when recording starts (mouse click on the view).
    var onRecordingStarted: (() -> Void)?

    /// Callback invoked when a valid shortcut is captured.
    var onBindingChanged: ((SettingsStore.ShortcutBinding) -> Void)?

    /// Callback invoked when recording is cancelled (Escape pressed).
    var onCancelled: (() -> Void)?

    /// The human-readable display string for the current binding.
    var displayString: String = "" {
        didSet { needsDisplay = true }
    }

    /// Whether the view is currently listening for key input.
    private(set) var isRecording = false

    /// Tracks modifier keys pressed during recording for live display.
    private var currentModifierString: String = ""

    // MARK: - First Responder

    override var acceptsFirstResponder: Bool { true }

    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        return result
    }

    override func resignFirstResponder() -> Bool {
        if isRecording {
            stopRecording()
            onCancelled?()
        }
        return super.resignFirstResponder()
    }

    // MARK: - Recording Control

    /// Enters recording mode: highlights the view and starts listening.
    func startRecording() {
        isRecording = true
        currentModifierString = ""
        window?.makeFirstResponder(self)
        needsDisplay = true
    }

    /// Exits recording mode without changing the binding.
    func stopRecording() {
        isRecording = false
        currentModifierString = ""
        needsDisplay = true
    }

    // MARK: - Mouse Handling

    override func mouseDown(with event: NSEvent) {
        if !isRecording {
            startRecording()
            onRecordingStarted?()
        }
    }

    // MARK: - Key Event Handling

    override func keyDown(with event: NSEvent) {
        guard isRecording else {
            super.keyDown(with: event)
            return
        }

        // Escape cancels recording.
        if event.keyCode == 53 {
            stopRecording()
            onCancelled?()
            return
        }

        // Require at least one modifier key (control, option, shift, or command).
        let mods = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            .subtracting([.capsLock, .numericPad, .function])
        let hasModifier = mods.contains(.control) || mods.contains(.option)
            || mods.contains(.shift) || mods.contains(.command)

        guard hasModifier else {
            // Bare key without modifiers — play alert and stay in recording mode.
            NSSound.beep()
            return
        }

        // Build and deliver the new binding.
        let newBinding = SettingsStore.ShortcutBinding(
            modifiers: mods.rawValue,
            keyCode: event.keyCode
        )

        stopRecording()
        onBindingChanged?(newBinding)
    }

    override func flagsChanged(with event: NSEvent) {
        guard isRecording else {
            super.flagsChanged(with: event)
            return
        }

        // Show live modifier preview while recording.
        let mods = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
            .subtracting([.capsLock, .numericPad, .function])
        var str = ""
        if mods.contains(.control) { str += "⌃" }
        if mods.contains(.option)  { str += "⌥" }
        if mods.contains(.shift)   { str += "⇧" }
        if mods.contains(.command) { str += "⌘" }
        currentModifierString = str
        needsDisplay = true
    }

    // MARK: - Drawing

    override func draw(_ dirtyRect: NSRect) {
        // Guard against drawing when the view has no valid window context.
        // This can happen when focus returns to an .accessory policy app
        // and AppKit triggers a redraw before the graphics state is ready.
        guard window != nil else { return }

        let rect = bounds.insetBy(dx: 1, dy: 1)
        let path = NSBezierPath(roundedRect: rect, xRadius: 5, yRadius: 5)

        // Background fill.
        if isRecording {
            NSColor.controlAccentColor.withAlphaComponent(0.15).setFill()
        } else {
            NSColor.controlBackgroundColor.setFill()
        }
        path.fill()

        // Border stroke.
        if isRecording {
            NSColor.controlAccentColor.withAlphaComponent(0.6).setStroke()
        } else {
            NSColor.separatorColor.setStroke()
        }
        path.lineWidth = 1.0
        path.stroke()

        // Text content.
        let text: String
        if isRecording {
            // Show live modifier preview or prompt.
            text = currentModifierString.isEmpty
                ? L("settings.shortcuts.press-shortcut")
                : currentModifierString + "…"
        } else {
            text = displayString
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        // Use a safely obtained font — monospacedSystemFont can return a
        // font whose internal attributes become invalid during window
        // deactivation/reactivation in .accessory policy apps.
        let font = NSFont.monospacedSystemFont(ofSize: 11, weight: .medium)
        let color: NSColor = isRecording
            ? NSColor.controlAccentColor
            : NSColor.labelColor

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as Any,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle,
        ]

        let attrString = NSAttributedString(string: text, attributes: attributes)
        let textSize = attrString.size()
        let textRect = NSRect(
            x: (bounds.width - textSize.width) / 2,
            y: (bounds.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        attrString.draw(in: textRect)
    }
}
