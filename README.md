# MacMp4ScreenRec

Automatically convert macOS screen recordings and other video files in the background with `ffmpeg`.

The current defaults stay the same:

- Watch `~/Desktop`
- Only convert files named `Screen Recording*`
- Scan for `.mov`
- Write `.mp4`
- Use `-c:v copy -c:a copy`
- Delete the original immediately after a successful conversion

## Install

### Homebrew

```bash
brew tap arch1904/mac-mp4-screen-rec
brew install mac-mp4-screen-rec
```

### Manual

```bash
brew install ffmpeg
git clone https://github.com/arch1904/MacMp4ScreenRec.git
cd MacMp4ScreenRec
./install.sh
```

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/arch1904/MacMp4ScreenRec/main/install.sh -o /tmp/install-mac-mp4-screen-rec.sh && \
curl -fsSL https://raw.githubusercontent.com/arch1904/MacMp4ScreenRec/main/mac-mp4-screen-rec -o /tmp/mac-mp4-screen-rec && \
mkdir -p /tmp/docs/man && \
curl -fsSL https://raw.githubusercontent.com/arch1904/MacMp4ScreenRec/main/docs/man/mac-mp4-screen-rec.1 -o /tmp/docs/man/mac-mp4-screen-rec.1 && \
chmod +x /tmp/mac-mp4-screen-rec /tmp/install-mac-mp4-screen-rec.sh && \
cd /tmp && ./install-mac-mp4-screen-rec.sh
```

## Usage

```bash
mac-mp4-screen-rec add ~/Desktop
mac-mp4-screen-rec add ~/Documents/Recordings
mac-mp4-screen-rec remove ~/Documents/Recordings
mac-mp4-screen-rec list
mac-mp4-screen-rec start
mac-mp4-screen-rec stop
mac-mp4-screen-rec status
mac-mp4-screen-rec convert
```

## Configure Conversion

Switch from the default "screen recordings only" behavior to all matching files:

```bash
mac-mp4-screen-rec config --all-files
```

Go back to macOS-style screen recordings only:

```bash
mac-mp4-screen-rec config --only-recordings
```

Keep successful originals for 7 days before they are deleted:

```bash
mac-mp4-screen-rec config --keep-original-days 7
```

Scan more than `.mov` and still write `.mp4`:

```bash
mac-mp4-screen-rec config --all-files --input-extensions mov,mkv,avi --output-extension mp4
```

Re-encode instead of stream-copying:

```bash
mac-mp4-screen-rec config --video-codec libx264 --audio-codec aac
```

Show the active configuration:

```bash
mac-mp4-screen-rec config
```

## Config File

The config lives at `~/.config/mac-mp4-screen-rec/config`:

```yaml
# Watch paths (one per line, after "paths:" line)
paths:
~/Desktop

# Selection mode: "recordings-only" or "all-files"
mode: recordings-only

# Keep successfully converted originals for N days before deletion (0 = delete immediately)
keep_original_days: 0

# Comma-separated input file extensions to scan for
input_extensions: mov

# Output container extension
output_extension: mp4

# ffmpeg codec settings
video_codec: copy
audio_codec: copy
```

## How It Works

1. A macOS `launchd` agent watches your configured directories with `WatchPaths`.
2. The same agent also runs once an hour with `StartInterval`, so delayed original cleanup does not depend on fresh file activity.
3. Each run scans the watched directory roots for files whose extension matches `input_extensions`.
4. In `recordings-only` mode, only files named `Screen Recording*` are converted.
5. `ffmpeg` writes a sibling output file using the configured output extension and codecs.
6. On success, the original is either deleted immediately or tracked for later deletion after `keep_original_days`.

## Viability Notes

- Input type support is intentionally delegated to `ffmpeg`. If `ffmpeg` can decode the source and mux the requested output with the chosen codecs, this tool can drive it.
- Output codec support is also delegated to `ffmpeg`. The script stores codec names verbatim and passes them through as `-c:v` and `-c:a`.
- Same-extension transcodes are intentionally skipped. This tool always writes a sibling output file, and in-place rewrites would need a separate naming and retention strategy.
- Delayed original deletion is approximate, not to-the-second. With the current `launchd` schedule it happens on the next file event or within about one hour of expiry.

## Why MOV → MP4 by Default?

macOS screen recordings are commonly H.264/AAC inside a MOV container. Remuxing them to MP4 with `copy` preserves the streams bit-for-bit while improving compatibility for upload, sharing, and embedding.

## Man Page

After install:

```bash
man mac-mp4-screen-rec
```

For unreleased changes from `main`:

```bash
brew reinstall --HEAD mac-mp4-screen-rec
```

## Uninstall

```bash
mac-mp4-screen-rec stop
./uninstall.sh
```

Or with Homebrew:

```bash
brew uninstall mac-mp4-screen-rec
brew untap arch1904/mac-mp4-screen-rec
```

## Requirements

- macOS 12+
- [ffmpeg](https://ffmpeg.org/)

## License

MIT
