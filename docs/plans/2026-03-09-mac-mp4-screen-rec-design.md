# MacMp4ScreenRec Design

## Overview

Automatically convert macOS screen recordings or other configured video files in the background with `launchd`, `ffmpeg`, and optional codec-specific override rules resolved via `ffprobe`.

## Defaults

- Watch path: `~/Desktop`
- Selection mode: `recordings-only`
- Input extensions: `mov`
- Output extension: `mp4`
- Default video codec: `copy`
- Default audio codec: `copy`
- Video codec overrides: none
- Audio codec overrides: none
- Original retention: `0` days

## CLI (`mac-mp4-screen-rec`)

- `add <path>` — add a watch path
- `remove <path>` — remove a watch path
- `list` — show current config
- `config` — show current config
- `config --all-files` — convert every file that matches `input_extensions`
- `config --all-movs` — legacy alias for `--all-files`
- `config --only-recordings` — only convert `Screen Recording*`
- `config --keep-original-days <days>` — keep successful originals for N days
- `config --input-extensions <ext1,ext2,...>` — select which extensions to scan
- `config --output-extension <ext>` — choose the output container extension
- `config --video-codec <codec>` — set the default `ffmpeg -c:v`
- `config --audio-codec <codec>` — set the default `ffmpeg -c:a`
- `config --map-video-codec <input=output>` — override video codec by detected source codec
- `config --map-audio-codec <input=output>` — override audio codec by detected source codec
- `config --remove-video-codec-map <input>` / `--remove-audio-codec-map <input>`
- `config --clear-video-codec-maps` / `--clear-audio-codec-maps`
- `convert` — run one immediate scan/cleanup pass
- `start` / `stop` / `status`

## Config (`~/.config/mac-mp4-screen-rec/config`)

```yaml
paths:
~/Desktop

mode: recordings-only
keep_original_days: 0
input_extensions: mov
output_extension: mp4
video_codec: copy
audio_codec: copy
video_codec_map:
audio_codec_map:
```

## Service Model

- `WatchPaths` triggers conversion quickly when files appear or change.
- `StartInterval` runs every hour so delayed original cleanup still happens when no new files arrive.
- The job scans each watched directory root with `find -maxdepth 1`.
- `recordings-only` mode remains name-based: only files starting with `Screen Recording` are eligible after extension filtering.
- Resolved codecs are chosen per file:
  - global defaults from `video_codec` / `audio_codec`
  - optional override by detected source video/audio codec name

## Viability And Constraints

- Input format support is viable because extension selection is only a discovery filter; actual decode/mux/encode support comes from the installed `ffmpeg`.
- Codec-specific overrides are viable because `ffprobe` exposes the source codec names and the shell layer can route to different output codecs on that basis.
- Untouched settings remain on defaults or prior user selections. Only the explicitly matched override is replaced.
- Container/codec mismatches are intentionally not prevalidated in shell. `ffmpeg` remains the source of truth for what combinations work.
- Same-extension transcodes are deliberately not implemented. The current tool writes sibling outputs and then optionally deletes the source; in-place rewrites would need a different naming and retention design.
- Delayed deletion is approximate to the hourly cleanup cadence, not exact to the second.

## Files

- `mac-mp4-screen-rec` — main shell script
- `install.sh` / `uninstall.sh`
- `docs/man/mac-mp4-screen-rec.1` — manpage
- `README.md`
- Separate tap repo: `homebrew-mac-mp4-screen-rec`
