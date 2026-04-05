//
//  ArgumentParser.swift
//  OpenApp CLI
//
//  Parses command-line arguments into a structured `Command` enum.
//  Supports: launch, list, search, help, and version commands.
//

import Foundation

/// Represents a parsed CLI command.
enum Command {
    /// Launch an app by name: `openapp <name>`
    case launch(query: String)

    /// List all installed applications: `openapp list`
    case list

    /// Search for apps matching a query: `openapp search <query>`
    case search(query: String)

    /// Display help text: `openapp help` or `openapp --help`
    case help

    /// Display version: `openapp --version`
    case version
}

/// Parses raw command-line arguments into a `Command`.
enum ArgumentParser {

    /// The current version of OpenAppCLI.
    static let version = "1.0.0"

    /// Parses `CommandLine.arguments` (excluding the executable name) into a `Command`.
    ///
    /// - Parameter arguments: The arguments to parse (typically `Array(CommandLine.arguments.dropFirst())`).
    /// - Returns: The parsed `Command`.
    static func parse(_ arguments: [String]) -> Command {
        guard let first = arguments.first?.trimmed, !first.isEmpty else {
            return .help
        }

        switch first.lowercased() {
        case "list", "ls":
            return .list

        case "search", "find":
            let query = arguments.dropFirst().joined(separator: " ").trimmed
            if query.isEmpty {
                return .help
            }
            return .search(query: query)

        case "help", "--help", "-h":
            return .help

        case "--version", "-v":
            return .version

        default:
            // Everything else is treated as a launch query
            let query = arguments.joined(separator: " ").trimmed
            return .launch(query: query)
        }
    }

    // MARK: - Help Text

    /// Returns the formatted help / usage text.
    static func helpText() -> String {
        let title = "OpenAppCLI".bold(.cyan) + " v\(version)".colored(.dim) + " — Launch macOS apps from the terminal"
        let usage = "USAGE:".bold(.yellow)
        let examples = "EXAMPLES:".bold(.yellow)
        let aliases = "ALIASES:".bold(.yellow)

        return """
        \(title)

        \(usage)
          \("openapp".colored(.green)) <app-name>          Launch an application (fuzzy matching)
          \("openapp".colored(.green)) list                List all installed applications
          \("openapp".colored(.green)) search <query>      Search for applications by name
          \("openapp".colored(.green)) help                Show this help message
          \("openapp".colored(.green)) --version           Show version

        \(examples)
          \("openapp safari".colored(.cyan))              Launch Safari
          \("openapp \"Google Chrome\"".colored(.cyan))     Launch Google Chrome
          \("openapp search xcode".colored(.cyan))        Search for apps containing "xcode"
          \("openapp list".colored(.cyan))                List every installed app

        \(aliases)
          list → ls      search → find
        """
    }
}
