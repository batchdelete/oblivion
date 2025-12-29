#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
  echo "This script is intended for macOS only."
  exit 1
fi

REPO="batchdelete/oblivion"
TMP_DIR="/tmp/Oblivion"
ZIP_NAME="oblivion.zip"
APP_NAME="Oblivion.app"
APP_PATH="/Applications/$APP_NAME"

mkdir -p "$TMP_DIR"

echo "Fetching latest release info..."

url=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" \
  | grep -Eo '"browser_download_url": "[^"]+' \
  | grep "$ZIP_NAME" \
  | sed 's/"browser_download_url": "//')

if [ -z "$url" ]; then
  echo "Failed to find $ZIP_NAME in the latest release."
  exit 1
fi

echo "Found release asset: $url"

if [ -d "$APP_PATH" ]; then
  echo "Removing existing Oblivion installation..."
  rm -rf "$APP_PATH"
fi

echo "Downloading Oblivion..."
curl -L -o "$TMP_DIR/$ZIP_NAME" "$url"

echo "Extracting Oblivion..."
unzip -o "$TMP_DIR/$ZIP_NAME" -d "$TMP_DIR"

APP_FOUND=$(find "$TMP_DIR" -maxdepth 2 -name "*.app" -type d | head -n 1)

if [ -z "$APP_FOUND" ]; then
  echo "No .app bundle found in the archive."
  exit 1
fi

echo "Installing to /Applications..."
mv -f "$APP_FOUND" "/Applications"

rm -rf "$TMP_DIR"

echo "Oblivion has been successfully installed!"
