# MacMp4ScreenRec

Automatically convert macOS screen recordings from MOV to MP4 — losslessly, in the background.

macOS saves screen recordings as `.mov` files. This tool watches your directories and instantly remuxes them to `.mp4` with zero quality loss using ffmpeg. The original `.mov` is deleted after conversion.

## Install

### Homebrew (recommended)

```bash
brew tap arch1904/mac-mp4-screen-rec
brew install mac-mp4-screen-rec
```

### Manual

```bash
brew install ffmpeg  # required dependency
git clone https://github.com/arch1904/MacMp4ScreenRec.git
cd MacMp4ScreenRec
./install.sh
```

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/arch1904/MacMp4ScreenRec/main/install.sh -o /tmp/install-mac-mp4-screen-rec.sh && curl -fsSL https://raw.githubusercontent.com/arch1904/MacMp4ScreenRec/main/mac-mp4-screen-rec -o /tmp/mac-mp4-screen-rec && chmod +x /tmp/mac-mp4-screen-rec /tmp/install-mac-mp4-screen-rec.sh && cd /tmp && ./install-mac-mp4-screen-rec.sh
```

## Usage

```bash
# Watch a directory for screen recordings
mac-mp4-screen-rec add ~/Desktop

# Watch another directory
mac-mp4-screen-rec add ~/Documents/Recordings

# Remove a watched directory
mac-mp4-screen-rec remove ~/Documents/Recordings

# Show current config
mac-mp4-screen-rec list

# Start/stop the background service
mac-mp4-screen-rec start
mac-mp4-screen-rec stop

# Check if service is running
mac-mp4-screen-rec status
```

### Convert all MOV files (not just screen recordings)

By default, only files named `Screen Recording*.mov` (macOS default naming) are converted. To convert **all** `.mov` files in watched directories:

```bash
mac-mp4-screen-rec config --all-movs
```

To switch back:

```bash
mac-mp4-screen-rec config --only-recordings
```

## How it works

1. A lightweight macOS `launchd` service watches your configured directories
2. When a new `.mov` file appears, the service triggers a conversion
3. `ffmpeg` remuxes the file to `.mp4` with `-c copy` (no re-encoding, instant, lossless)
4. The `-movflags +faststart` flag is applied for web-friendly streaming
5. The original `.mov` file is deleted after successful conversion

The service starts automatically on login and uses macOS native `WatchPaths` — no polling, minimal resource usage.

## Config

The config file lives at `~/.config/mac-mp4-screen-rec/config`:

```
# Watch paths (one per line, after "paths:" line)
paths:
~/Desktop

# Mode: "recordings-only" or "all-movs"
mode: recordings-only
```

You can edit this file directly or use the CLI commands.

## Why MOV → MP4?

macOS screen recordings use H.264 video with AAC audio. Both MOV and MP4 are containers based on the ISO Base Media File Format — the actual video/audio streams are identical. Remuxing just rewrites the container metadata, so:

- **Zero quality loss** — streams are copied bit-for-bit
- **Instant conversion** — no re-encoding needed
- **Better compatibility** — MP4 is more widely supported for sharing, uploading, and embedding

## Uninstall

```bash
mac-mp4-screen-rec stop
./uninstall.sh
```

Or if installed via Homebrew:

```bash
brew uninstall mac-mp4-screen-rec
brew untap arch1904/mac-mp4-screen-rec
```

## Requirements

- macOS 12+ (Monterey or later)
- [ffmpeg](https://ffmpeg.org/) (`brew install ffmpeg`)

## License

MIT
