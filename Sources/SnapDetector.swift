// SnapDetector.swift — Determines whether a window being dragged should snap
// to a preset size (during resize) or a screen zone (during move).
// Pure logic with no side effects — takes measurements in, returns candidates out.

import AppKit

/// Represents a snap candidate: either a preset size match during resize,
/// or an edge/corner zone match during move.
enum SnapCandidate: Equatable {
    /// The window is near a preset size during a resize drag.
    /// Contains the preset to snap to and the target frame (position preserved,
    /// size adjusted to the preset).
    case presetSize(preset: PresetSize, targetFrame: CGRect)

    /// The window is near a screen edge/corner during a move drag.
    /// Contains the zone and the target frame (half/quarter screen).
    case edgeZone(zone: SnapZone, targetFrame: CGRect)

    /// The target frame where the window will be placed if snapped.
    var targetFrame: CGRect {
        switch self {
        case .presetSize(_, let frame): return frame
        case .edgeZone(_, let frame): return frame
        }
    }
}

struct SnapDetector {

    /// Proximity threshold for preset size snapping (points).
    /// The window's current size must be within this distance on both axes
    /// to trigger a preset snap.
    static let presetThreshold: CGFloat = 30.0

    /// Extended threshold for showing "nearby" presets as navigation guides.
    /// Deliberately wide so the user can see which presets they'll reach
    /// by continuing to drag in the current direction.
    static let nearbyThreshold: CGFloat = 300.0

    /// Maximum number of nearby presets to display in the hint panel.
    static let maxNearbyEntries: Int = 5

    /// Detects the best snap candidate during a resize operation.
    /// Compares the window's current dimensions against all presets and returns
    /// the closest match within the threshold, if any.
    ///
    /// The target frame preserves the window's current top-left position
    /// and adjusts size to the matched preset.
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

            // Use Euclidean distance to rank candidates when multiple presets
            // are within threshold (e.g. 1280x800 vs 1280x720).
            let distance = sqrt(dw * dw + dh * dh)
            if distance < bestDistance {
                bestDistance = distance
                let targetFrame = CGRect(
                    x: currentFrame.origin.x,
                    y: currentFrame.origin.y,
                    width: presetW,
                    height: presetH
                )
                bestCandidate = .presetSize(preset: preset, targetFrame: targetFrame)
            }
        }

        return bestCandidate
    }

    /// Returns all presets within the extended nearby threshold, sorted by
    /// Euclidean distance from the current window size. Used to display
    /// alternative snap sizes alongside the primary candidate.
    static func detectNearbyPresets(currentFrame: CGRect,
                                     presets: [PresetSize]) -> [(preset: PresetSize, distance: CGFloat)] {
        var results: [(preset: PresetSize, distance: CGFloat)] = []

        for preset in presets {
            let presetW = CGFloat(preset.width)
            let presetH = CGFloat(preset.height)
            let dw = abs(currentFrame.width - presetW)
            let dh = abs(currentFrame.height - presetH)

            // Both dimensions must be within the wider nearby threshold.
            guard dw <= nearbyThreshold && dh <= nearbyThreshold else { continue }

            let distance = sqrt(dw * dw + dh * dh)
            results.append((preset: preset, distance: distance))
        }

        // Sort by distance so the closest preset appears first.
        // Limit to maxNearbyEntries for readability.
        return results.sorted { $0.distance < $1.distance }
            .prefix(maxNearbyEntries).map { $0 }
    }

    /// Detects the best snap candidate during a move operation.
    /// Checks the mouse position against screen edges/corners to determine
    /// if the window should snap to a screen zone.
    ///
    /// Edge snaps preserve one dimension (e.g. left edge: keep width, fill height).
    /// Corner snaps preserve both dimensions, positioning in the corner.
    ///
    /// Mouse position must be in CG coordinates (top-left origin).
    static func detectMoveSnap(mouseInCG: CGPoint,
                                screen: NSScreen,
                                windowSize: CGSize) -> SnapCandidate? {
        guard let zone = ScreenGeometry.detectEdgeZone(mouseInCG: mouseInCG, on: screen) else {
            return nil
        }

        let targetFrame = zone.targetFrame(on: screen, windowSize: windowSize)
        return .edgeZone(zone: zone, targetFrame: targetFrame)
    }
}
