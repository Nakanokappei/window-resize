// Localization.swift — Shorthand wrapper for NSLocalizedString.
// Reduces verbosity at call sites: L("key") instead of
// NSLocalizedString("key", comment: "").

import Foundation

func L(_ key: String, comment: String = "") -> String {
    NSLocalizedString(key, comment: comment)
}
