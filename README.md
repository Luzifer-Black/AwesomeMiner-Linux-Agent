# 📘 **AwesomeMiner Linux Agent**
Remote Agent für Linux Mint, Ubuntu & Debian – kompatibel mit AwesomeMiner (Windows)

## 🚀 One‑Click Installation
```bash
bash <(curl -s https://raw.githubusercontent.com/Luzifer-Black/AwesomeMiner-Linux-Agent/main/installer/install.sh)
```

## 🔧 Einzelbefehle
```bash
git clone https://github.com/Luzifer-Black/AwesomeMiner-Linux-Agent.git
cd AwesomeMiner-Linux-Agent
sudo bash installer/install.sh
```

## 🛠 Systemd
```bash
sudo systemctl enable --now awesomeminer-agent.service
sudo systemctl enable --now awesomeagent-autoupdate.timer
sudo systemctl enable --now awesomeagent-autorepair.service
sudo systemctl enable --now awesomeagent-discovery.service
```

## 🔥 Firewall
```bash
sudo ufw allow 9630/tcp
sudo ufw allow 34400/udp
sudo ufw reload
```

## 📦 deb Installation
```bash
sudo dpkg -i awesomeagent_1.0_amd64.deb
sudo apt --fix-broken install -y
```

## 🧹 Deinstallation
```bash
sudo bash uninstall.sh
```
