#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
import requests
COINGECKO = {'LTC':'litecoin','ETH':'ethereum','XMR':'monero'}
ALGO = {'scrypt':0.00010224100558659218,'ethash':0.0012,'randomx':0.00002}
def fetch_price(sym):
    cid = COINGECKO.get(sym.upper()); 
    if not cid: return None
    try:
        r = requests.get(f'https://api.coingecko.com/api/v3/simple/price?ids={cid}&vs_currencies=usd', timeout=5); r.raise_for_status(); j=r.json(); return j.get(cid,{}).get('usd')
    except:
        return None
def estimate(algo, hr_mh):
    rate = ALGO.get(algo.lower(), 0.00001)
    usd_day = hr_mh * rate * 24.0
    return {'usd_per_day': usd_day, 'usd_per_hour': usd_day/24.0}
