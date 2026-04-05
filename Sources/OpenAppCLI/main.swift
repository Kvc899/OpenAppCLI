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
}

