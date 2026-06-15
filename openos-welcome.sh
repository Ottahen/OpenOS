#!/bin/bash
# OpenOS Welcome Script
# Runs on first login to help users get started

LOGO='
   ____                   _____ ____  
  / __ \____  ___  ____  / ___// __ \ 
 / / / / __ \/ _ \/ __ \ \__ \/ / / / 
/ /_/ / /_/ /  __/ / / /___/ / /_/ /  
\____/ .___/\___/_/ /_//____/\____/   
    /_/                                
'

clear
echo "$LOGO"
echo "══════════════════════════════════════════════════"
echo "  Welcome to OpenOS / bNode!"
echo "  Your glassmorphic Linux desktop is ready."
echo "══════════════════════════════════════════════════"
echo ""

# Check system status
echo "📊 System Status:"
echo "  CPU: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d':' -f2 | xargs)"
echo "  RAM: $(free -h | awk '/^Mem:/ {print $2}')"
echo "  Disk: $(df -h / | awk 'NR==2 {print $4}') free"
echo ""

# Check installed apps
echo "📦 Pre-installed Applications:"
command -v brave-browser &> /dev/null && echo "  ✅ Brave Browser" || echo "  ❌ Brave Browser"
command -v code &> /dev/null && echo "  ✅ VS Code" || echo "  ❌ VS Code"
command -v onlyoffice-desktopeditors &> /dev/null && echo "  ✅ OnlyOffice" || echo "  ❌ OnlyOffice"
command -v ollama &> /dev/null && echo "  ✅ Ollama" || echo "  ❌ Ollama"
echo ""

# Quick tips
echo "🚀 Quick Start Tips:"
echo "  • Press Super+Space to open the app launcher"
echo "  • Press Super+Enter for terminal"
echo "  • Right-click the dock to customize it"
echo "  • Use the theme switcher in the app menu"
echo ""

echo "🎨 Customization:"
echo "  • Change wallpaper: Right-click desktop"
echo "  • Switch themes: Super+T or Theme Switcher app"
echo "  • Adjust blur: Edit ~/.config/picom/picom.conf"
echo ""

echo "🔧 Useful Commands:"
echo "  openos-welcome     - Show this welcome screen"
echo "  openos-theme       - Switch Light/Dark theme"
echo "  openos-update      - Update system and apps"
echo "  openos-reset       - Reset desktop settings"
echo ""

read -p "Press Enter to continue..."
