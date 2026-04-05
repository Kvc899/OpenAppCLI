//
//  ArgumentParserTests.swift
//  OpenAppCLITests
//
//  Unit tests for CLI argument parsing.
//

import Testing
@testable import OpenAppCLI

@Suite("ArgumentParser Tests")
struct ArgumentParserTests {

    // MARK: - Help

    @Test("No arguments returns help")
    func noArguments() {
        let cmd = ArgumentParser.parse([])
        guard case .help = cmd else {
            Issue.record("Expected .help, got \(cmd)")
            return
        }
    }

    @Test("'help' argument returns help command")
    func helpArgument() {
        for arg in ["help", "--help", "-h"] {
            let cmd = ArgumentParser.parse([arg])
            guard case .help = cmd else {
                Issue.record("Expected .help for '\(arg)', got \(cmd)")
                return
            }
        }
    }

    // MARK: - Version

    @Test("'--version' returns version command")
    func versionArgument() {
        for arg in ["--version", "-v"] {
            let cmd = ArgumentParser.parse([arg])
            guard case .version = cmd else {
                Issue.record("Expected .version for '\(arg)', got \(cmd)")
                return
            }
        }
    }

    // MARK: - List

    @Test("'list' and 'ls' return list command")
    func listArgument() {
        for arg in ["list", "ls"] {
            let cmd = ArgumentParser.parse([arg])
            guard case .list = cmd else {
                Issue.record("Expected .list for '\(arg)', got \(cmd)")
                return
            }
        }
    }

    // MARK: - Search

    @Test("'search <query>' returns search command with query")
    func searchArgument() {
        let cmd = ArgumentParser.parse(["search", "xcode"])
        guard case .search(let query) = cmd else {
            Issue.record("Expected .search, got \(cmd)")
            return
        }
        #expect(query == "xcode")
    }

    @Test("'search' with no query returns help")
    func searchNoQuery() {
        let cmd = ArgumentParser.parse(["search"])
        guard case .help = cmd else {
            Issue.record("Expected .help for search with no query, got \(cmd)")
            return
        }
    }

    @Test("'find' alias works for search")
    func findAlias() {
        let cmd = ArgumentParser.parse(["find", "safari"])
        guard case .search(let query) = cmd else {
            Issue.record("Expected .search, got \(cmd)")
            return
        }
        #expect(query == "safari")
    }

    // MARK: - Launch

    @Test("Unrecognized argument treated as launch query")
    func launchArgument() {
        let cmd = ArgumentParser.parse(["Safari"])
        guard case .launch(let query) = cmd else {
            Issue.record("Expected .launch, got \(cmd)")
            return
        }
        #expect(query == "Safari")
    }

    @Test("Multi-word app name joined as launch query")
    func multiWordLaunch() {
        let cmd = ArgumentParser.parse(["Google", "Chrome"])
        guard case .launch(let query) = cmd else {
            Issue.record("Expected .launch, got \(cmd)")
            return
        }
        #expect(query == "Google Chrome")
    }
}
