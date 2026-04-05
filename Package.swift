// swift-tools-version: 5.7
//
//  Package.swift
//  OpenAppCLI
//
//  Swift Package Manager manifest for building and testing the CLI
//  as a standalone Swift package (outside of Xcode project).
//

import PackageDescription

let package = Package(
    name: "OpenAppCLI",
    platforms: [
        .macOS(.v12)
    ],
    targets: [
        .executableTarget(
            name: "OpenAppCLI",
            path: "Sources/OpenAppCLI",
            linkerSettings: [
                .linkedFramework("AppKit")
            ]
        ),
        .testTarget(
            name: "OpenAppCLITests",
            dependencies: ["OpenAppCLI"],
            path: "Tests/OpenAppCLITests"
        ),
    ]
)
