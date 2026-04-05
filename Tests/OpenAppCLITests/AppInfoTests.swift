//
//  AppInfoTests.swift
//  OpenAppCLITests
//
//  Unit tests for the AppInfo model.
//

import Testing
@testable import OpenAppCLI

@Suite("AppInfo Tests")
struct AppInfoTests {

    // MARK: - Initialization

    @Test("AppInfo stores all properties correctly")
    func initializesWithAllProperties() {
        let app = AppInfo(
            name: "Safari",
            bundleIdentifier: "com.apple.Safari",
            path: "/Applications/Safari.app"
        )

        #expect(app.name == "Safari")
        #expect(app.bundleIdentifier == "com.apple.Safari")
        #expect(app.path == "/Applications/Safari.app")
    }

    @Test("AppInfo allows nil bundle identifier")
    func allowsNilBundleIdentifier() {
        let app = AppInfo(name: "MyApp", bundleIdentifier: nil, path: "/Applications/MyApp.app")
        #expect(app.bundleIdentifier == nil)
    }

    // MARK: - Equatable

    @Test("Two AppInfos with same properties are equal")
    func equality() {
        let a = AppInfo(name: "Xcode", bundleIdentifier: "com.apple.dt.Xcode", path: "/Applications/Xcode.app")
        let b = AppInfo(name: "Xcode", bundleIdentifier: "com.apple.dt.Xcode", path: "/Applications/Xcode.app")
        #expect(a == b)
    }

    @Test("Two AppInfos with different names are not equal")
    func inequality() {
        let a = AppInfo(name: "Xcode", bundleIdentifier: "com.apple.dt.Xcode", path: "/Applications/Xcode.app")
        let b = AppInfo(name: "Safari", bundleIdentifier: "com.apple.Safari", path: "/Applications/Safari.app")
        #expect(a != b)
    }

    // MARK: - Comparable (alphabetical sorting)

    @Test("AppInfos sort alphabetically by name")
    func sorting() {
        let apps = [
            AppInfo(name: "Xcode", bundleIdentifier: nil, path: "/Applications/Xcode.app"),
            AppInfo(name: "Activity Monitor", bundleIdentifier: nil, path: "/Applications/Activity Monitor.app"),
            AppInfo(name: "Safari", bundleIdentifier: nil, path: "/Applications/Safari.app"),
        ]
        let sorted = apps.sorted()
        #expect(sorted.map(\.name) == ["Activity Monitor", "Safari", "Xcode"])
    }

    // MARK: - Description

    @Test("Description includes name, bundle ID, and path")
    func descriptionFormat() {
        let app = AppInfo(name: "Safari", bundleIdentifier: "com.apple.Safari", path: "/Applications/Safari.app")
        let desc = app.description
        #expect(desc.contains("Safari"))
        #expect(desc.contains("com.apple.Safari"))
        #expect(desc.contains("/Applications/Safari.app"))
    }

    @Test("Description shows 'unknown' when bundle ID is nil")
    func descriptionWithNilBundleID() {
        let app = AppInfo(name: "MyApp", bundleIdentifier: nil, path: "/Applications/MyApp.app")
        #expect(app.description.contains("unknown"))
    }
}
