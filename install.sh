#!/bin/bash

# macOS only check
if [ "$(uname)" != "Darwin" ]; then
  echo "This script is intended for macOS only."
  exit 1
fi

url="https://balls/oblivion.zip"

TMP_DIR="/tmp/Oblivion"
APP_NAME="Oblivion.app"
APP_PATH="/Applications/$APP_NAME"

mkdir -p "$TMP_DIR"

if [ -d "$APP_PATH" ]; then
  echo "Oblivion is already installed. Removing old version..."
  rm -rf "$APP_PATH"
fi

echo "Downloading Oblivion..."
curl -L -o "$TMP_DIR/oblivion.zip" "$url"

echo "Extracting Oblivion..."
unzip -o "$TMP_DIR/oblivion.zip" -d "$TMP_DIR"

echo "Installing to /Applications..."
mv -f "$TMP_DIR/$APP_NAME" "/Applications"

rm -rf "$TMP_DIR"

echo "Oblivion has been successfully installed!"
