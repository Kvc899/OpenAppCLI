//
//  AppLauncher.swift
//  OpenApp CLI
//
//  Launches macOS applications by name. Supports exact matching, partial
//  (substring) matching, and fuzzy matching. The best match is launched
//  using NSWorkspace.
//

import AppKit

/// Finds and launches applications by name.
enum AppLauncher {

    /// The minimum fuzzy-match score required to consider an app a valid match.
    private static let minimumMatchScore: Double = 0.3

    // MARK: - Public API

    /// Attempts to launch the application best matching `query`.
    ///
    /// - Parameter query: The user-supplied app name (or partial name).
    /// - Returns: `true` if an app was successfully launched; `false` otherwise.
    @discardableResult
    static func launch(query: String) -> Bool {
        let apps = AppFinder.findAllApps()

        guard let best = bestMatch(for: query, in: apps) else {
            printError("No application found matching \"\(query.colored(.yellow))\".")
            return false
        }

        return openApp(best)
    }

    // MARK: - Matching

    /// Finds the best-matching `AppInfo` for `query` from the given list.
    static func bestMatch(for query: String, in apps: [AppInfo]) -> AppInfo? {
        // 1. Exact match (case-insensitive)
        if let exact = apps.first(where: { $0.name.caseInsensitiveCompare(query) == .orderedSame }) {
            return exact
        }

        // 2. Score all apps using fuzzy matching and pick the highest
        let scored = apps
            .map { (app: $0, score: $0.name.fuzzyMatchScore(against: query)) }
            .filter { $0.score >= minimumMatchScore }
            .sorted { $0.score > $1.score }

        return scored.first?.app
    }

    // MARK: - Opening

    /// Opens a .app bundle at the given path using NSWorkspace.
    private static func openApp(_ app: AppInfo) -> Bool {
        let url = URL(fileURLWithPath: app.path)

        print("\("▶".colored(.green)) Launching \(app.name.bold(.cyan))...")

        let config = NSWorkspace.OpenConfiguration()
        let semaphore = DispatchSemaphore(value: 0)
        var success = false

        NSWorkspace.shared.openApplication(at: url, configuration: config) { _, error in
            if let error = error {
                printError("Failed to launch \(app.name): \(error.localizedDescription)")
            } else {
                success = true
            }
            semaphore.signal()
        }

        semaphore.wait()
        return success
    }

    // MARK: - Output Helpers

    private static func printError(_ message: String) {
        var stderr = FileHandle.standardError
        print("\("Error:".bold(.red)) \(message)", to: &stderr)
    }
}

// MARK: - TextOutputStream for stderr

extension FileHandle: @retroactive TextOutputStream {
    public func write(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.write(data)
        }
    }
}
