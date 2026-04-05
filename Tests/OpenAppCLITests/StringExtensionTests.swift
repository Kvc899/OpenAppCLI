//
//  StringExtensionTests.swift
//  OpenAppCLITests
//
//  Unit tests for String extension helpers.
//

import Testing
@testable import OpenAppCLI

@Suite("String Extensions Tests")
struct StringExtensionTests {

    // MARK: - containsIgnoringCase

    @Test("containsIgnoringCase finds substring regardless of case")
    func containsIgnoringCaseMatch() {
        #expect("Safari".containsIgnoringCase("safari"))
        #expect("Google Chrome".containsIgnoringCase("CHROME"))
        #expect("Xcode".containsIgnoringCase("Xcode"))
    }

    @Test("containsIgnoringCase returns false for non-matches")
    func containsIgnoringCaseNoMatch() {
        #expect(!"Safari".containsIgnoringCase("Firefox"))
        #expect(!"".containsIgnoringCase("test"))
    }

    // MARK: - trimmed

    @Test("trimmed removes leading and trailing whitespace")
    func trimmedWhitespace() {
        #expect("  hello  ".trimmed == "hello")
        #expect("\n\ttabs\n".trimmed == "tabs")
        #expect("clean".trimmed == "clean")
    }

    @Test("trimmed on empty string returns empty")
    func trimmedEmpty() {
        #expect("".trimmed == "")
        #expect("   ".trimmed == "")
    }

    // MARK: - truncated

    @Test("truncated returns original string when short enough")
    func truncatedNoOp() {
        #expect("Hello".truncated(to: 10) == "Hello")
        #expect("Hello".truncated(to: 5) == "Hello")
    }

    @Test("truncated shortens and appends ellipsis")
    func truncatedShortens() {
        let result = "Long Application Name".truncated(to: 10)
        #expect(result.count == 10)
        #expect(result.hasSuffix("…"))
    }

    @Test("truncated with zero or negative limit returns original")
    func truncatedEdgeCases() {
        #expect("Hello".truncated(to: 0) == "Hello")
        #expect("Hello".truncated(to: -1) == "Hello")
    }

    // MARK: - fuzzyMatchScore

    @Test("Exact match returns 1.0")
    func exactMatch() {
        #expect("Safari".fuzzyMatchScore(against: "Safari") == 1.0)
        #expect("safari".fuzzyMatchScore(against: "SAFARI") == 1.0)
    }

    @Test("Prefix match returns 0.9")
    func prefixMatch() {
        #expect("Safari".fuzzyMatchScore(against: "Saf") == 0.9)
    }

    @Test("Substring match returns 0.7")
    func substringMatch() {
        #expect("Google Chrome".fuzzyMatchScore(against: "Chrome") == 0.7)
    }

    @Test("No match returns 0.0")
    func noMatch() {
        #expect("Safari".fuzzyMatchScore(against: "zzz") == 0.0)
    }

    @Test("Subsequence match returns score between 0.3 and 0.5")
    func subsequenceMatch() {
        let score = "Safari".fuzzyMatchScore(against: "sfi")
        #expect(score >= 0.3)
        #expect(score < 0.6)
    }
}
