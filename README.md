# YouTube Interactive Download Toolkit

A simple interactive Bash toolkit to download audio or video from YouTube without memorizing yt-dlp flags.

Run one command, follow the menu, get your files.

## Features
- Interactive menu (no flags required)
- Download audio in m4a, mp3, or wav
- Download video in MP4 with selectable resolution
- Dynamically detects real available resolutions
- Handles HLS streams automatically
- Uses browser cookies (no manual login)
- Organizes downloads into clean folders

## Important

WebM downloads depend on YouTube exposing WebM formats.
Some videos only provide HLS MP4 streams.

## Requirements
- yt-dlp
- ffmpeg
- Firefox or Chromium-based browsers

## Installation

Make files executable

```bash
chmod +x install.sh yt-tool
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

- Select format

- Paste a YouTube URL

- If video, choose from available resolutions only

No flags. No guessing formats.

## Download Structure

```bash
downloads/
├── audio/
└── video/
```
Files are automatically organized.

## Notes & Limitations

- Does not bypass private or DRM-protected videos

- Requires being logged into YouTube in your browser

- Relies on yt-dlp updates

