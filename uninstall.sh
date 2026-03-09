#!/bin/bash
set -euo pipefail

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="mac-mp4-screen-rec"
PLIST_NAME="com.mac-mp4-screen-rec.agent"
PLIST_PATH="${HOME}/Library/LaunchAgents/${PLIST_NAME}.plist"
CONFIG_DIR="${HOME}/.config/mac-mp4-screen-rec"

echo "Uninstalling mac-mp4-screen-rec..."

# Stop service
if launchctl list "$PLIST_NAME" &>/dev/null; then
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
    echo "  Stopped service."
fi

# Remove plist
if [ -f "$PLIST_PATH" ]; then
    rm "$PLIST_PATH"
    echo "  Removed launchd plist."
fi

# Remove binary
if [ -f "${INSTALL_DIR}/${SCRIPT_NAME}" ]; then
    if [ -w "$INSTALL_DIR" ]; then
        rm "${INSTALL_DIR}/${SCRIPT_NAME}"
    else
        sudo rm "${INSTALL_DIR}/${SCRIPT_NAME}"
    fi
    echo "  Removed binary."
fi

# Ask about config
if [ -d "$CONFIG_DIR" ]; then
    read -rp "  Remove config (~/.config/mac-mp4-screen-rec)? [y/N] " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        rm -rf "$CONFIG_DIR"
        echo "  Removed config."
    else
        echo "  Kept config."
    fi
fi

echo ""
echo "Uninstalled successfully."
