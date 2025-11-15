# AwesomeAgent Linux — Final Complete Package (v1.1)
This package is prepared to be a turnkey Linux agent + GUI environment for managing miners locally on Linux Mint / Debian/Ubuntu.
It contains fully functional scripts, systemd units, auto-update & auto-repair, signing helpers, CI workflow and example miner wrappers.

IMPORTANT LIMITATIONS (must read):
- This package does NOT contain proprietary miner binaries (e.g., XMRig, T-Rex). Placeholder wrappers are included; you must download official miner binaries yourself or run the provided installers which fetch them from upstream releases.
- Auto-update downloads release assets from GitHub; network connectivity required and you must ensure release asset names match the script expectations.
- GPG signing/verification requires you to supply your own GPG key or set up CI secrets (instructions below).
- Test in a virtual machine before using on production.

See docs/INSTALL.md for step-by-step install and usage examples.
