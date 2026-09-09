#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST="$ROOT/dist"
PACKAGE_NAME="UNI.XYZ_VALIDATION__0.1.0"
PACKAGE_DIR="$DIST/$PACKAGE_NAME"
ZIP_PATH="$DIST/${PACKAGE_NAME}.zip"

rm -rf "$DIST"
mkdir -p "$PACKAGE_DIR"

cd "$ROOT"
while IFS= read -r path; do
  mkdir -p "$PACKAGE_DIR/$(dirname "$path")"
  cp "$path" "$PACKAGE_DIR/$path"
done < <(
  find . -type f \
    ! -path './node_modules/*' \
    ! -path './dist/*' \
    ! -name 'CHECKSUMS.sha256' \
    ! -name '*.zip' \
    -printf '%P\n' | sort
)

cd "$PACKAGE_DIR"
find . -type f ! -name 'CHECKSUMS.sha256' -printf '%P\n' | sort | while IFS= read -r path; do
  sha256sum "$path"
done > CHECKSUMS.sha256

cd "$DIST"
zip -X -q -r "$ZIP_PATH" "$PACKAGE_NAME"
sha256sum "$(basename "$ZIP_PATH")" > "${PACKAGE_NAME}.zip.sha256"

unzip -t "$ZIP_PATH"
cd "$PACKAGE_DIR"
sha256sum -c CHECKSUMS.sha256
