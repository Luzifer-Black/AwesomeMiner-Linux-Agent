# 🚀 AwesomeMiner Linux Agent – Release v1.0

Dies ist das offizielle Release des **AwesomeMiner Linux Agent** für Linux Mint, Ubuntu und Debian-basierte Systeme.  
Enthalten sind:

- 🟢 One-Click Installer (ZIP)
- 🟢 .deb Paket (vollautomatische Installation)
- 🟢 Auto-Update-System
- 🟢 Auto-Repair-Mechanismus
- 🟢 LAN Auto-Discovery
- 🟢 Firewall-Konfiguration
- 🟢 Systemd-Dienst mit Autostart
- 🟢 Original Awesomeminer RemoteAgent Binary (extrahiert aus tar.xz)
- 🟢 Voll kompatibel mit AwesomeMiner Windows Management Software

---

# 📦 Downloads (Release v1.0)

| Datei | Download |
|-------|----------|
| 🔧 One-Click Installer ZIP | **https://github.com/Luzifer-Black/AwesomeMiner-Linux-Agent/releases/download/v1.0/awesomeagent-installer.zip** |
| 📦 Debian Paket (.deb) | **https://github.com/Luzifer-Black/AwesomeMiner-Linux-Agent/releases/download/v1.0/awesomeagent_1.0_amd64.deb** |
| 🛠 Quellcode | GitHub „Source code (zip/tar.gz)“ Button |

---

# 🚀 One-Click Installation (am einfachsten)

Einfach diesen EINEN Befehl ausführen:

```bash
sudo bash -c "$(curl -fsSL https://github.com/Luzifer-Black/AwesomeMiner-Linux-Agent/releases/download/v1.0/awesomeagent-installer.zip)"

Oder manuell:

wget https://github.com/Luzifer-Black/AwesomeMiner-Linux-Agent/releases/download/v1.0/awesomeagent-installer.zip
unzip awesomeagent-installer.zip
sudo ./install.sh

Linux-Version | Status
-- | --
Linux Mint 20 / 21 | 🟢 Voll unterstützt
Ubuntu 20.04+ | 🟢 Voll unterstützt
Debian 11 / 12 | 🟠 Teilweise getestet
Arch / Manjaro | 🔴 Nicht unterstützt

Feature | Beschreibung
-- | --
Auto-Install | Erkennt OS, installiert Agent & Dienste automatisch
Auto-Update | Prüft GitHub Releases täglich
Auto-Repair | Repariert beschädigte Installationen selbstständig
LAN Auto-Discovery | Ermöglicht automatische Erkennung durch Windows AwesomeMiner
Firewall-Setup | Öffnet Ports 9630 und 9631
Systemd-Service | Startet Agent automatisch beim Systemstart
Original Binary | Echtes Awesomeminer Agent Binary integriert
Logging | Logs unter /var/log/awesomeagent/agent.log

🛠 Systemd-Dienst
Dienst starten
sudo systemctl start awesomeagent

Autostart aktivieren
sudo systemctl enable awesomeagent

Dienststatus prüfen
sudo systemctl status awesomeagent

Live-Logs ansehen
journalctl -u awesomeagent -f

Port | Zweck
-- | --
9630 | Remote Agent Kommunikation
9631 | Auto-Discovery / Monitoring

Falls UFW manuell aktiviert ist:

sudo ufw allow 9630
sudo ufw allow 9631

Agent erscheint nicht in AwesomeMiner | Gerät nicht im gleichen LAN | Prüfen: beide Geräte im selben Netzwerk (LAN/WLAN)
Dienst startet nicht | Rechte oder beschädigte Installation | sudo systemctl restart awesomeagent
Installer startet nicht | Datei nicht ausführbar | chmod +x install.sh
Update funktioniert nicht | GitHub nicht erreichbar | ping github.com
Keine Verbindung | Firewall blockiert | sudo ufw allow 9630/9631

📜 Changelog – Version 1.0

Erstes vollständiges Linux Release

One-Click-Installer hinzugefügt

Auto-Update integriert

Auto-Repair eingebaut

Auto-Discovery über LAN aktiviert

Firewall-Setup automatisiert

Original Awesomeminer Agent Binary integriert

Systemd-Agent-Service erstellt

GitHub-Release-Struktur optimiert

🗂 Projektstruktur

AwesomeMiner-Linux-Agent/
├── installer/
│   ├── install.sh
│   ├── auto_update.sh
│   ├── auto_repair.sh
│   └── awesomeagent (Binary)
├── deb/
│   ├── DEBIAN/control
│   ├── usr/bin/awesomeagent
│   └── lib/systemd/system/awesomeagent.service
├── README.md


❤️ Support & Feedback

Bei Problemen oder Feature-Wünschen einfach ein Issue öffnen:

👉 https://github.com/Luzifer-Black/AwesomeMiner-Linux-Agent/issues

Danke, dass du den AwesomeMiner Linux Agent verwendest!
