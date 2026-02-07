#!/bin/bash
# build.sh - Compile and assemble Window Resize.app bundle

set -euo pipefail

APP_NAME="Window Resize"
EXECUTABLE_NAME="WindowResize"
BUILD_DIR="./build"
APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
SOURCES_DIR="./Sources"

echo "=== Building ${APP_NAME} ==="

# Clean previous build
rm -rf "${BUILD_DIR}"

# Create .app bundle directory structure
mkdir -p "${MACOS_DIR}"

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    TARGET="arm64-apple-macos13.0"
else
    TARGET="x86_64-apple-macos13.0"
fi

# Compile all Swift sources into a single executable
swiftc \
    -o "${MACOS_DIR}/${EXECUTABLE_NAME}" \
    -target "${TARGET}" \
    -sdk "$(xcrun --show-sdk-path)" \
    -framework AppKit \
    -framework ApplicationServices \
    -framework SwiftUI \
    -framework ServiceManagement \
    ${SOURCES_DIR}/*.swift

# Copy Info.plist into bundle
cp Info.plist "${CONTENTS_DIR}/Info.plist"

# Copy localization resources into bundle
RESOURCES_DIR="${CONTENTS_DIR}/Resources"
LOCALIZATIONS_DIR="./Resources"
if [ -d "${LOCALIZATIONS_DIR}" ]; then
    mkdir -p "${RESOURCES_DIR}"
    for lproj in "${LOCALIZATIONS_DIR}"/*.lproj; do
        if [ -d "${lproj}" ]; then
            cp -R "${lproj}" "${RESOURCES_DIR}/"
        fi
    done
    echo "=== Copied localizations: $(ls -d "${RESOURCES_DIR}"/*.lproj 2>/dev/null | xargs -n1 basename | tr '\n' ' ') ==="
fi

# Reset stale Accessibility permission (unsigned app の場合、リビルドでハッシュが変わり古い権限が無効化される)
BUNDLE_ID="com.windowresize.app"
echo "=== Resetting Accessibility permission for ${BUNDLE_ID} ==="
tccutil reset Accessibility "${BUNDLE_ID}" 2>/dev/null || true

echo "=== Build complete: ${APP_BUNDLE} ==="
echo "Run with: open \"${APP_BUNDLE}\""
