#!/bin/bash
set -euo pipefail

# OpenAppCLI Installer
# Usage: curl -fsSL https://openapp.kvchub.com/install.sh | bash
#   or:  curl -fsSL https://raw.githubusercontent.com/Kvc899/OpenAppCLI/main/install.sh | bash

REPO="Kvc899/OpenAppCLI"
BINARY_NAME="openapp"
INSTALL_DIR="/usr/local/bin"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

info()    { echo -e "${CYAN}${BOLD}==>${RESET} ${BOLD}$1${RESET}"; }
success() { echo -e "${GREEN}${BOLD}==>${RESET} ${BOLD}$1${RESET}"; }
warn()    { echo -e "${YELLOW}${BOLD}==>${RESET} ${BOLD}$1${RESET}"; }
error()   { echo -e "${RED}${BOLD}Error:${RESET} $1" >&2; exit 1; }

echo ""
echo -e "${CYAN}${BOLD}  ╔═══════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}  ║       OpenAppCLI Installer     ║${RESET}"
echo -e "${CYAN}${BOLD}  ╚═══════════════════════════════╝${RESET}"
echo ""

# Check macOS
if [ "$(uname -s)" != "Darwin" ]; then
    error "OpenAppCLI only supports macOS."
fi

# Check architecture
ARCH="$(uname -m)"
if [ "$ARCH" != "arm64" ] && [ "$ARCH" != "x86_64" ]; then
    error "Unsupported architecture: $ARCH"
fi

info "Detecting system..."
echo -e "  ${DIM}OS:   macOS $(sw_vers -productVersion)${RESET}"
echo -e "  ${DIM}Arch: $ARCH${RESET}"
echo ""

# Try downloading a pre-built release first
LATEST_URL="https://github.com/${REPO}/releases/latest/download/openapp-macos.tar.gz"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

BUILT_FROM_SOURCE=false

info "Downloading latest release..."
if curl -fsSL "$LATEST_URL" -o "$TMP_DIR/openapp-macos.tar.gz" 2>/dev/null; then
    info "Extracting..."
    tar -xzf "$TMP_DIR/openapp-macos.tar.gz" -C "$TMP_DIR"
else
    # No release found — build from source
    warn "No pre-built release found. Building from source..."
    echo ""

    # Check for Swift
    if ! command -v swift &> /dev/null; then
        error "Swift is required to build from source. Install Xcode or Xcode Command Line Tools."
    fi

    info "Cloning repository..."
    git clone --depth 1 "https://github.com/${REPO}.git" "$TMP_DIR/repo" 2>/dev/null || \
        error "Failed to clone repository."

    info "Building (this may take a minute)..."
    cd "$TMP_DIR/repo"
    swift build -c release 2>&1 | tail -1 || error "Build failed."

    cp ".build/release/OpenAppCLI" "$TMP_DIR/$BINARY_NAME"
    BUILT_FROM_SOURCE=true
fi

# Install
echo ""
if [ -w "$INSTALL_DIR" ]; then
    mv "$TMP_DIR/$BINARY_NAME" "$INSTALL_DIR/$BINARY_NAME"
    chmod +x "$INSTALL_DIR/$BINARY_NAME"
else
    info "Installing to $INSTALL_DIR (requires sudo)..."
    sudo mv "$TMP_DIR/$BINARY_NAME" "$INSTALL_DIR/$BINARY_NAME"
    sudo chmod +x "$INSTALL_DIR/$BINARY_NAME"
fi

# Verify
echo ""
if command -v "$BINARY_NAME" &> /dev/null; then
    echo -e "${GREEN}${BOLD}  ✓ OpenAppCLI installed successfully!${RESET}"
    echo ""
    echo -e "  ${DIM}Version:  $("$BINARY_NAME" --version 2>/dev/null || echo "unknown")${RESET}"
    echo -e "  ${DIM}Location: $(which $BINARY_NAME)${RESET}"
    if [ "$BUILT_FROM_SOURCE" = true ]; then
        echo -e "  ${DIM}Method:   Built from source${RESET}"
    else
        echo -e "  ${DIM}Method:   Pre-built binary${RESET}"
    fi
    echo ""
    echo -e "  Get started: ${CYAN}openapp help${RESET}"
    echo ""
else
    error "Installation completed but '$BINARY_NAME' not found in PATH. Add $INSTALL_DIR to your PATH."
fi
