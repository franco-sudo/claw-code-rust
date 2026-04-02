#!/bin/bash

# Installation script for Claw RS
# This will:
# 1. Build the release binary
# 2. Make the 'claw' launcher available globally

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔨 Building Claw RS (release mode)..."
cd "$SCRIPT_DIR"
cargo build --release

echo ""
echo "📦 Installing claw launcher..."

# Create a symlink in /usr/local/bin (requires sudo)
INSTALL_DIR="/usr/local/bin"
LAUNCHER_NAME="claw"

if [ -w "$INSTALL_DIR" ]; then
    # Already have write permission
    ln -sf "$SCRIPT_DIR/claw" "$INSTALL_DIR/$LAUNCHER_NAME"
    chmod +x "$INSTALL_DIR/$LAUNCHER_NAME"
    echo "✅ Installed to $INSTALL_DIR/$LAUNCHER_NAME"
else
    # Need sudo
    echo "🔐 Need sudo privileges to install to $INSTALL_DIR"
    sudo ln -sf "$SCRIPT_DIR/claw" "$INSTALL_DIR/$LAUNCHER_NAME"
    sudo chmod +x "$INSTALL_DIR/$LAUNCHER_NAME"
    echo "✅ Installed to $INSTALL_DIR/$LAUNCHER_NAME (with sudo)"
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "Usage:"
echo "  claw              # Start interactive chat with GLM-4"
echo "  claw -q 'hello'   # Single query mode"
echo ""
echo "First time setup:"
echo "  export ZHIPU_API_KEY='your_api_key_here'"
echo "  claw"
echo ""
echo "The API key will be auto-saved after first use."
echo "Config file location: ~/.claw-code-rust/config.json"
