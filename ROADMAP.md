# OpenOS / bNode Roadmap

## Version History

### v1.0.0 (Current) — "Glassmorphic"
**Release Date:** June 2026
**Status:** ✅ Stable

**Features:**
- Ubuntu 22.04/24.04 LTS base
- Glassmorphic GTK theme with blur effects
- WhiteSur icon and cursor themes
- Plank dock with glassmorphic theme
- Rofi launcher with spotlight-style search
- Desktop clock widget
- System monitor (Conky)
- Pre-installed: Brave, VS Code, OnlyOffice, Ollama
- Theme switcher (Light/Dark)
- Security hardening (UFW, AppArmor, sysctl)
- Performance optimizations (zRAM, TLP, preload)
- Docker support

---

## Future Versions

### v1.1.0 — "Refined"
**Target:** Q3 2026
**Focus:** Polish and customization

- [ ] **Custom ISO Builder**
  - Integrate with Cubic for bootable ISO creation
  - One-command ISO generation: `openos-build-iso`
  - Preseed configuration for unattended installs

- [ ] **Expanded Wallpaper Collection**
  - 10+ generated wallpapers (cloud, space, abstract, nature)
  - Dynamic wallpaper based on time of day
  - User wallpaper upload tool

- [ ] **Weather Integration**
  - Real-time weather in clock widget
  - Location-based auto-detection
  - Weather-based theme suggestions

- [ ] **Additional App Presets**
  - Development pack: Docker, Node.js, Python, Go
  - Creative pack: GIMP, Inkscape, Blender
  - Social pack: Discord, Telegram, Signal
  - Media pack: Spotify, VLC, OBS

- [ ] **Better Multi-Monitor Support**
  - Per-monitor wallpaper
  - Dock positioning per monitor
  - Workspace spanning options

- [ ] **Accessibility Improvements**
  - High contrast theme variant
  - Larger text option
  - Screen reader optimizations

---

### v1.2.0 — "Modern"
**Target:** Q4 2026
**Focus:** Modern Linux features

- [ ] **Wayland Support**
  - Full Wayland compatibility (Ubuntu 24.04+)
  - Fractional scaling support
  - Better touchpad gestures

- [ ] **Custom Notification Daemon**
  - Replace dunst with OpenOS Notifications
  - Glassmorphic notification bubbles
  - Grouped notifications by app
  - Do-not-disturb mode

- [ ] **AI Assistant Integration**
  - Local LLM chat UI (web-based, Ollama-powered)
  - System command natural language interface
  - "Ask OpenOS" feature for system help

- [ ] **Better Power Management**
  - Auto-detect laptop vs desktop
  - Battery health monitoring
  - Performance profiles (Power Saver / Balanced / Performance)

- [ ] **Touchscreen Support**
  - Virtual keyboard integration
  - Touch-optimized gestures
  - Tablet mode auto-detection

---

### v2.0.0 — "Evolution"
**Target:** 2027
**Focus:** Independent infrastructure

- [ ] **Custom Package Manager (bNode PM)**
  - Flatpak-first approach
  - Sandboxed app installations
  - Rollback capability
  - Dependency visualization

- [ ] **Kernel Optimizations**
  - Custom kernel config for desktop use
  - Better scheduler (CFS/BPF improvements)
  - Reduced latency for audio/video
  - Optional real-time kernel variant

- [ ] **ARM64 Support**
  - Raspberry Pi 4/5 images
  - Apple Silicon (Asahi Linux integration)
  - ARM server deployment

- [ ] **Enterprise Features**
  - Active Directory integration
  - Centralized management tools
  - Remote desktop (RustDesk pre-installed)
  - Automated backup solutions

- [ ] **Gaming Mode**
  - Game launcher integration
  - Proton/GE-Proton auto-setup
  - Performance overlay (FPS, temps)
  - Controller support out-of-the-box

---

### v3.0.0 — "Vision"
**Target:** 2028+
**Focus:** Next-generation desktop

- [ ] **Rust-Based Components**
  - Custom compositor (Smithay-based)
  - Rust system utilities
  - Memory-safe core applications

- [ ] **Immutable System Option**
  - OSTree or BTRFS snapshot-based updates
  - Atomic upgrades and rollbacks
  - Separate /home and /var

- [ ] **Cloud Sync**
  - Settings synchronization across devices
  - Encrypted cloud backup
  - Remote desktop access from mobile

- [ ] **Voice Control**
  - Local speech recognition (Whisper-based)
  - Voice commands for system control
  - Accessibility voice navigation

---

## Long-Term Vision

### Philosophy
OpenOS aims to be the **most beautiful, secure, and productive** Linux desktop experience without sacrificing stability or compatibility.

### Principles
1. **User Privacy First** — No telemetry, no tracking, ever
2. **Stability Over Hype** — Only ship features that work reliably
3. **Beautiful by Default** — No ugly Linux out-of-the-box
4. **Developer Friendly** — Pre-configured for coding workflows
5. **AI-Ready** — Local AI tools, not cloud dependencies
6. **Community Driven** — Open source, transparent development

### Target Users
- Developers who want a beautiful, productive environment
- Privacy-conscious users leaving macOS/Windows
- Linux enthusiasts who love ricing but want it pre-configured
- Students and professionals needing a reliable daily driver
- Anyone who believes Linux can be beautiful AND functional

---

## Contributing to the Roadmap

Have an idea? Here's how to contribute:

1. **Open an Issue** — Describe your feature request
2. **Vote on Features** — 👍 existing issues you want
3. **Submit PRs** — Code contributions welcome
4. **Join Discussions** — Help shape priorities

### Priority Labels
- 🔴 **P0-Critical** — Security, stability, core functionality
- 🟠 **P1-High** — User experience, major features
- 🟡 **P2-Medium** — Nice-to-have, polish
- 🟢 **P3-Low** — Experimental, future consideration

---

## Release Schedule

| Version | Target Date | Status |
|---------|-------------|--------|
| v1.0.0 | June 2026 | ✅ Released |
| v1.1.0 | September 2026 | 🚧 In Planning |
| v1.2.0 | December 2026 | 📋 Planned |
| v2.0.0 | Q2 2027 | 📋 Planned |
| v3.0.0 | 2028 | 🎯 Vision |

---

<div align="center">

**OpenOS / bNode — The Future of Linux Desktops**

</div>
