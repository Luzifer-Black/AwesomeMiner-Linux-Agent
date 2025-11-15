#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
import shutil, subprocess, json
def has(cmd): import shutil; return shutil.which(cmd) is not None
def nvidia(): 
    if not has('nvidia-smi'): return {'ok':False}
    try:
        out = subprocess.check_output(['nvidia-smi','--query-gpu=index,name,temperature.gpu,utilization.gpu','--format=csv,noheader,nounits'], text=True)
        lines = [l.strip().split(',') for l in out.strip().splitlines()]
        return {'ok':True,'gpus':lines}
    except Exception as e:
        return {'ok':False,'err':str(e)}
if __name__=='__main__':
    print(json.dumps({'nvidia':nvidia()}, indent=2))
