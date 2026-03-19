// SnapDetector.swift — Determines whether a window being resized should snap
// to a preset size. Pure logic with no side effects — takes measurements in,
// returns candidates out.

import AppKit

/// Represents a snap candidate: a preset size match found during resize.
/// When the user's window dimensions fall within `presetThreshold` of a preset,
/// a candidate is created with the target frame the window will snap to.
struct SnapCandidate: Equatable {
    /// The preset to snap to.
    let preset: PresetSize

    /// The target frame where the window will be placed if snapped
    /// (position preserved from current frame, size adjusted to the preset).
    let targetFrame: CGRect
}

struct SnapDetector {

    /// Proximity threshold for preset size snapping (points).
    /// Both width and height must be within this distance to trigger a snap.
    static let presetThreshold: CGFloat = 30.0

    /// Detects the best snap candidate during a resize operation.
    ///
    /// Compares the window's current dimensions against all presets and returns
    /// the closest match within the threshold, if any. When multiple presets
    /// fall within threshold (e.g. 1280×800 vs 1280×720), the one with the
    /// smallest Euclidean distance wins.
    ///
    /// The target frame preserves the window's current top-left position
    /// and adjusts only the size to the matched preset.
    static func detectResizeSnap(currentFrame: CGRect,
                                  presets: [PresetSize]) -> SnapCandidate? {
        var bestCandidate: SnapCandidate?
        var bestDistance: CGFloat = .greatestFiniteMagnitude

        for preset in presets {
            let presetW = CGFloat(preset.width)
            let presetH = CGFloat(preset.height)
            let dw = abs(currentFrame.width - presetW)
            let dh = abs(currentFrame.height - presetH)

            // Both dimensions must be within threshold.
            guard dw <= presetThreshold && dh <= presetThreshold else { continue }

            // Use Euclidean distance to rank candidates.
            let distance = sqrt(dw * dw + dh * dh)
            if distance < bestDistance {
                bestDistance = distance
                let targetFrame = CGRect(
                    x: currentFrame.origin.x,
                    y: currentFrame.origin.y,
                    width: presetW,
                    height: presetH
                )
                bestCandidate = SnapCandidate(preset: preset, targetFrame: targetFrame)
            }
        }

        return bestCandidate
    }
}
