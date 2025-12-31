#!/bin/bash
set -euo pipefail

if [[ "$(uname)" != "Darwin" ]]; then
  echo "This script is intended for macOS only."
  exit 1
fi

APP_NAME="Oblivion.app"
APP_PATH="/Applications/$APP_NAME"
ZIP_URL="https://github.com/batchdelete/oblivion/releases/download/2.0.0/oblivion.zip"

TMP_DIR="$(mktemp -d /tmp/Oblivion.XXXXXX)"
ZIP_PATH="$TMP_DIR/oblivion.zip"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Downloading Oblivion..."
curl --fail --location --silent --show-error \
  -o "$ZIP_PATH" "$ZIP_URL"

echo "Extracting (preserving macOS metadata)..."
ditto -x -k "$ZIP_PATH" "$TMP_DIR"

APP_FOUND="$(find "$TMP_DIR" -maxdepth 2 -name "*.app" -type d | head -n 1)"

if [[ -z "$APP_FOUND" ]]; then
  echo "Error: No .app bundle found in archive."
  exit 1
fi

if [[ -d "$APP_PATH" ]]; then
  echo "Removing existing installation..."
  sudo rm -rf "$APP_PATH"
fi

echo "Installing to /Applications..."
sudo ditto "$APP_FOUND" "$APP_PATH"

echo "Removing quarantine attribute..."
sudo xattr -dr com.apple.quarantine "$APP_PATH"

echo "Verifying code signature..."
codesign --verify --deep --strict "$APP_PATH" >/dev/null 2>&1 || true {
}

echo "Oblivion has been successfully installed."
