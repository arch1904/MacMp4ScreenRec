# Titles

**r/MacOS:** I made a free tool that auto-converts macOS screen recordings and other video files with ffmpeg

**r/opensource:** MacMp4ScreenRec — launchd + ffmpeg tool for auto-converting macOS recordings and video files

**r/commandline:** mac-mp4-screen-rec: auto-convert screen recordings or other watched video files in the background

---

# Post body

macOS saves screen recordings as `.mov`, and a lot of people immediately need `.mp4` instead. I built a small shell + `launchd` tool that handles that automatically in the background, and it now supports a bit more than just the default MOV remux path.

**What it does by default:**

- Watches `~/Desktop`
- Only converts files named `Screen Recording*`
- Scans for `.mov`
- Writes `.mp4`
- Uses `ffmpeg -c:v copy -c:a copy` (so MOV -> MP4 stays lossless and fast)
- Deletes the original immediately after a successful conversion

**What you can configure now:**

- Keep originals for `x` days before deleting them
- Convert all matching files instead of only `Screen Recording*`
- Choose which input extensions to scan (`mov,mkv,avi`, etc.)
- Choose the output extension and the ffmpeg video/audio codecs
- Override video/audio codecs only when the source file codec matches a rule

Examples:

```bash
mac-mp4-screen-rec config --all-files --input-extensions mov,mkv --output-extension mp4
mac-mp4-screen-rec config --video-codec libx264 --audio-codec aac
mac-mp4-screen-rec config --map-video-codec hevc=libx264
mac-mp4-screen-rec config --map-audio-codec pcm_s16le=aac
mac-mp4-screen-rec config --keep-original-days 7
```

It uses native macOS file watching via `launchd`, and also runs a periodic cleanup pass so retained originals still get deleted even if no new files arrive.

**Install:**

```bash
brew tap arch1904/mac-mp4-screen-rec
brew install mac-mp4-screen-rec
mac-mp4-screen-rec start
```

**Why MOV -> MP4 is lossless by default:** macOS screen recordings are typically H.264/AAC inside MOV. MOV and MP4 are just containers around the same streams, so `copy` remuxes without re-encoding.

GitHub: https://github.com/arch1904/MacMp4ScreenRec

MIT licensed.
