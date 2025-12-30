#!/usr/bin/env bash

set -e

echo "=== YouTube Downloader Installer ==="
echo

# ---- Check OS ----
if ! command -v apt >/dev/null 2>&1; then
  echo "This installer currently supports Debian/Ubuntu systems only."
  echo "Please install yt-dlp and ffmpeg manually for your OS."
  exit 1
fi

# ---- yt-dlp ----
if command -v yt-dlp >/dev/null 2>&1; then
  echo "yt-dlp is already installed."
  yt-dlp --version
else
  echo "Installing yt-dlp..."
  sudo curl -L \
    https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
    -o /usr/local/bin/yt-dlp
  sudo chmod a+rx /usr/local/bin/yt-dlp
  hash -r
  yt-dlp --version
fi

echo

# ---- ffmpeg ----
if command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg is already installed."
  ffmpeg -version | head -n 1
else
  echo "Installing ffmpeg..."
  sudo apt update
  sudo apt install -y ffmpeg
fi

echo
echo "Installation completed successfully."
echo "You can now run ./yt-tool.sh"
