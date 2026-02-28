#!/bin/bash
# build-installer.sh - Create macOS .pkg installer for Window Resize
# Requires: build.sh to be run first (app must exist in build/)

set -euo pipefail

APP_NAME="Window Resize"
BUILD_DIR="./build"
# SHA-1 hash to avoid ambiguity when multiple certs share the same name
INSTALLER_SIGNING_IDENTITY="825427F1FF9C30326D6D2837FEC608902501B34F"
NOTARYTOOL_PROFILE="notarytool-profile"
VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" Info.plist)
APP_PATH="${BUILD_DIR}/${APP_NAME}.app"
PKG_DIR="${BUILD_DIR}/installer"

# Ensure app is built
if [ ! -d "${APP_PATH}" ]; then
    echo "Error: ${APP_PATH} not found. Run build.sh first."
    exit 1
fi

echo "=== Creating installer for ${APP_NAME} v${VERSION} ==="

# Clean
rm -rf "${PKG_DIR}"
mkdir -p "${PKG_DIR}/resources" "${PKG_DIR}/components"

# -------------------------------------------------------
# Component 1: App (required)
# -------------------------------------------------------
APP_PAYLOAD="${PKG_DIR}/payload-app"
mkdir -p "${APP_PAYLOAD}/Applications"
cp -R "${APP_PATH}" "${APP_PAYLOAD}/Applications/"

pkgbuild \
    --root "${APP_PAYLOAD}" \
    --identifier "com.windowresize.app.pkg" \
    --version "${VERSION}" \
    --install-location "/" \
    "${PKG_DIR}/components/app.pkg"

# -------------------------------------------------------
# Component 2: User Manuals (optional)
# -------------------------------------------------------
DOCS_PAYLOAD="${PKG_DIR}/payload-docs"
DOCS_DEST="${DOCS_PAYLOAD}/Library/Documentation/Window Resize"
mkdir -p "${DOCS_DEST}"
cp README.md "${DOCS_DEST}/"
cp LICENSE "${DOCS_DEST}/"
cp docs/manual-*.md "${DOCS_DEST}/"

pkgbuild \
    --root "${DOCS_PAYLOAD}" \
    --identifier "com.windowresize.docs.pkg" \
    --version "${VERSION}" \
    --install-location "/" \
    "${PKG_DIR}/components/docs.pkg"

# -------------------------------------------------------
# Welcome screen (HTML)
# -------------------------------------------------------
cat > "${PKG_DIR}/resources/welcome.html" << 'HTML_EOF'
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"></head>
<body style="font-family: -apple-system, Helvetica Neue, sans-serif; font-size: 13px; line-height: 1.6;">
<h2>Window Resize</h2>
<p>A menu bar application that resizes windows to preset sizes.</p>
<h3>Features</h3>
<ul>
<li><b>Menu bar resident</b> — click the icon to open the menu</li>
<li><b>12 built-in preset sizes</b> — Mac Retina displays + standard resolutions</li>
<li><b>Custom sizes</b> — add your own width × height presets</li>
<li><b>Launch at login</b> — optional auto-start</li>
<li><b>16 languages</b> supported</li>
</ul>
<h3>Requirements</h3>
<ul>
<li>macOS 13.0 (Ventura) or later</li>
<li>Accessibility permission required</li>
</ul>
</body>
</html>
HTML_EOF

# -------------------------------------------------------
# License screen (HTML)
# -------------------------------------------------------
cat > "${PKG_DIR}/resources/license.html" << 'HTML_EOF'
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"></head>
<body style="font-family: -apple-system, Helvetica Neue, sans-serif; font-size: 12px; line-height: 1.5;">
<h3>MIT License</h3>
<p>Copyright © 2026 Nakano Kappei</p>
<p>Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:</p>
<p>The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.</p>
<p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.</p>
</body>
</html>
HTML_EOF

# -------------------------------------------------------
# Distribution XML (defines installer screens & choices)
# -------------------------------------------------------
APP_KB=$(du -sk "${APP_PAYLOAD}" | cut -f1)
DOCS_KB=$(du -sk "${DOCS_PAYLOAD}" | cut -f1)

cat > "${PKG_DIR}/distribution.xml" << DIST_EOF
<?xml version="1.0" encoding="utf-8"?>
<installer-gui-script minSpecVersion="2">
    <title>${APP_NAME}</title>
    <welcome file="welcome.html"/>
    <license file="license.html"/>
    <options customize="allow" require-scripts="false" rootVolumeOnly="true"
             hostArchitectures="arm64,x86_64"/>
    <os-version min="13.0"/>
    <choices-outline>
        <line choice="choice-app"/>
        <line choice="choice-docs"/>
    </choices-outline>
    <choice id="choice-app"
            title="${APP_NAME}"
            description="Install ${APP_NAME}.app to /Applications."
            enabled="false"
            selected="true">
        <pkg-ref id="com.windowresize.app.pkg"/>
    </choice>
    <choice id="choice-docs"
            title="User Manuals"
            description="Install README, LICENSE, and user manuals (16 languages) to /Library/Documentation/Window Resize/."
            selected="true">
        <pkg-ref id="com.windowresize.docs.pkg"/>
    </choice>
    <pkg-ref id="com.windowresize.app.pkg"
             version="${VERSION}"
             installKBytes="${APP_KB}"
             auth="root">#app.pkg</pkg-ref>
    <pkg-ref id="com.windowresize.docs.pkg"
             version="${VERSION}"
             installKBytes="${DOCS_KB}"
             auth="root">#docs.pkg</pkg-ref>
</installer-gui-script>
DIST_EOF

# -------------------------------------------------------
# Assemble product archive
# -------------------------------------------------------
UNSIGNED_PKG="${PKG_DIR}/${APP_NAME}-unsigned.pkg"
SIGNED_PKG="${BUILD_DIR}/${APP_NAME}.pkg"

productbuild \
    --distribution "${PKG_DIR}/distribution.xml" \
    --resources "${PKG_DIR}/resources" \
    --package-path "${PKG_DIR}/components" \
    "${UNSIGNED_PKG}"

# -------------------------------------------------------
# Sign with Developer ID Installer
# -------------------------------------------------------
echo "=== Signing installer ==="
productsign \
    --sign "${INSTALLER_SIGNING_IDENTITY}" \
    "${UNSIGNED_PKG}" \
    "${SIGNED_PKG}"

rm -f "${UNSIGNED_PKG}"

# -------------------------------------------------------
# Notarize & staple
# -------------------------------------------------------
echo "=== Notarizing installer ==="
xcrun notarytool submit "${SIGNED_PKG}" \
    --keychain-profile "${NOTARYTOOL_PROFILE}" \
    --wait

echo "=== Stapling notarization ticket ==="
xcrun stapler staple "${SIGNED_PKG}"

# Clean up
rm -rf "${PKG_DIR}"

echo "=== Installer complete ==="
echo "PKG: ${SIGNED_PKG}"
