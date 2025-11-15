#!/bin/bash
set -euo pipefail
REPO="Luzifer-Black/AwesomeMiner-Linux-Agent"
ASSET_BUNDLE="awesomeagent_final_bundle.zip"
ASSET_DEB_PREFIX="awesomeagent_"
GITHUB_API="https://api.github.com/repos/${REPO}/releases/latest"

echo "[install.sh] Detecting latest release tag from GitHub..."
TAG=$(curl -sSfL "$GITHUB_API" | grep -m1 '"tag_name":' | cut -d'"' -f4 || true)
if [ -z "$TAG" ]; then
  echo "[install.sh] Could not detect latest tag, defaulting to v1.0"
  TAG="v1.0"
fi
echo "[install.sh] Latest tag: $TAG"

DOWNLOAD_BASE="https://github.com/${REPO}/releases/download/${TAG}"

TMP=$(mktemp -d)
cd "$TMP"

echo "[install.sh] Downloading bundle from $DOWNLOAD_BASE/${ASSET_BUNDLE} ..."
if command -v curl >/dev/null 2>&1; then
  curl -fsSL -o bundle.zip "${DOWNLOAD_BASE}/${ASSET_BUNDLE}" || { echo "Bundle not found at ${DOWNLOAD_BASE}/${ASSET_BUNDLE}"; exit 2; }
else
  wget -q -O bundle.zip "${DOWNLOAD_BASE}/${ASSET_BUNDLE}" || { echo "Bundle not found"; exit 2; }
fi

unzip -o bundle.zip || true

# prefer deb file named with osdetect suffix, fallback to any awesomeagent_*.deb
DEB_FILE=$(ls awesomeagent_*.deb 2>/dev/null | grep _osdetect || true)
if [ -z "$DEB_FILE" ]; then DEB_FILE=$(ls awesomeagent_*.deb 2>/dev/null | head -n1 || true); fi
if [ -z "$DEB_FILE" ]; then
  echo "[install.sh] No .deb found in bundle; attempting to download from release directly..."
  # try to download a deb asset if present matching prefix
  # list assets via GitHub API
  ASSET_URL=$(curl -sSfL "https://api.github.com/repos/${REPO}/releases/tags/${TAG}" | grep browser_download_url | grep "${ASSET_DEB_PREFIX}" | head -n1 | cut -d'"' -f4 || true)
  if [ -n "$ASSET_URL" ]; then
    echo "[install.sh] Found asset: $ASSET_URL"
    curl -fsSL -o package.deb "$ASSET_URL"
    DEB_FILE="package.deb"
  else
    echo "[install.sh] No deb asset found in release. Aborting."
    exit 3
  fi
fi

echo "[install.sh] Installing $DEB_FILE ..."
sudo dpkg -i "$DEB_FILE" || sudo apt-get install -fy

echo "[install.sh] Enabling services..."
sudo systemctl daemon-reload || true
sudo systemctl enable --now awesomeminer-agent.service || true
sudo systemctl enable --now awesome-discovery.service || true
sudo systemctl enable --now awesome-auto-repair.timer || true

echo "[install.sh] Ensuring firewall rules (RFC1918 ranges)"
if command -v ufw >/dev/null 2>&1; then
  sudo ufw allow from 192.168.0.0/16 to any port 9630 proto tcp || true
  sudo ufw allow from 10.0.0.0/8 to any port 9630 proto tcp || true
  sudo ufw allow from 172.16.0.0/12 to any port 9630 proto tcp || true
fi

echo "[install.sh] Cleaning up..."
cd /tmp; rm -rf "$TMP"
echo "[install.sh] Installation complete. Check: sudo systemctl status awesomeminer-agent.service"
