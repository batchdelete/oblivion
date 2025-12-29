#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
  echo "This script is intended for macOS only."
  exit 1
fi

REPO="batchdelete/oblivion"
TMP_DIR="/tmp/Oblivion"
APP_NAME="Oblivion.app"
APP_PATH="/Applications/$APP_NAME"

mkdir -p "$TMP_DIR"

echo "Fetching latest release from GitHub..."

url=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" \
  | grep -Eo '"browser_download_url":[^"]+\.zip"' \
  | head -n 1 \
  | sed 's/"browser_download_url":"//;s/"//')

if [ -z "$url" ]; then
  echo "Failed to find a ZIP asset in the latest release."
  exit 1
fi

echo "Found release asset:"
echo "$url"

if [ -d "$APP_PATH" ]; then
  echo "Removing existing Oblivion installation..."
  rm -rf "$APP_PATH"
fi

echo "Downloading Oblivion..."
curl -L -o "$TMP_DIR/oblivion.zip" "$url"

echo "Extracting Oblivion..."
unzip -o "$TMP_DIR/oblivion.zip" -d "$TMP_DIR"

APP_FOUND=$(find "$TMP_DIR" -maxdepth 2 -name "*.app" -type d | head -n 1)

if [ -z "$APP_FOUND" ]; then
  echo "No .app bundle found in the archive."
  exit 1
fi

echo "Installing to /Applications..."
mv -f "$APP_FOUND" "/Applications"

rm -rf "$TMP_DIR"

echo "Oblivion has been successfully installed!"
