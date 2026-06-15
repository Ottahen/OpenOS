# OpenOS Troubleshooting Guide

## Common Issues and Solutions

### Installation Issues

#### Installer fails with "Package not found"
```bash
# Update package lists
sudo apt update

# Run installer again
sudo bash openos-setup.sh
```

#### Brave/VS Code repository errors
```bash
# Fix GPG keys
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $(apt-get update 2>&1 | grep -o '[0-9A-Z]\{16\}$' | sort -u)

# Re-run installer
sudo bash openos-setup.sh
```

---

### Display & Graphics Issues

#### No blur effects / transparency not working
**Cause:** Picom compositor not running or GPU driver issue

**Solution 1: Check Picom**
```bash
# Check if picom is running
pgrep picom

# Start manually
picom --config ~/.config/picom/picom.conf -b

# If errors, try xrender backend
sed -i 's/backend = "glx"/backend = "xrender"/' ~/.config/picom/picom.conf
picom --config ~/.config/picom/picom.conf -b
```

**Solution 2: Check GPU Drivers**
```bash
# NVIDIA
ubuntu-drivers devices
sudo ubuntu-drivers autoinstall

# AMD/Intel (usually works out-of-box)
# Ensure mesa is installed
sudo apt install mesa-utils
```

#### Screen tearing
```bash
# Add to picom config
# ~/.config/picom/picom.conf
vsync = true;
```

#### Rounded corners not showing
```bash
# Ensure mutter or compton supports corners
# Try installing picom-rounded-corners fork
cd /tmp
git clone https://github.com/ibhagwan/picom.git
cd picom
meson setup build
ninja -C build
sudo ninja -C build install
```

---

### Theme Issues

#### Theme not applying after login
```bash
# Run desktop configuration manually
bash /etc/xdg/openos-desktop.sh

# Or set manually
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"
gsettings set org.gnome.desktop.interface icon-theme "WhiteSur-dark"
```

#### Icons missing or broken
```bash
# Rebuild icon cache
sudo gtk-update-icon-cache -f /usr/share/icons/WhiteSur-dark/
sudo gtk-update-icon-cache -f /usr/share/icons/WhiteSur/

# Restart GNOME Shell (X11 only)
killall gnome-shell
```

#### Font looks wrong
```bash
# Install Inter font if missing
sudo apt install fonts-inter

# Reset font cache
fc-cache -f -v
```

---

### Application Issues

#### Brave won't start
```bash
# Check for lock file
rm ~/.config/BraveSoftware/Brave-Browser/SingletonLock 2>/dev/null

# Reset Brave (keeps bookmarks)
brave-browser --disable-gpu

# If still broken, reinstall
sudo apt reinstall brave-browser
```

#### VS Code extensions not working
```bash
# Fix permissions
sudo chown -R $(whoami) ~/.vscode

# Clear extension cache
rm -rf ~/.vscode/extensions/*/.obsolete
```

#### OnlyOffice won't open files
```bash
# Fix MIME associations
xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.openxmlformats-officedocument.wordprocessingml.document
xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
xdg-mime default onlyoffice-desktopeditors.desktop application/vnd.openxmlformats-officedocument.presentationml.presentation
```

#### Ollama not responding
```bash
# Check service status
systemctl status ollama

# Restart service
sudo systemctl restart ollama

# Test with a small model
ollama pull tinyllama
ollama run tinyllama
```

---

### Performance Issues

#### System feels slow
```bash
# Check resource usage
htop

# Disable heavy effects
# Edit ~/.config/picom/picom.conf:
# blur-background = false;
# animations = false;
# shadow = false;

# Reduce swappiness
echo 'vm.swappiness=5' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

#### High RAM usage
```bash
# Check what's using RAM
ps aux --sort=-%mem | head -20

# Disable preload if not needed
sudo systemctl stop preload
sudo systemctl disable preload

# Clear caches (temporary)
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches
```

#### Boot time too long
```bash
# Analyze boot
systemd-analyze blame

# Disable unnecessary services
sudo systemctl disable bluetooth
sudo systemctl disable cups
sudo systemctl disable cups-browsed
```

---

### Dock & Launcher Issues

#### Plank dock not showing
```bash
# Start Plank
plank &

# Check if autostart is enabled
ls ~/.config/autostart/ | grep plank

# Add to autostart if missing
ln -s /usr/share/applications/plank.desktop ~/.config/autostart/
```

#### Rofi launcher not opening
```bash
# Test Rofi directly
rofi -show drun

# Check xbindkeys
xbindkeys --defaults > ~/.xbindkeysrc
killall xbindkeys 2>/dev/null
xbindkeys

# Or use alternative shortcut
# Edit ~/.xbindkeysrc and change Mod4+space to Mod4+d
```

#### Dock icons too small/large
```bash
# Edit Plank settings
nano ~/.config/plank/dock1/settings

# Change:
# IconSize=48
# dash-max-icon-size=48

# Restart Plank
killall plank
plank &
```

---

### Workspace & Window Management

#### Workspaces not working
```bash
# Enable workspaces in GNOME
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
gsettings set org.gnome.shell.app-switcher current-workspace-only true

# For Cinnamon
gsettings set org.cinnamon.desktop.wm.preferences num-workspaces 4
```

#### Window buttons missing (close/minimize/maximize)
```bash
# Restore buttons
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
```

---

### Security & Privacy

#### Firewall blocking legitimate traffic
```bash
# Check UFW status
sudo ufw status verbose

# Allow specific ports
sudo ufw allow 8080/tcp  # Development server
sudo ufw allow 3000/tcp  # React/Vue dev
sudo ufw allow 5173/tcp  # Vite dev

# Disable if needed (not recommended)
sudo ufw disable
```

#### AppArmor blocking apps
```bash
# Check AppArmor status
sudo aa-status

# Set to complain mode for specific app
sudo aa-complain /path/to/app

# Or disable (not recommended)
sudo systemctl stop apparmor
sudo systemctl disable apparmor
```

---

### Update Issues

#### System updates break theme
```bash
# Re-run theme installer
cd ~/openos
sudo bash openos-setup.sh --theme-only

# Or manually reset
gsettings reset-recursively org.gnome.desktop.interface
bash /etc/xdg/openos-desktop.sh
```

#### Brave/VS Code updates fail
```bash
# Fix repository
sudo apt update --fix-missing
sudo apt --fix-broken install

# If still broken, remove and re-add repos
sudo rm /etc/apt/sources.list.d/brave-browser-release.list
sudo rm /etc/apt/sources.list.d/vscode.list
# Then re-run installer
```

---

### Recovery

#### Complete reset to defaults
```bash
# Reset all GNOME settings
gsettings reset-recursively org.gnome.desktop.interface
gsettings reset-recursively org.gnome.desktop.wm.preferences
gsettings reset-recursively org.gnome.shell.extensions.dash-to-dock

# Remove custom configs
rm -rf ~/.config/plank
rm -rf ~/.config/rofi
rm -rf ~/.config/picom
rm -rf ~/.themes
rm -rf ~/.icons

# Reboot
sudo reboot
```

#### Reinstall OpenOS completely
```bash
# Backup your data first!
# Then re-run installer
sudo bash openos-setup.sh --full-reset
```

---

## Getting Help

If none of these solutions work:

1. **Check the log file:**
   ```bash
   cat /var/log/openos-install.log
   ```

2. **Open an issue on GitHub** with:
   - Ubuntu version (`lsb_release -a`)
   - Hardware info (`neofetch`)
   - Error messages
   - Steps to reproduce

3. **Join the community:**
   - Discord: [discord.gg/openos](https://discord.gg/openos)
   - Reddit: r/openos
   - Matrix: #openos:matrix.org

---

<div align="center">

**Still stuck?** We're here to help! 💜

</div>
