# MacMp4ScreenRec Design

## Overview

Automatically convert macOS screen recordings or other configured video files in the background with `launchd` and `ffmpeg`.

## Defaults

- Watch path: `~/Desktop`
- Selection mode: `recordings-only`
- Input extensions: `mov`
- Output extension: `mp4`
- Video codec: `copy`
- Audio codec: `copy`
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
- `config --video-codec <codec>` — set `ffmpeg -c:v`
- `config --audio-codec <codec>` — set `ffmpeg -c:a`
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
```

## Service Model

- `WatchPaths` triggers conversion quickly when files appear or change.
- `StartInterval` runs every hour so delayed original cleanup still happens when no new files arrive.
- The job scans each watched directory root with `find -maxdepth 1`.
- `recordings-only` mode remains name-based: only files starting with `Screen Recording` are eligible after extension filtering.

## Viability And Constraints

- Input format support is viable because extension selection is only a discovery filter; actual decode/mux/encode support comes from the installed `ffmpeg`.
- Codec support is viable for the same reason. The script passes configured codec names directly to `ffmpeg`.
- Container/codec mismatches are intentionally not prevalidated in shell. `ffmpeg` remains the source of truth for what combinations work.
- Same-extension transcodes are deliberately not implemented. The current tool writes sibling outputs and then optionally deletes the source; in-place rewrites would need a different naming and retention design.
- Delayed deletion is approximate to the hourly cleanup cadence, not exact to the second.

## Files

- `mac-mp4-screen-rec` — main shell script
- `install.sh` / `uninstall.sh`
- `docs/man/mac-mp4-screen-rec.1` — manpage
- `README.md`
- Separate tap repo: `homebrew-mac-mp4-screen-rec`
