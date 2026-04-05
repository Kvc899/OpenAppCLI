# Contributing to OpenAppCLI

Thanks for your interest in contributing! Here's how to get started.

## Development Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/youruser/OpenAppCLI.git
   cd OpenAppCLI
   ```

2. **Open in Xcode** (recommended) or use the Swift CLI

   ```bash
   open "OpenApp CLI.xcodeproj"
   # or
   swift build
   ```

3. **Run tests**

   ```bash
   swift test
   ```

## Code Style

- Follow [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)
- Use 4-space indentation
- Add doc comments (`///`) to all public types and methods
- Keep files focused — one primary type per file
- Use `// MARK: -` sections to organize code within a file

## Pull Request Process

1. **Fork** the repository and create a feature branch from `main`:

   ```bash
   git checkout -b feature/my-feature
   ```

2. **Make your changes** and ensure:
   - All existing tests pass (`swift test`)
   - New functionality includes tests
   - Code compiles without warnings

3. **Commit** with clear, descriptive messages:

   ```
   Add fuzzy matching threshold configuration
   ```

4. **Push** your branch and open a Pull Request against `main`.

5. **Respond to review feedback** — maintainers may request changes.

## Reporting Issues

- Use GitHub Issues for bug reports and feature requests
- Include your macOS version, Swift version, and steps to reproduce

## Architecture Notes

| Directory     | Purpose                                    |
| ------------- | ------------------------------------------ |
| `App/`        | Core logic — finding and launching apps    |
| `CLI/`        | Argument parsing and command dispatch      |
| `Models/`     | Data types (`AppInfo`)                     |
| `Extensions/` | Swift standard library extensions          |
| `Tests/`      | Unit tests using the Swift Testing framework |
