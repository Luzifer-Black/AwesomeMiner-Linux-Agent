#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Auto-repair script: check backend and restart, attempt to reinstall missing deps
SERVICE=awesomeminer-backend.service
LOG=/var/log/awesomeagent_repair.log
echo "$(date) - Auto-Repair started" >> $LOG
systemctl is-active --quiet $SERVICE || {
  echo "$(date) - Service $SERVICE not active, attempting restart" >> $LOG
  systemctl restart $SERVICE && echo "$(date) - Restarted $SERVICE" >> $LOG || echo "$(date) - Restart failed" >> $LOG
}
# check python deps by running a small python check
python3 - <<'PY' >> $LOG 2>&1
import importlib, sys
reqs = ['fastapi','requests']
missing = []
for r in reqs:
    try:
        importlib.import_module(r)
    except Exception:
        missing.append(r)
if missing:
    print('MISSING:'+','.join(missing))
else:
    print('OK')
PY
if grep -q '^MISSING:' $LOG; then
  echo "$(date) - Missing packages detected, trying to install..." >> $LOG
  apt update && apt install -y python3-pip || true
  pip3 install -U $(grep '^MISSING:' $LOG | sed 's/MISSING://' | tr ',' ' ') >> $LOG 2>&1 || true
  systemctl restart $SERVICE || true
fi
echo "$(date) - Auto-Repair finished" >> $LOG
