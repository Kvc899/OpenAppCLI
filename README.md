# OpenAppCLI

A macOS command-line tool to launch applications from the terminal with fuzzy matching.

## Features

- **Launch apps by name** — Fuzzy matching finds the best match even with typos or partial names
- **List all installed apps** — See every application across `/Applications`, `/System/Applications`, and `~/Applications`
- **Search apps** — Filter the app list by keyword
- **Zero dependencies** — Built with pure Swift and AppKit, no third-party packages

## Requirements

- macOS 12.0 (Monterey) or later
- Swift 5.7+
- Xcode 14+ (for building)

## Installation

### Build from source

```bash
git clone https://github.com/youruser/OpenAppCLI.git
cd OpenAppCLI
swift build -c release
```

The binary will be at `.build/release/OpenAppCLI`. Copy it somewhere in your `$PATH`:

```bash
cp .build/release/OpenAppCLI /usr/local/bin/openapp
```

### Using the Xcode project

Open `OpenApp CLI.xcodeproj` in Xcode, build with **Cmd+B**, and archive for distribution.

## Usage

```
openapp <app-name>          Launch an application (fuzzy matching)
openapp list                List all installed applications
openapp search <query>      Search for applications by name
openapp help                Show help message
openapp --version           Show version
```

### Examples

```bash
# Launch Safari
openapp safari

# Launch Google Chrome (multi-word names)
openapp "Google Chrome"

# Fuzzy match — launches "Xcode" even with a partial name
openapp xco

# List every installed app
openapp list

# Search for apps containing "code"
openapp search code
```

### Command Aliases

| Command  | Alias |
| -------- | ----- |
| `list`   | `ls`  |
| `search` | `find`|

## Project Structure

```
OpenApp CLI/
├── OpenApp CLI/
│   ├── main.swift                  # Entry point
│   ├── App/
│   │   ├── AppFinder.swift         # Discovers installed .app bundles
│   │   └── AppLauncher.swift       # Launches apps with fuzzy matching
│   ├── CLI/
│   │   └── ArgumentParser.swift    # Parses CLI commands
│   ├── Extensions/
│   │   └── String+Extensions.swift # String helpers
│   └── Models/
│       └── AppInfo.swift           # App data model
├── Tests/
│   └── OpenAppCLITests/
│       ├── AppInfoTests.swift
│       ├── ArgumentParserTests.swift
│       └── StringExtensionTests.swift
├── Package.swift
├── README.md
├── LICENSE
└── CONTRIBUTING.md
```

## Running Tests

```bash
swift test
```

Or in Xcode: **Cmd+U**.

## License

MIT — see [LICENSE](LICENSE) for details.
