#!/usr/bin/env bash
set -euo pipefail
if [ "$(id -u)" -ne 0 ]; then echo 'Use sudo to run this installer.'; exit 1; fi
ROOT=/opt/awesomeagent
SRC=$(pwd)
echo 'Installing AwesomeAgent into' $ROOT
mkdir -p $ROOT
rsync -a --delete "$SRC/" "$ROOT/"
python3 -m venv $ROOT/.venv
$ROOT/.venv/bin/pip install --upgrade pip
$ROOT/.venv/bin/pip install -r $ROOT/requirements.txt || true
if ! id -u awesomeagent >/dev/null 2>&1; then useradd --system --home $ROOT --shell /usr/sbin/nologin awesomeagent || true; fi
chown -R awesomeagent:awesomeagent $ROOT || true
cp -f systemd/awesomeminer-backend.service /etc/systemd/system/awesomeminer-backend.service || true
cp -f systemd/auto-update.service /etc/systemd/system/awesomeminer-auto-update.service || true
cp -f systemd/auto-update.timer /etc/systemd/system/awesomeminer-auto-update.timer || true
cp -f systemd/auto-repair.service /etc/systemd/system/awesomeminer-auto-repair.service || true
cp -f systemd/auto-repair.timer /etc/systemd/system/awesomeminer-auto-repair.timer || true
systemctl daemon-reload || true
systemctl enable --now awesomeminer-backend.service || true
systemctl enable --now awesomeminer-auto-update.timer || true
systemctl enable --now awesomeminer-auto-repair.timer || true
echo 'Installer finished. Backend service enabled.'
