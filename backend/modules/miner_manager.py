#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
import os, json, subprocess, threading, shlex, time
from pathlib import Path
BASE = os.path.expanduser('~/.awesomeagent')
Path(BASE).mkdir(parents=True, exist_ok=True)
PROFILES_FILE = os.path.join(BASE,'miners.json')
METRICS_FILE = os.path.join(BASE,'metrics.json')

class MinerManager:
    def __init__(self):
        self._procs = {}
        self._load_profiles()

    def _load_profiles(self):
        try:
            if os.path.exists(PROFILES_FILE):
                with open(PROFILES_FILE) as f:
                    self.profiles = {p['id']:p for p in json.load(f)}
            else:
                self.profiles = {}
        except Exception:
            self.profiles = {}

    def _save_profiles(self):
        try:
            with open(PROFILES_FILE+'.tmp','w') as f:
                json.dump(list(self.profiles.values()), f, indent=2)
            os.replace(PROFILES_FILE+'.tmp', PROFILES_FILE)
        except Exception:
            pass

    def register(self, profile):
        pid = profile.get('id')
        if not pid:
            return False, 'id missing'
        self.profiles[pid] = profile
        self._save_profiles()
        return True, 'registered'

    def start(self, pid):
        if pid in self._procs:
            return False, 'already running'
        prof = self.profiles.get(pid)
        if not prof:
            return False, 'not found'
        binp = prof.get('binary')
        args = prof.get('args','') or ''
        if not os.path.exists(binp):
            return False, 'binary missing'
        cmd = shlex.split(binp) + shlex.split(args)
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        self._procs[pid]=p
        threading.Thread(target=self._drain, args=(pid,p), daemon=True).start()
        return True, f'started {p.pid}'

    def _drain(self,pid,proc):
        import re
        hr_re = re.compile(r"(\d+\.\d+)\s*MH/s", re.IGNORECASE)
        while True:
            line = proc.stdout.readline()
            if not line:
                break
            try:
                s = line.decode('utf-8',errors='ignore')
            except:
                s = str(line)
            m = hr_re.search(s)
            if m:
                val = float(m.group(1))
                self._update_metric(pid,'last_hr',val)
        proc.wait()
        self._procs.pop(pid,None)

    def _update_metric(self,pid,key,val):
        data = {}
        if os.path.exists(METRICS_FILE):
            try:
                with open(METRICS_FILE) as f:
                    data = json.load(f)
            except:
                data={}
        rec = data.get(pid,{})
        rec[key]=val
        data[pid]=rec
        try:
            with open(METRICS_FILE+'.tmp','w') as f:
                json.dump(data,f,indent=2)
            os.replace(METRICS_FILE+'.tmp', METRICS_FILE)
        except:
            pass

    def stop(self,pid):
        p = self._procs.get(pid)
        if not p:
            return False, 'not running'
        p.terminate()
        try:
            p.wait(timeout=5)
        except:
            p.kill()
        self._procs.pop(pid,None)
        return True,'stopped'

    def metrics(self):
        data = {}
        if os.path.exists(METRICS_FILE):
            try:
                with open(METRICS_FILE) as f:
                    data = json.load(f)
            except:
                data={}
        res = []
        for pid,prof in self.profiles.items():
            rec = data.get(pid,{})
            res.append({'id':pid,'name':prof.get('name'),'running': pid in self._procs,'metrics':rec})
        return {'miners':res}
