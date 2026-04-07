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

```bash
curl -fsSL https://openapp.kvchub.com/install.sh | bash
```

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


## License

MIT — see [LICENSE](LICENSE) for details.
