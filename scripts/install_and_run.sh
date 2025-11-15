#!/usr/bin/env bash
set -euo pipefail
if [ "$(id -u)" -ne 0 ]; then echo "Bitte mit sudo ausführen"; exit 1; fi
ROOT_DIR="/opt/awesomeagent"
SRC_DIR="$(pwd)"
echo "Copying files to $ROOT_DIR ..."
mkdir -p "$ROOT_DIR"
rsync -a --delete "$SRC_DIR/." "$ROOT_DIR/"
echo "Creating python venv and installing requirements..."
python3 -m venv "$ROOT_DIR/.venv"
"$ROOT_DIR/.venv/bin/pip" install --upgrade pip
"$ROOT_DIR/.venv/bin/pip" install -r "$ROOT_DIR/requirements.txt" || true
echo "Creating system user 'awesomeagent'..."
if ! id -u awesomeagent >/dev/null 2>&1; then
  useradd --system --home "$ROOT_DIR" --shell /usr/sbin/nologin awesomeagent || true
fi
chown -R awesomeagent:awesomeagent "$ROOT_DIR"
echo "Installing systemd unit..."
cp -f "$ROOT_DIR/systemd/awesomeminer-backend.service" /etc/systemd/system/awesomeminer-backend.service || true
cp -f "$ROOT_DIR/systemd/auto-update.service" /etc/systemd/system/awesomeminer-auto-update.service || true
cp -f "$ROOT_DIR/systemd/auto-update.timer" /etc/systemd/system/awesomeminer-auto-update.timer || true
cp -f "$ROOT_DIR/systemd/auto-repair.service" /etc/systemd/system/awesomeminer-auto-repair.service || true
cp -f "$ROOT_DIR/systemd/auto-repair.timer" /etc/systemd/system/awesomeminer-auto-repair.timer || true
systemctl daemon-reload || true
systemctl enable --now awesomeminer-backend.service || true
systemctl enable --now awesomeminer-auto-update.timer || true
systemctl enable --now awesomeminer-auto-repair.timer || true
echo "Done. Backend enabled and auto-update/repair timers set."
