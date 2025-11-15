#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Auto-update script: fetch latest release zip from GitHub and unpack to /opt/awesomeagent
REPO="Luzifer-Black/AwesomeMiner-Linux-Agent"
INSTALL_DIR="/opt/awesomeagent"
TMPDIR=$(mktemp -d)
echo "Checking latest release for $REPO..."
TAG=$(curl -s https://api.github.com/repos/$REPO/releases/latest | jq -r .tag_name)
if [ -z "$TAG" ] || [ "$TAG" = "null" ]; then
  echo "No release found"; exit 1
fi
echo "Latest tag: $TAG"
ASSET="awesomeagent_release_final_v${TAG#v}.zip"
URL="https://github.com/$REPO/releases/download/$TAG/$ASSET"
echo "Downloading $URL ..."
curl -L -f -o "$TMPDIR/update.zip" "$URL" || { echo 'Download failed'; rm -rf "$TMPDIR"; exit 2; }
unzip -o "$TMPDIR/update.zip" -d "$TMPDIR/unpacked"
# optional: verification step if signature exists (not mandatory)
if curl -s --head --fail "https://github.com/$REPO/releases/download/$TAG/$ASSET.asc" >/dev/null 2>&1; then
  curl -L -o "$TMPDIR/update.zip.asc" "https://github.com/$REPO/releases/download/$TAG/$ASSET.asc"
  gpg --verify "$TMPDIR/update.zip.asc" "$TMPDIR/update.zip" || { echo 'GPG verify failed'; rm -rf "$TMPDIR"; exit 3; }
fi
# copy files
echo "Installing to $INSTALL_DIR (backup existing) ..."
if [ -d "$INSTALL_DIR" ]; then
  cp -a "$INSTALL_DIR" "$INSTALL_DIR.bak_$(date +%s)"
fi
mkdir -p "$INSTALL_DIR"
cp -a "$TMPDIR/unpacked/." "$INSTALL_DIR/"
chown -R root:root "$INSTALL_DIR"
echo "Update applied. Cleaning up..."
rm -rf "$TMPDIR"
