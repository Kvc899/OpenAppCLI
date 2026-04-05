//
//  AppInfo.swift
//  OpenApp CLI
//
//  A model representing an installed macOS application.
//  Stores the app's display name, bundle identifier, and file system path.
//

import Foundation

/// Represents a discovered macOS application.
struct AppInfo: Equatable, Comparable {
    /// The display name of the application (e.g. "Safari").
    let name: String

    /// The CFBundleIdentifier of the application (e.g. "com.apple.Safari").
    /// May be nil if the bundle cannot be read.
    let bundleIdentifier: String?

    /// The full file system path to the .app bundle.
    let path: String

    // MARK: - Comparable

    static func < (lhs: AppInfo, rhs: AppInfo) -> Bool {
        lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
    }
}

// MARK: - CustomStringConvertible

extension AppInfo: CustomStringConvertible {
    var description: String {
        let id = bundleIdentifier ?? "unknown"
        return "\(name) (\(id)) — \(path)"
    }
}
