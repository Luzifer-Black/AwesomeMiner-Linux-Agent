#!/usr/bin/env python3
# SPDX-License-Identifier: MIT
import sys, os, requests
from PyQt6 import QtWidgets, QtCore
import pyqtgraph as pg
API = os.environ.get('AWESOMEAGENT_API','http://127.0.0.1:8888')
API_KEY = os.environ.get('AWESOMEAGENT_API_KEY','change_me')
class Dashboard(QtWidgets.QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle('AwesomeAgent GUI')
        self.resize(900,600)
        v=QtWidgets.QVBoxLayout()
        self.lbl = QtWidgets.QLabel('Loading...')
        v.addWidget(self.lbl)
        self.plot = pg.PlotWidget(title='Hashrate')
        v.addWidget(self.plot)
        self.setLayout(v)
        self.timer = QtCore.QTimer(); self.timer.timeout.connect(self.refresh); self.timer.start(2000)
    def refresh(self):
        try:
            r = requests.get(API + '/metrics', headers={'X-API-Key':API_KEY}, timeout=2)
            if r.status_code==200:
                j=r.json(); miners=j.get('miners',[])
                total = 0.0
                for m in miners:
                    last = m.get('metrics',{}).get('last_hr') or 0.0
                    total += float(last)
                self.lbl.setText(f"Miners: {len(miners)}  Hashrate: {total:.2f} MH/s")
        except Exception as e:
            self.lbl.setText('Backend not reachable')
if __name__=='__main__':
    app = QtWidgets.QApplication(sys.argv); w=Dashboard(); w.show(); sys.exit(app.exec())