#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
import sys, requests, os, json
def fetch(addr):
    url = f'https://www.zpool.ca/api/walletEX?address={addr}'
    r = requests.get(url, timeout=10); r.raise_for_status(); return r.json()
def update(project_path, addr):
    data = fetch(addr)
    paid24 = data.get('paid24h') or data.get('paid_24h') or None
    print('paid24 raw:', paid24)
    # no auto-change here; report only
    report = os.path.join(project_path, 'tools', 'zpool_report.json')
    with open(report, 'w') as f:
        json.dump(data, f, indent=2)
    print('Report saved to', report)
if __name__=='__main__':
    if len(sys.argv)<3:
        print('Usage: python3 tools/zpool_update.py ADDRESS /path/to/project')
        sys.exit(2)
    update(sys.argv[2], sys.argv[1])
