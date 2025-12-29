#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
  echo "This script is intended for macOS only."
  exit 1
fi

REPO="batchdelete/oblivion"
TMP_DIR="/tmp/Oblivion"
ZIP_NAME="oblivion.zip"
APP_NAME="oblivion.app"
APP_PATH="/Applications/$APP_NAME"

mkdir -p "$TMP_DIR"

url=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" \
  | grep -Eo '"browser_download_url":[^"]*"' \
  | grep "$ZIP_NAME" \
  | sed 's/"browser_download_url":"//;s/"//')

if [ -z "$url" ]; then
  echo "Failed to find $ZIP_NAME in the latest release."
  exit 1
fi

if [ -d "$APP_PATH" ]; then
  echo "oblivion is already installed. Removing old version..."
  rm -rf "$APP_PATH"
fi

echo "Downloading latest oblivion release..."
curl -L -o "$TMP_DIR/$ZIP_NAME" "$url"

echo "Extracting oblivion..."
unzip -o "$TMP_DIR/$ZIP_NAME" -d "$TMP_DIR"

echo "Installing to /Applications..."
mv -f "$TMP_DIR/$APP_NAME" "/Applications"

# Cleanup
rm -rf "$TMP_DIR"

echo "oblivion has been successfully installed!"
