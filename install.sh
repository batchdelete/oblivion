#!/bin/bash

# Ensure macOS
if [ "$(uname)" != "Darwin" ]; then
  echo "This script is intended for macOS only."
  exit 1
fi

TMP_DIR="/tmp/Oblivion"
APP_NAME="Oblivion.app"
APP_PATH="/Applications/$APP_NAME"
ZIP_URL="https://github.com/batchdelete/oblivion/releases/download/1.0.0/oblivion.zip"

mkdir -p "$TMP_DIR"

if [ -d "$APP_PATH" ]; then
  echo "Oblivion is already installed. Removing..."
  rm -rf "$APP_PATH"
  echo "Old version deleted."
else
  echo "Oblivion is not installed. Proceeding with installation."
fi

echo "Downloading oblivion."
curl -L -o "$TMP_DIR/oblivion.zip" "$ZIP_URL"

echo "Extracting oblivion."
unzip -o "$TMP_DIR/oblivion.zip" -d "$TMP_DIR"

APP_FOUND=$(find "$TMP_DIR" -maxdepth 2 -name "*.app" -type d | head -n 1)

if [ -z "$APP_FOUND" ]; then
  echo "No .app bundle found in the archive."
  exit 1
fi

echo "Installing to /Applications."
mv -f "$APP_FOUND" "$APP_PATH"

rm -rf "$TMP_DIR"

echo "oblivion has been successfully installed."
