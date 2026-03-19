// ResizeHistory.swift — Tracks window frame history for Undo/Redo support.
//
// Maintains a per-window stack of CGRect frames so that keyboard resize,
// drag snap, and preset application can all be undone. Each window is
// identified by its CGWindowID, and each stack is capped at a maximum
// depth to bound memory usage.
//
// Thread safety: all access is expected from the main thread (AppKit event
// handling), so no synchronization is needed.

import CoreGraphics

class ResizeHistory {
    static let shared = ResizeHistory()

    // MARK: - Constants

    /// Maximum number of undo states stored per window.
    private static let maxDepth = 20

    // MARK: - State

    /// Undo stacks keyed by window ID. Each entry is a chronological list
    /// of frames, with the most recent at the end.
    private var undoStacks: [CGWindowID: [CGRect]] = [:]

    /// Redo stacks keyed by window ID. Populated when the user undoes a
    /// resize, cleared when a new resize is performed.
    private var redoStacks: [CGWindowID: [CGRect]] = [:]

    // MARK: - Push

    /// Records the current frame before a resize operation. Call this
    /// immediately before applying a new frame via SnapExecutor so that
    /// the user can undo back to this state.
    func pushState(windowID: CGWindowID, frame: CGRect) {
        undoStacks[windowID, default: []].append(frame)

        // Trim the stack if it exceeds the maximum depth.
        if undoStacks[windowID]!.count > Self.maxDepth {
            undoStacks[windowID]!.removeFirst()
        }

        // A new resize clears the redo stack for this window because
        // the timeline has diverged.
        redoStacks[windowID] = nil
    }

    // MARK: - Undo

    /// Returns the previous frame for the given window, or nil if there
    /// is nothing to undo. The caller should apply this frame via
    /// SnapExecutor and push the *current* frame onto the redo stack
    /// by calling pushRedo().
    func undo(windowID: CGWindowID) -> CGRect? {
        guard var stack = undoStacks[windowID], !stack.isEmpty else {
            return nil
        }
        let frame = stack.removeLast()
        undoStacks[windowID] = stack
        return frame
    }

    /// Records a frame on the redo stack. Call after successfully
    /// applying an undo so that the user can redo back to this state.
    func pushRedo(windowID: CGWindowID, frame: CGRect) {
        redoStacks[windowID, default: []].append(frame)
    }

    // MARK: - Redo

    /// Returns the next frame in the redo timeline, or nil if there is
    /// nothing to redo. The caller should apply this frame and push
    /// the *current* frame back onto the undo stack (without clearing
    /// the redo stack).
    func redo(windowID: CGWindowID) -> CGRect? {
        guard var stack = redoStacks[windowID], !stack.isEmpty else {
            return nil
        }
        let frame = stack.removeLast()
        redoStacks[windowID] = stack
        return frame
    }

    /// Records a frame on the undo stack without clearing the redo stack.
    /// Used exclusively during redo operations to allow subsequent undos.
    func pushUndoOnly(windowID: CGWindowID, frame: CGRect) {
        undoStacks[windowID, default: []].append(frame)
        if undoStacks[windowID]!.count > Self.maxDepth {
            undoStacks[windowID]!.removeFirst()
        }
    }
}
