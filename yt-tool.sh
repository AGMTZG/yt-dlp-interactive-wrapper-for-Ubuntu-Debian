#!/usr/bin/env bash

set -e

# ---- Dependency checks ----
if ! command -v yt-dlp >/dev/null 2>&1; then
  echo "yt-dlp is not installed."
  echo "Install it from https://github.com/yt-dlp/yt-dlp"
  exit 1
else 
  echo "yt-dlp is installed (Make sure the latest version is installed by visiting: https://github.com/yt-dlp/yt-dlp)"
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg is not installed."
  echo "Install it using your package manager."
  exit 1
else 
  echo "ffmpeg is installed"
fi

# ---- Function to check ffmpeg dependency ----
needs_ffmpeg() {
  if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "ffmpeg is required for this option."
    echo "Install ffmpeg and try again."
    exit 1
  fi
}

# ---- Check default browser ----
BROWSER=""
DEFAULT_BROWSER=$(xdg-settings get default-web-browser 2>/dev/null)
DEFAULT_BROWSER_LOWER=$(echo "$DEFAULT_BROWSER" | tr '[:upper:]' '[:lower:]')

case "$DEFAULT_BROWSER_LOWER" in
  *firefox*)
    BROWSER="firefox"
    ;;
  *chrome*)
    BROWSER="chrome"
    ;;
  *chromium*)
    BROWSER="chromium"
    ;;
  *brave*)
    BROWSER="brave"
    ;;
  *edge*)
    BROWSER="edge"
    ;;
  *)
    BROWSER=""
    ;;
esac

# ---- Checking if a default browser was detected  ----
if [ -z "$BROWSER" ]; then
  echo "Could not detect default browser."
  echo "Falling back to first supported browser found."

  if command -v firefox >/dev/null 2>&1; then
    BROWSER="firefox"
  elif command -v google-chrome >/dev/null 2>&1; then
    BROWSER="chrome"
  elif command -v chromium >/dev/null 2>&1; then
    BROWSER="chromium"
  elif command -v brave >/dev/null 2>&1; then
    BROWSER="brave"
  elif command -v microsoft-edge >/dev/null 2>&1; then
    BROWSER="edge"
  else
    echo "No supported browser found."
    exit 1
  fi
fi

echo "Using browser cookies from: $BROWSER"
echo "Make sure you are logged in to YouTube in this browser."

# ---- Menu  ----
echo
echo "Select an option:"
echo "  1) Download audio (m4a)"
echo "  2) Download audio (mp3)"
echo "  3) Download audio (wav)"
echo "  4) Download video (mp4)"
echo "  5) Download video (webm if available, otherwise not supported)"
echo
read -p "Enter option [1-5]: " OPTION

echo
echo "Paste a full YouTube URL, for example:"
echo "https://www.youtube.com/watch?v=XXXXXXXXXXX"
echo

read -p "Paste YouTube URL: " URL

if [ -z "$URL" ]; then
  echo "No URL provided."
  exit 1
fi

if [[ ! "$URL" =~ youtube\.com|youtu\.be ]]; then
  echo "That does not look like a YouTube URL."
  exit 1
fi

# ---- Download directories ----
BASE_DIR="$(pwd)/downloads"
AUDIO_DIR="$BASE_DIR/audio"
VIDEO_DIR="$BASE_DIR/video"

case "$OPTION" in
  1)
    echo "Downloading audio (m4a)..."
    yt-dlp \
      --no-overwrites \
      --cookies-from-browser "$BROWSER" \
      -o "$AUDIO_DIR/%(title)s.%(ext)s" \
      -x \
      "$URL"
    ;;
  2)
    needs_ffmpeg
    echo "Downloading audio (mp3)..."
    yt-dlp \
      --no-overwrites \
      --cookies-from-browser "$BROWSER" \
      -x --audio-format mp3 --audio-quality 0 \
      -o "$AUDIO_DIR/%(title)s.%(ext)s" \
      "$URL"
    ;;
  3)
    needs_ffmpeg
    echo "Downloading audio (wav)..."
    yt-dlp \
      --no-overwrites \
      --cookies-from-browser "$BROWSER" \
      -x --audio-format wav \
      -o "$AUDIO_DIR/%(title)s.%(ext)s" \
      "$URL"
    ;;
  4)
    needs_ffmpeg

    echo
    echo "Fetching available video resolutions..."

    mapfile -t FORMATS < <(
      yt-dlp --cookies-from-browser "$BROWSER" -F "$URL" \
      | awk '$2=="mp4" && $0~"m3u8" && $3~"x" {print $1 "|" $3}'
    )

    if [ ${#FORMATS[@]} -eq 0 ]; then
      echo "No compatible MP4 video formats found."
      exit 1
    fi

    echo
    echo "Available video resolutions:"
    INDEX=1
    declare -A FORMAT_MAP

    for ENTRY in "${FORMATS[@]}"; do
      FORMAT_ID="${ENTRY%%|*}"
      RESOLUTION="${ENTRY##*|}"
      echo "  $INDEX) $RESOLUTION"
      FORMAT_MAP[$INDEX]="$FORMAT_ID"
      ((INDEX++))
    done

    echo
    read -p "Choose resolution [1-$((INDEX-1))]: " RES_OPT

    FORMAT="${FORMAT_MAP[$RES_OPT]}"

    if [ -z "$FORMAT" ]; then
      echo "Invalid resolution option."
      exit 1
    fi

    echo "Downloading video (mp4)..."
    yt-dlp \
      --no-overwrites \
      --cookies-from-browser "$BROWSER" \
      -f "$FORMAT/bv*+ba/b" \
      --merge-output-format mp4 \
      -o "$VIDEO_DIR/%(title)s.%(ext)s" \
      "$URL"
    ;;
  5)
    echo "Downloading video (webm)..."
    if yt-dlp --cookies-from-browser "$BROWSER" -F "$URL" | awk '$2=="webm" {found=1} END{exit !found}'; then
      echo "WebM formats detected. Downloading WebM..."

      yt-dlp \
        --no-overwrites \
        --cookies-from-browser "$BROWSER" \
        -f "bv*[ext=webm]+ba*[ext=webm]" \
        --merge-output-format webm \
        -o "$VIDEO_DIR/%(title)s.webm" \
        "$URL"
    else
      echo "WebM is not available for this video."
      echo "YouTube only exposed HLS MP4 formats."
      echo "Try option 4 (MP4) instead."
      exit 1
    fi
    ;;
  *)
    echo "Invalid option."
    exit 1
    ;;
esac

