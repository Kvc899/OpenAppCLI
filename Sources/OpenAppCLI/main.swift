//
//  main.swift
//  OpenApp CLI
//
//  Entry point for the OpenAppCLI command-line tool.
//  Parses arguments, dispatches to the appropriate command handler,
//  and exits with the correct status code.
//

import AppKit

// MARK: - Main

let arguments = Array(CommandLine.arguments.dropFirst())
let command = ArgumentParser.parse(arguments)

switch command {
case .launch(let query):
    let success = AppLauncher.launch(query: query)
    exit(success ? EXIT_SUCCESS : EXIT_FAILURE)

case .list:
    let apps = AppFinder.findAllApps()
    if apps.isEmpty {
        print("No applications found.".colored(.yellow))
    } else {
        print("\("Installed applications".bold(.cyan)) (\(String(apps.count).colored(.green))):\n")
        let maxNameLength = min(apps.map(\.name.count).max() ?? 0, 30)
        for app in apps {
            let paddedName = app.name.truncated(to: 30).padding(toLength: maxNameLength + 2, withPad: " ", startingAt: 0)
            let id = (app.bundleIdentifier ?? "—").truncated(to: 40)
            print("  \(paddedName.colored(.green)) \(id.dimmed)")
        }
    }

case .search(let query):
    let apps = AppFinder.findAllApps()
    let matches = apps.filter { $0.name.containsIgnoringCase(query) }
    if matches.isEmpty {
        print("No applications matching \"\(query.colored(.yellow))\".".colored(.red))
    } else {
        print("Found \(String(matches.count).bold(.green)) app(s) matching \"\(query.colored(.yellow))\":\n")
        for app in matches {
            let id = (app.bundleIdentifier ?? "unknown").dimmed
            print("  \(app.name.colored(.green)) \(id) \("—".dimmed) \(app.path.dimmed)")
        }
    }

case .help:
    print(ArgumentParser.helpText())

case .version:
    print("\("OpenAppCLI".bold(.cyan)) v\(ArgumentParser.version.colored(.green))")

case .update:
    print("\("▶".colored(.cyan)) Checking for updates...")
    let installScript = "https://raw.githubusercontent.com/Kvc899/OpenAppCLI/main/install.sh"
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/bin/bash")
    task.arguments = ["-c", "curl -fsSL \(installScript) | bash"]
    task.standardInput = FileHandle.standardInput
    try? task.run()
    task.waitUntilExit()
    exit(task.terminationStatus)

case .uninstall:
    print("\("▶".colored(.red)) Uninstalling OpenAppCLI...")
    let binaryPath = "/usr/local/bin/openapp"

    // Confirm
    print("")
    print("  This will remove \(binaryPath.colored(.yellow))")
    print("")
    print("  Continue? [y/N] ", terminator: "")
    guard let reply = readLine()?.trimmed.lowercased(), reply == "y" else {
        print("\n  Uninstall cancelled.".colored(.yellow))
        exit(EXIT_SUCCESS)
    }

    let rm = Process()
    rm.executableURL = URL(fileURLWithPath: "/usr/bin/sudo")
    rm.arguments = ["rm", "-f", binaryPath]
    try? rm.run()
    rm.waitUntilExit()

    if rm.terminationStatus == 0 {
        print("")
        print("  \("✓ OpenAppCLI uninstalled successfully.".bold(.green))")
        print("")
    } else {
        var stderr = FileHandle.standardError
        print("\("Error:".bold(.red)) Failed to remove \(binaryPath)", to: &stderr)
        exit(EXIT_FAILURE)
    }
}

