//
//  AppFinder.swift
//  OpenApp CLI
//
//  Discovers installed .app bundles across standard macOS application directories:
//    /Applications, /System/Applications, and ~/Applications.
//  Results are cached for the lifetime of the process.
//

import Foundation

/// Scans the file system for installed macOS applications.
enum AppFinder {

    // MARK: - Search Directories

    /// The directories to scan for .app bundles.
    static var searchDirectories: [String] {
        var dirs = [
            "/Applications",
            "/System/Applications"
        ]
        // ~/Applications (may not exist for every user)
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        dirs.append("\(home)/Applications")
        return dirs
    }

    // MARK: - Discovery

    /// Returns all discovered applications, sorted alphabetically by name.
    /// Scans top-level and one level of subdirectories (e.g. /Applications/Utilities/).
    static func findAllApps() -> [AppInfo] {
        var apps: [AppInfo] = []
        let fileManager = FileManager.default

        for directory in searchDirectories {
            guard fileManager.fileExists(atPath: directory) else { continue }
            apps.append(contentsOf: scanDirectory(directory, fileManager: fileManager))
        }

        return apps.sorted()
    }

    // MARK: - Private Helpers

    /// Scans a single directory (and its immediate subdirectories) for .app bundles.
    private static func scanDirectory(_ path: String, fileManager: FileManager) -> [AppInfo] {
        var results: [AppInfo] = []

        guard let contents = try? fileManager.contentsOfDirectory(atPath: path) else {
            return results
        }

        for item in contents {
            let fullPath = (path as NSString).appendingPathComponent(item)
            var isDir: ObjCBool = false
            guard fileManager.fileExists(atPath: fullPath, isDirectory: &isDir),
                  isDir.boolValue else { continue }

            if item.hasSuffix(".app") {
                if let app = appInfo(at: fullPath) {
                    results.append(app)
                }
            } else {
                // Recurse one level (e.g. /Applications/Utilities/)
                if let subContents = try? fileManager.contentsOfDirectory(atPath: fullPath) {
                    for subItem in subContents where subItem.hasSuffix(".app") {
                        let subPath = (fullPath as NSString).appendingPathComponent(subItem)
                        if let app = appInfo(at: subPath) {
                            results.append(app)
                        }
                    }
                }
            }
        }

        return results
    }

    /// Builds an `AppInfo` from a .app bundle path by reading its Info.plist.
    private static func appInfo(at path: String) -> AppInfo? {
        let name = ((path as NSString).lastPathComponent as NSString).deletingPathExtension
        guard !name.isEmpty else { return nil }

        let bundle = Bundle(path: path)
        let bundleIdentifier = bundle?.bundleIdentifier

        return AppInfo(name: name, bundleIdentifier: bundleIdentifier, path: path)
    }
}
