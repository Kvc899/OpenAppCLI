//
//  String+Extensions.swift
//  OpenApp CLI
//
//  Convenience helpers used throughout the CLI for string manipulation,
//  case-insensitive matching, and display formatting.
//

import Foundation

// MARK: - ANSI Colors

/// ANSI escape codes for terminal color output.
enum Color: String {
    case reset   = "\u{001B}[0m"
    case bold    = "\u{001B}[1m"
    case dim     = "\u{001B}[2m"
    case red     = "\u{001B}[31m"
    case green   = "\u{001B}[32m"
    case yellow  = "\u{001B}[33m"
    case blue    = "\u{001B}[34m"
    case magenta = "\u{001B}[35m"
    case cyan    = "\u{001B}[36m"
    case white   = "\u{001B}[37m"
}

extension String {

    // MARK: - Color Formatting

    /// Wraps the string in ANSI color codes for terminal output.
    func colored(_ color: Color) -> String {
        "\(color.rawValue)\(self)\(Color.reset.rawValue)"
    }

    /// Wraps the string in bold + color.
    func bold(_ color: Color = .white) -> String {
        "\(Color.bold.rawValue)\(color.rawValue)\(self)\(Color.reset.rawValue)"
    }

    /// Wraps the string in dim styling.
    var dimmed: String {
        "\(Color.dim.rawValue)\(self)\(Color.reset.rawValue)"
    }

    // MARK: - Searching

    /// Returns `true` if `self` contains `other`, ignoring case and diacritics.
    func containsIgnoringCase(_ other: String) -> Bool {
        range(of: other, options: [.caseInsensitive, .diacriticInsensitive]) != nil
    }

    // MARK: - Trimming

    /// Returns a copy with leading and trailing whitespace and newlines removed.
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Display

    /// Returns the string truncated to `maxLength` characters, appending "…" if truncated.
    func truncated(to maxLength: Int) -> String {
        guard count > maxLength, maxLength > 0 else { return self }
        return String(prefix(maxLength - 1)) + "…"
    }

    // MARK: - Fuzzy Matching

    /// A simple fuzzy-match score against `query`.
    ///
    /// Returns a value between 0.0 (no match) and 1.0 (exact, case-insensitive match).
    /// Higher scores indicate closer matches. Used by `AppLauncher` to rank results.
    func fuzzyMatchScore(against query: String) -> Double {
        let lowSelf = self.lowercased()
        let lowQuery = query.lowercased()

        // Exact match
        if lowSelf == lowQuery { return 1.0 }

        // Starts with the query
        if lowSelf.hasPrefix(lowQuery) { return 0.9 }

        // Contains the query as a substring
        if lowSelf.contains(lowQuery) { return 0.7 }

        // Check if all query characters appear in order (subsequence match)
        var selfIndex = lowSelf.startIndex
        var matched = 0
        for char in lowQuery {
            while selfIndex < lowSelf.endIndex {
                if lowSelf[selfIndex] == char {
                    matched += 1
                    selfIndex = lowSelf.index(after: selfIndex)
                    break
                }
                selfIndex = lowSelf.index(after: selfIndex)
            }
        }

        if matched == lowQuery.count {
            // All characters matched in order — score based on ratio
            return 0.3 + 0.2 * (Double(lowQuery.count) / Double(lowSelf.count))
        }

        return 0.0
    }
}
