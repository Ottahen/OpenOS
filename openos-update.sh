#!/bin/bash
# OpenOS Update Script
# Updates system, apps, and themes

echo "🔄 OpenOS System Update"
echo "═══════════════════════════════════════"

# Update system
echo "📦 Updating system packages..."
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt clean

# Update Flatpak apps
echo "📦 Updating Flatpak apps..."
flatpak update -y

# Update Brave
echo "🌐 Checking Brave updates..."
# Brave updates through apt

# Update Ollama
echo "🤖 Checking Ollama updates..."
curl -fsSL https://ollama.com/install.sh | sh

# Update themes (optional)
echo "🎨 Checking theme updates..."
cd /tmp
git clone --depth 1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git 2>/dev/null
cd WhiteSur-gtk-theme 2>/dev/null && ./install.sh -d /usr/share/themes -t all 2>/dev/null; cd /tmp; rm -rf WhiteSur-gtk-theme 2>/dev/null

git clone --depth 1 https://github.com/vinceliuice/WhiteSur-icon-theme.git 2>/dev/null
cd WhiteSur-icon-theme 2>/dev/null && ./install.sh -d /usr/share/icons 2>/dev/null; cd /tmp; rm -rf WhiteSur-icon-theme 2>/dev/null

echo ""
echo "✅ Update complete!"
echo "🔄 Please reboot for kernel updates: sudo reboot"
