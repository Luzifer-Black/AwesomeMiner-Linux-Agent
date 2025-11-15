# Install & Quickstart

1. Unzip the package on your Linux Mint / Ubuntu / Debian box:
   ```bash
   unzip awesomeagent_final_complete_v1.zip -d awesomeagent_release
   cd awesomeagent_release
   ```

2. Review and set secrets (recommended):
   - Edit `env/awesomeagent.env` to set AWESOMEAGENT_API_KEY and other values.

3. Run installer (as root):
   ```bash
   sudo ./installer/install_and_run.sh
   ```

4. Verify services:
   ```bash
   sudo systemctl status awesomeminer-backend.service
   systemctl list-timers | grep awesomeminer
   ```

5. Start GUI (as normal user):
   ```bash
   python3 /opt/awesomeagent/gui/main.py
   ```

Security checklist:
- Change API key in `/etc/default/awesomeagent` or edit systemd EnvironmentFile.
- If enabling remote access, secure with TLS and firewall rules.
