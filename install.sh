#!/bin/bash
set -euo pipefail

# OpenAppCLI Installer
# Usage: curl -fsSL https://openapp.kvchub.com/install.sh | bash

REPO="hackercoderkarsten/OpenAppCLI"
BINARY_NAME="openapp"
INSTALL_DIR="/usr/local/bin"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()  { echo -e "${CYAN}${BOLD}==>${RESET} ${BOLD}$1${RESET}"; }
success() { echo -e "${GREEN}${BOLD}==>${RESET} ${BOLD}$1${RESET}"; }
error() { echo -e "${RED}${BOLD}Error:${RESET} $1" >&2; exit 1; }

# Check macOS
if [ "$(uname -s)" != "Darwin" ]; then
    error "OpenAppCLI only supports macOS."
fi

# Check architecture
ARCH="$(uname -m)"
if [ "$ARCH" != "arm64" ] && [ "$ARCH" != "x86_64" ]; then
    error "Unsupported architecture: $ARCH"
fi

info "Installing OpenAppCLI..."

# Get latest release URL from GitHub
LATEST_URL="https://github.com/${REPO}/releases/latest/download/openapp-macos.tar.gz"

# Create temp directory
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# Download
info "Downloading latest release..."
if ! curl -fsSL "$LATEST_URL" -o "$TMP_DIR/openapp-macos.tar.gz"; then
    error "Download failed. Check https://github.com/${REPO}/releases for available releases."
fi

# Extract
info "Extracting..."
tar -xzf "$TMP_DIR/openapp-macos.tar.gz" -C "$TMP_DIR"

# Install
if [ -w "$INSTALL_DIR" ]; then
    mv "$TMP_DIR/$BINARY_NAME" "$INSTALL_DIR/$BINARY_NAME"
    chmod +x "$INSTALL_DIR/$BINARY_NAME"
else
    info "Requesting permission to install to $INSTALL_DIR..."
    sudo mv "$TMP_DIR/$BINARY_NAME" "$INSTALL_DIR/$BINARY_NAME"
    sudo chmod +x "$INSTALL_DIR/$BINARY_NAME"
fi

# Verify
if command -v "$BINARY_NAME" &> /dev/null; then
    success "OpenAppCLI installed successfully!"
    echo ""
    "$BINARY_NAME" --version
    echo ""
    echo -e "  Run ${CYAN}openapp help${RESET} to get started."
else
    error "Installation completed but '$BINARY_NAME' not found in PATH. Add $INSTALL_DIR to your PATH."
fi
