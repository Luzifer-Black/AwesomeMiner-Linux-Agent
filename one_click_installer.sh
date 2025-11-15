#!/bin/bash
set -euo pipefail
DEB_NAME="awesomeagent_1.0_amd64_osdetect.deb"
REPO="Luzifer-Black/AwesomeMiner-Linux-Agent"
GITHUB_API="https://api.github.com/repos/${REPO}/releases/latest"
TAG=$(curl -sSfL "$GITHUB_API" | grep -m1 '"tag_name":' | cut -d'"' -f4 || true)
if [ -z "$TAG" ]; then TAG="v1.0"; fi
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${TAG}/${DEB_NAME}"
echo "[one_click] Downloading ${DOWNLOAD_URL}"
if command -v curl >/dev/null 2>&1; then
  curl -fsSL -o "${DEB_NAME}" "${DOWNLOAD_URL}" || true
else
  wget -q -O "${DEB_NAME}" "${DOWNLOAD_URL}" || true
fi
if [ -f "${DEB_NAME}" ]; then
  echo "[one_click] Installing ${DEB_NAME}"
  sudo dpkg -i "${DEB_NAME}" || sudo apt-get install -fy
else
  echo "[one_click] ${DEB_NAME} not available directly; falling back to bundle install via install.sh"
  sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/Luzifer-Black/AwesomeMiner-Linux-Agent/main/installer/install.sh)"
  exit 0
fi
sudo systemctl daemon-reload
sudo systemctl enable --now awesomeminer-agent.service || true
sudo systemctl enable --now awesome-discovery.service || true
sudo systemctl enable --now awesome-auto-repair.timer || true
