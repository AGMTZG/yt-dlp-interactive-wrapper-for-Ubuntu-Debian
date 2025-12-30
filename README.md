# Interactive Media Archiving Toolkit (Ubuntu / Debian)

A lightweight interactive Bash toolkit designed to simplify **personal media archiving workflows** on Linux systems.

This tool provides a terminal-based menu that wraps existing open-source utilities, allowing users to download and organize audio or video files without memorizing command-line flags.

Run one command, follow the menu, and archive your media.

---

## Features

- Interactive terminal menu (no flags required)
- Audio extraction formats:
  - m4a
  - mp3
  - wav
- Video downloads:
  - MP4 with selectable resolution
  - WebM when available
- Dynamically detects **only real, available formats**
- Handles HLS streams automatically
- Uses browser cookies for authenticated sessions
- Automatically organizes files into clean folders

---

## Supported Sources

This script relies on `yt-dlp`, which supports multiple media platforms depending on availability and configuration.

Format availability depends on the source and may vary per media item.

---

## Requirements

- Linux (Ubuntu / Debian recommended)
- Bash
- yt-dlp
- ffmpeg
- A supported browser (Firefox or Chromium-based)

---

## Installation

Make the scripts executable:

```bash
chmod +x install.sh yt-tool.sh
```

Install dependencies (recommended)

```bash
./install.sh
```

This installs:

- yt-dlp

- ffmpeg

(Ubuntu / Debian based systems)

## Usage

Launch the tool:

```bash
./yt-tool.sh
```
Then follow the interactive menu:

- Choose audio or video
- Select the desired format
- Paste a media URL
- If downloading video, choose from the available resolutions only

No flags. No guessing format IDs. No cluttered websites.

## Download Structure

```bash
downloads/
├── audio/
└── video/
```
Files are automatically organized.

## Notes & Limitations

- WebM downloads depend on the source exposing WebM formats

- Some media sources only provide HLS MP4 streams

- This tool does not bypass DRM or protected content

- Authenticated sessions require being logged in via your browser

- Format availability depends entirely on upstream sources and yt-dlp

## Disclaimer (Important)
This tool is intended strictly for personal and educational use.
It should only be used to download:

- Content you own
- Content you have explicit permission to archive
- Publicly available media where downloading is allowed
  
This project does not promote or encourage violation of platform terms of service, copyright laws, or usage policies.
Users are solely responsible for ensuring compliance with applicable laws and platform rules.

