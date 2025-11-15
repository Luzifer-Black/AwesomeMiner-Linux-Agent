#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
import os, json, logging
from fastapi import FastAPI, Header, HTTPException
from backend.modules.miner_manager import MinerManager
from tools.earnings_engine import estimate

# load env file if present
envfile = "/etc/default/awesomeagent"
if os.path.exists(envfile):
    with open(envfile) as f:
        for line in f:
            if '=' in line and not line.strip().startswith('#'):
                k,v = line.strip().split('=',1)
                os.environ.setdefault(k, v)

API_KEY = os.environ.get('AWESOMEAGENT_API_KEY','change_me')
BIND = os.environ.get('AWESOMEAGENT_BIND','127.0.0.1')
PORT = int(os.environ.get('AWESOMEAGENT_PORT','8888'))

app = FastAPI(title='AwesomeAgent Local API')

log = logging.getLogger('awesomeagent')
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')

mgr = MinerManager()

def check_key(x_api_key: str):
    if x_api_key != API_KEY:
        raise HTTPException(status_code=401, detail='Unauthorized')

@app.get('/health')
def health(): return {'status':'ok'}

@app.get('/metrics')
def metrics(x_api_key: str = Header(None)):
    check_key(x_api_key)
    return mgr.metrics()

@app.post('/miner/register')
def register(m: dict, x_api_key: str = Header(None)):
    check_key(x_api_key)
    ok,msg = mgr.register(m)
    return {'ok':ok,'msg':msg}

@app.post('/miner/start')
def start(m: dict, x_api_key: str = Header(None)):
    check_key(x_api_key)
    ok,msg = mgr.start(m.get('id'))
    return {'ok':ok,'msg':msg}

@app.post('/miner/stop')
def stop(m: dict, x_api_key: str = Header(None)):
    check_key(x_api_key)
    ok,msg = mgr.stop(m.get('id'))
    return {'ok':ok,'msg':msg}

@app.get('/earnings/{algo}/{hr}')
def earning(algo: str, hr: float, x_api_key: str = Header(None)):
    check_key(x_api_key)
    return estimate(algo, hr)

if __name__=='__main__':
    import uvicorn
    uvicorn.run(app, host=BIND, port=PORT)
