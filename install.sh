#!/bin/bash
set -euo pipefail

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="mac-mp4-screen-rec"
SOURCE="$(cd "$(dirname "$0")" && pwd)/${SCRIPT_NAME}"

echo "Installing mac-mp4-screen-rec..."

# Check for ffmpeg
if ! command -v ffmpeg &>/dev/null; then
    echo ""
    echo "ffmpeg is required but not installed."
    echo "Install it with: brew install ffmpeg"
    echo ""
    exit 1
fi

# Copy script to /usr/local/bin
if [ -w "$INSTALL_DIR" ]; then
    cp "$SOURCE" "${INSTALL_DIR}/${SCRIPT_NAME}"
    chmod +x "${INSTALL_DIR}/${SCRIPT_NAME}"
else
    echo "Need sudo to install to ${INSTALL_DIR}"
    sudo cp "$SOURCE" "${INSTALL_DIR}/${SCRIPT_NAME}"
    sudo chmod +x "${INSTALL_DIR}/${SCRIPT_NAME}"
fi

# Create default config if it doesn't exist
"${INSTALL_DIR}/${SCRIPT_NAME}" list >/dev/null 2>&1

# Start the service
"${INSTALL_DIR}/${SCRIPT_NAME}" start

echo ""
echo "Installed successfully!"
echo ""
echo "  Watching: ~/Desktop (default)"
echo "  Mode:     recordings-only"
echo ""
echo "Customize with:"
echo "  mac-mp4-screen-rec add <path>        # watch another directory"
echo "  mac-mp4-screen-rec config --all-movs  # convert all .mov files"
echo "  mac-mp4-screen-rec status             # check service status"
