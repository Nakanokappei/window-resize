#!/bin/bash
# build-appstore.sh - Build, sign, and package Window Resize for Mac App Store
#
# Prerequisites:
#   1. "Apple Distribution" certificate installed in Keychain
#   2. "3rd Party Mac Developer Installer" certificate installed in Keychain
#   3. Provisioning profile downloaded from developer.apple.com
#      and placed at ./WindowResize_AppStore.provisionprofile
#   4. App registered in App Store Connect
#
# Usage:
#   bash build-appstore.sh                # Build + package
#   bash build-appstore.sh --upload       # Build + package + upload to App Store Connect

set -euo pipefail

APP_NAME="Window Resize"
EXECUTABLE_NAME="WindowResize"
BUILD_DIR="./build-appstore"
TEAM_ID="G466Q9TVYB"
SIGNING_IDENTITY="Apple Distribution: Kappei Nakano (${TEAM_ID})"
INSTALLER_IDENTITY="3rd Party Mac Developer Installer: Kappei Nakano (${TEAM_ID})"
ENTITLEMENTS="./WindowResize.entitlements"
PROVISIONING_PROFILE="./WindowResize_AppStore.provisionprofile"
# Build in /tmp to avoid iCloud Drive xattrs that prevent codesign
STAGING_DIR=$(mktemp -d)/build
APP_BUNDLE="${STAGING_DIR}/${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
SOURCES_DIR="./Sources"

echo "=== Building ${APP_NAME} (App Store) ==="

# Verify prerequisites
if [ ! -f "${ENTITLEMENTS}" ]; then
    echo "ERROR: Entitlements file not found: ${ENTITLEMENTS}"
    exit 1
fi
if [ ! -f "${PROVISIONING_PROFILE}" ]; then
    echo "ERROR: Provisioning profile not found: ${PROVISIONING_PROFILE}"
    echo "Download from https://developer.apple.com/account/resources/profiles/"
    exit 1
fi

# Clean previous build
rm -rf "${BUILD_DIR}"

# Create .app bundle directory structure in staging area
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
    -framework ScreenCaptureKit \
    ${SOURCES_DIR}/*.swift

# Copy Info.plist into bundle
cp Info.plist "${CONTENTS_DIR}/Info.plist"

# Embed provisioning profile
RESOURCES_DIR="${CONTENTS_DIR}/Resources"
mkdir -p "${RESOURCES_DIR}"
cp "${PROVISIONING_PROFILE}" "${CONTENTS_DIR}/embedded.provisionprofile"

# Copy localization resources into bundle
LOCALIZATIONS_DIR="./Resources"
if [ -d "${LOCALIZATIONS_DIR}" ]; then
    for lproj in "${LOCALIZATIONS_DIR}"/*.lproj; do
        if [ -d "${lproj}" ]; then
            cp -R "${lproj}" "${RESOURCES_DIR}/"
        fi
    done
    echo "=== Copied localizations ==="
fi

# Compile Asset Catalog
XCASSETS_DIR="${LOCALIZATIONS_DIR}/Assets.xcassets"
if [ -d "${XCASSETS_DIR}" ]; then
    xcrun actool "${XCASSETS_DIR}" \
        --compile "${RESOURCES_DIR}" \
        --platform macosx \
        --minimum-deployment-target 13.0 \
        --app-icon AppIcon \
        --output-partial-info-plist /dev/null \
        > /dev/null 2>&1
    echo "=== Compiled Assets.xcassets ==="
fi

# Copy .icns as fallback
if [ -f "${LOCALIZATIONS_DIR}/AppIcon.icns" ]; then
    cp "${LOCALIZATIONS_DIR}/AppIcon.icns" "${RESOURCES_DIR}/AppIcon.icns"
fi

# Copy .icon package for macOS 26+
ICON_FILE="./Window Size App Icon.icon"
if [ -d "${ICON_FILE}" ]; then
    cp -R "${ICON_FILE}" "${RESOURCES_DIR}/AppIcon.icon"
fi

# Copy menu bar icon
if [ -f "${LOCALIZATIONS_DIR}/MenuBarIcon.png" ]; then
    cp "${LOCALIZATIONS_DIR}/MenuBarIcon.png" "${RESOURCES_DIR}/MenuBarIcon.png"
    cp "${LOCALIZATIONS_DIR}/MenuBarIcon@2x.png" "${RESOURCES_DIR}/MenuBarIcon@2x.png"
fi

# Code sign with Apple Distribution certificate + entitlements (App Sandbox)
echo "=== Signing ${APP_NAME}.app for App Store ==="
codesign --force --sign "${SIGNING_IDENTITY}" \
    --entitlements "${ENTITLEMENTS}" \
    --timestamp \
    "${APP_BUNDLE}"

# Copy signed bundle from staging to build directory
mkdir -p "${BUILD_DIR}"
cp -R "${APP_BUNDLE}" "${BUILD_DIR}/"
rm -rf "${STAGING_DIR}"

# Create installer .pkg for App Store submission
PKG_PATH="${BUILD_DIR}/${EXECUTABLE_NAME}.pkg"
echo "=== Creating installer package ==="
productbuild \
    --component "${BUILD_DIR}/${APP_NAME}.app" /Applications \
    --sign "${INSTALLER_IDENTITY}" \
    --timestamp \
    "${PKG_PATH}"

echo "=== Package created: ${PKG_PATH} ==="

# Upload to App Store Connect if --upload flag is provided
if [ "${1:-}" = "--upload" ]; then
    echo "=== Validating package ==="
    xcrun altool --validate-app -f "${PKG_PATH}" -t macos --apiKey "" --apiIssuer ""
    echo "=== Uploading to App Store Connect ==="
    xcrun altool --upload-app -f "${PKG_PATH}" -t macos --apiKey "" --apiIssuer ""
    echo "=== Upload complete ==="
else
    echo ""
    echo "To upload to App Store Connect:"
    echo "  xcrun altool --upload-app -f \"${PKG_PATH}\" -t macos --apiKey YOUR_KEY --apiIssuer YOUR_ISSUER"
    echo "  or open Transporter.app and drag in \"${PKG_PATH}\""
fi

echo "=== App Store build complete ==="
