#!/bin/bash
set -euo pipefail

INSTALL_DIR="/usr/local/bin"
MAN_DIR="/usr/local/share/man/man1"
SCRIPT_NAME="mac-mp4-screen-rec"
SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="${SOURCE_DIR}/${SCRIPT_NAME}"
MAN_SOURCE="${SOURCE_DIR}/docs/man/${SCRIPT_NAME}.1"

echo "Installing mac-mp4-screen-rec..."

if ! command -v ffmpeg &>/dev/null; then
    echo ""
    echo "ffmpeg is required but not installed."
    echo "Install it with: brew install ffmpeg"
    echo ""
    exit 1
fi

if [ -w "$INSTALL_DIR" ]; then
    cp "$SOURCE" "${INSTALL_DIR}/${SCRIPT_NAME}"
    chmod +x "${INSTALL_DIR}/${SCRIPT_NAME}"
else
    echo "Need sudo to install to ${INSTALL_DIR}"
    sudo cp "$SOURCE" "${INSTALL_DIR}/${SCRIPT_NAME}"
    sudo chmod +x "${INSTALL_DIR}/${SCRIPT_NAME}"
fi

if [ -f "$MAN_SOURCE" ]; then
    if [ -w "$MAN_DIR" ] || { [ -d "$MAN_DIR" ] && [ -w "$MAN_DIR" ]; }; then
        mkdir -p "$MAN_DIR"
        cp "$MAN_SOURCE" "${MAN_DIR}/${SCRIPT_NAME}.1"
    else
        echo "Need sudo to install the manpage to ${MAN_DIR}"
        sudo mkdir -p "$MAN_DIR"
        sudo cp "$MAN_SOURCE" "${MAN_DIR}/${SCRIPT_NAME}.1"
    fi
fi

"${INSTALL_DIR}/${SCRIPT_NAME}" list >/dev/null 2>&1
"${INSTALL_DIR}/${SCRIPT_NAME}" start

echo ""
echo "Installed successfully!"
echo ""
echo "  Watching:           ~/Desktop (default)"
echo "  Selection mode:     recordings-only"
echo "  Keep originals:     0 days"
echo "  Input extensions:   mov"
echo "  Output extension:   mp4"
echo "  Video/audio codec:  copy/copy"
echo "  Codec overrides:    none"
echo ""
echo "Customize with:"
echo "  mac-mp4-screen-rec add <path>"
echo "  mac-mp4-screen-rec config --all-files --input-extensions mov,mkv"
echo "  mac-mp4-screen-rec config --video-codec libx264 --audio-codec aac"
echo "  mac-mp4-screen-rec config --map-video-codec hevc=libx264"
echo "  mac-mp4-screen-rec config --map-audio-codec pcm_s16le=aac"
echo "  mac-mp4-screen-rec config --keep-original-days 7"
echo "  man mac-mp4-screen-rec"
