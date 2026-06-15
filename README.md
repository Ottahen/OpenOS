# OpenOS / bNode

> A glassmorphic, Apple-inspired Linux desktop experience built on Ubuntu LTS.

![OpenOS Desktop](docs/screenshot-preview.png)

## What is OpenOS?

**OpenOS (bNode)** is a complete desktop environment customization for Ubuntu Linux that delivers:
- 🎨 **Glassmorphic UI** — Frosted glass effects, blur, rounded corners
- 🍎 **Apple-like Experience** — Dock, smooth animations, clean aesthetics
- ⚡ **Fast & Lightweight** — Optimized for daily productivity
- 🔒 **Privacy-First** — No telemetry, hardened security
- 🚀 **Pre-Configured Apps** — Brave, VS Code, OnlyOffice, Ollama

**This is NOT a new operating system.** It is a professionally configured Ubuntu setup with custom themes, scripts, and optimizations that you can install in minutes.

---

## Quick Start

### Method 1: Native Install (Recommended)

```bash
# 1. Install fresh Ubuntu 22.04/24.04 LTS
# 2. Download and extract OpenOS
git clone https://github.com/yourusername/openos.git
cd openos

# 3. Run the installer
sudo bash openos-setup.sh

# 4. Reboot and enjoy
sudo reboot
```

### Method 2: Docker

```bash
# Build the Docker image
docker build -t openos-bnode:latest .

# Run it
docker run -it   -e DISPLAY=$DISPLAY   -v /tmp/.X11-unix:/tmp/.X11-unix   openos-bnode:latest
```

### Method 3: Virtual Machine

1. Install Ubuntu 22.04 LTS in VirtualBox/VMware
2. Run `openos-setup.sh`
3. Snapshot the VM for instant reuse

---

## Features

### Desktop Environment
| Feature | Description |
|---------|-------------|
| **Glassmorphic Theme** | Frosted glass panels with subtle blur and transparency |
| **Dynamic Dock** | Apple-style Plank dock with glassmorphic theme |
| **App Launcher** | Spotlight-style Rofi launcher with blur effects |
| **Clock Widget** | Beautiful desktop clock with weather hints |
| **System Monitor** | Glassmorphic Conky widget showing CPU/RAM/Network |
| **Theme Switcher** | One-click toggle between Light and Dark modes |

### Pre-Installed Applications
| App | Purpose |
|-----|---------|
| **Brave Browser** | Privacy-focused web browsing (default browser) |
| **VS Code** | Code editing and development |
| **OnlyOffice** | Document editing (Word/Excel/PowerPoint compatible) |
| **Ollama** | Local AI model running (Llama, Mistral, etc.) |
| **Terminal** | GNOME Terminal with custom styling |
| **File Manager** | Nautilus with glassmorphic tweaks |

### Security & Privacy
- ✅ UFW firewall enabled by default
- ✅ AppArmor mandatory access control
- ✅ Automatic security updates
- ✅ No telemetry (Ubuntu Report removed)
- ✅ No crash reporting (Apport disabled)
- ✅ Hardened kernel parameters
- ✅ Secure defaults for network settings

### Performance Optimizations
- ⚡ zRAM compressed swap for better memory usage
- ⚡ TLP power management for laptops
- ⚡ Preload for faster app startup
- ⚡ Optimized swappiness (10 instead of 60)
- ⚡ Reduced unnecessary background services

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Super + Space` | App Launcher (Spotlight-style) |
| `Super + Enter` | Terminal |
| `Super + E` | File Manager |
| `Super + B` | Brave Browser |
| `Super + 1/2/3/4` | Switch Workspaces |
| `Super + L` | Lock Screen |
| `Super + T` | Theme Switcher (Light/Dark) |
| `Super + Q` | Close Window |
| `Super + M` | Maximize Window |
| `Super + N` | Minimize Window |

---

## Project Structure

```
openos/
├── core/                  # Core system configurations
│   ├── font-config.xml   # Font aliases (SF Pro → Inter)
│   └── sysctl-hardening.conf
├── ui/                    # User interface components
│   ├── dock/             # Plank dock themes
│   ├── launcher/         # Rofi configurations
│   ├── clock-widget/     # Desktop clock widget
│   └── system-monitor.conkyrc
├── scripts/               # Utility scripts
│   ├── generate-wallpapers.py
│   ├── theme-switcher.sh
│   └── openos-welcome.sh
├── themes/                # GTK themes and icons
│   ├── gtk/              # OpenOS glassmorphic GTK theme
│   ├── icons/            # Icon theme overrides
│   └── wallpapers/       # Generated wallpapers
├── apps/                  # App-specific configurations
│   ├── brave/            # Brave browser policies
│   ├── vscode/           # VS Code settings
│   └── onlyoffice/       # OnlyOffice templates
├── docs/                  # Documentation
│   ├── installed-packages.txt
│   ├── ROADMAP.md
│   └── TROUBLESHOOTING.md
├── openos-setup.sh       # Main installer script
├── Dockerfile            # Docker image definition
└── README.md             # This file
```

---

## System Requirements

### Minimum
- **CPU:** 2-core processor (x86_64)
- **RAM:** 4 GB
- **Storage:** 20 GB free space
- **GPU:** Any GPU with OpenGL 3.0+ support
- **OS:** Ubuntu 22.04 LTS or 24.04 LTS

### Recommended
- **CPU:** 4-core processor or better
- **RAM:** 8 GB or more
- **Storage:** 40 GB SSD
- **GPU:** Dedicated GPU for best blur effects
- **Display:** 1080p or higher

---

## Post-Install Setup

After running the installer and rebooting:

1. **Log in** to your desktop
2. **Run the welcome script** (appears automatically):
   ```bash
   openos-welcome
   ```
3. **Customize your dock** — Right-click Plank → Preferences
4. **Set up Ollama** (optional):
   ```bash
   ollama pull llama3
   ollama run llama3
   ```
5. **Enjoy your glassmorphic desktop!**

---

## Troubleshooting

### Blur effects not working?
- Ensure you have a compositor running: `picom --config ~/.config/picom/picom.conf`
- Check GPU drivers are installed
- Try switching to `xrender` backend in picom config

### Theme not applying?
- Run: `bash /etc/xdg/openos-desktop.sh`
- Or log out and log back in

### Brave not default browser?
- Run: `xdg-settings set default-web-browser brave-browser.desktop`

### Performance issues on old hardware?
- Disable blur: Edit `~/.config/picom/picom.conf` → set `blur-background = false`
- Reduce animations: Set `animations = false` in picom config
- Switch to lighter theme: Use `OpenOS-Light` instead of `WhiteSur-Dark`

---

## Roadmap

### v1.1 (Next)
- [ ] Custom ISO builder (Cubic integration)
- [ ] More wallpaper variants
- [ ] Weather API integration for clock widget
- [ ] Additional app presets (Discord, Spotify, etc.)

### v1.2
- [ ] Wayland support (for newer Ubuntu versions)
- [ ] Custom notification daemon
- [ ] AI assistant integration (local LLM chat UI)
- [ ] Better multi-monitor support

### v2.0 (Future)
- [ ] Custom package manager (bNode PM)
- [ ] Kernel-level optimizations
- [ ] ARM64 support (Raspberry Pi, Apple Silicon)
- [ ] Enterprise deployment tools

---

## Contributing

We welcome contributions! Areas where help is needed:
- 🎨 **Theme improvements** — Better glassmorphic CSS
- 🐛 **Bug fixes** — Test on different hardware
- 📖 **Documentation** — Translations, guides
- 🧪 **Testing** — VM images, hardware compatibility

---

## License

OpenOS / bNode is released under the **MIT License**.

Third-party components:
- WhiteSur theme: GPL v3
- Brave Browser: MPL 2.0
- VS Code: MIT
- OnlyOffice: AGPL v3
- Ollama: MIT

---

## Credits

- **UI Design:** Inspired by macOS, Windows 11, and various Linux ricing communities
- **Themes:** Based on [WhiteSur](https://github.com/vinceliuice/WhiteSur-gtk-theme) by vinceliuice
- **Glassmorphic Effects:** CSS backdrop-filter techniques
- **Community:** r/unixporn, r/linuxmasterrace, GitHub contributors

---

<div align="center">

**Made with 💜 for the Linux community**

[Report Bug](https://github.com/yourusername/openos/issues) • [Request Feature](https://github.com/yourusername/openos/issues) • [Discord](https://discord.gg/openos)

</div>
