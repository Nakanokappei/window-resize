#!/bin/bash
# build.sh - Compile and assemble Window Resize.app bundle

set -euo pipefail

APP_NAME="Window Resize"
EXECUTABLE_NAME="WindowResize"
BUILD_DIR="./build"
SIGNING_IDENTITY="Developer ID Application: Kappei Nakano (G466Q9TVYB)"
NOTARYTOOL_PROFILE="notarytool-profile"
# iCloud Drive上ではxattr (com.apple.provenance等) が自動付与されcodesignが失敗するため、
# /tmp でビルドしてから成果物をコピーする
# Build in /tmp to avoid iCloud Drive xattrs that prevent codesign
STAGING_DIR=$(mktemp -d)/build
APP_BUNDLE="${STAGING_DIR}/${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
SOURCES_DIR="./Sources"

echo "=== Building ${APP_NAME} ==="

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

# Compile Asset Catalog (supports dark mode icon on macOS 15+)
# Asset Catalogをコンパイル（macOS 15+のダークモードアイコン対応）
XCASSETS_DIR="${LOCALIZATIONS_DIR}/Assets.xcassets"
if [ -d "${XCASSETS_DIR}" ]; then
    xcrun actool "${XCASSETS_DIR}" \
        --compile "${RESOURCES_DIR}" \
        --platform macosx \
        --minimum-deployment-target 13.0 \
        --app-icon AppIcon \
        --output-partial-info-plist /dev/null \
        > /dev/null 2>&1
    echo "=== Compiled Assets.xcassets (light + dark + tinted icons) ==="
fi

# Copy .icns as fallback for older macOS (< 15)
# 古いmacOS (< 15) 向けに.icnsもコピー
if [ -f "${LOCALIZATIONS_DIR}/AppIcon.icns" ]; then
    cp "${LOCALIZATIONS_DIR}/AppIcon.icns" "${RESOURCES_DIR}/AppIcon.icns"
    echo "=== Copied AppIcon.icns (fallback) ==="
fi

# Copy .icon package for macOS 26+ (Liquid Glass / dark mode icon)
# macOS 26+向けの.iconパッケージをコピー（Liquid Glass / ダークモードアイコン対応）
ICON_FILE="./Window Size App Icon.icon"
if [ -d "${ICON_FILE}" ]; then
    cp -R "${ICON_FILE}" "${RESOURCES_DIR}/AppIcon.icon"
    echo "=== Copied AppIcon.icon (macOS 26+) ==="
fi

# Copy menu bar icon (template image) into bundle Resources
# メニューバーアイコンをバンドルにコピー
if [ -f "${LOCALIZATIONS_DIR}/MenuBarIcon.png" ]; then
    cp "${LOCALIZATIONS_DIR}/MenuBarIcon.png" "${RESOURCES_DIR}/MenuBarIcon.png"
    cp "${LOCALIZATIONS_DIR}/MenuBarIcon@2x.png" "${RESOURCES_DIR}/MenuBarIcon@2x.png"
    echo "=== Copied MenuBarIcon ==="
fi

# Strip com.apple.quarantine xattr from all files in the bundle.
# iCloud Drive上のファイルやダウンロードファイルに付与される属性を除去
find "${APP_BUNDLE}" -exec xattr -d com.apple.quarantine {} + 2>/dev/null || true

# Developer ID code sign with hardened runtime (required for notarization)
# Developer ID署名 + Hardened Runtime（公証に必須）
echo "=== Signing ${APP_NAME}.app with Developer ID ==="
codesign --force --sign "${SIGNING_IDENTITY}" --timestamp --options runtime "${APP_BUNDLE}"

# Copy signed bundle from staging to project build directory
# 署名済みバンドルをプロジェクトのbuildディレクトリにコピー
mkdir -p "${BUILD_DIR}"
cp -R "${APP_BUNDLE}" "${BUILD_DIR}/"
rm -rf "${STAGING_DIR}"

# Notarize the app / アプリを公証する
echo "=== Notarizing ${APP_NAME}.app ==="
ZIP_PATH="${BUILD_DIR}/WindowResize.zip"
ditto -c -k --keepParent "${BUILD_DIR}/${APP_NAME}.app" "${ZIP_PATH}"
xcrun notarytool submit "${ZIP_PATH}" --keychain-profile "${NOTARYTOOL_PROFILE}" --wait
rm -f "${ZIP_PATH}"

# Staple the notarization ticket / 公証チケットをステープル
echo "=== Stapling notarization ticket ==="
xcrun stapler staple "${BUILD_DIR}/${APP_NAME}.app"

echo "=== Build complete: ${BUILD_DIR}/${APP_NAME}.app ==="
echo "Run with: open \"${BUILD_DIR}/${APP_NAME}.app\""
