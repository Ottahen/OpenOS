#!/bin/bash
# OpenOS Reset Script
# Resets desktop settings to OpenOS defaults

echo "🔄 Resetting OpenOS Desktop Settings"
echo "═══════════════════════════════════════"

read -p "⚠️  This will reset all desktop customizations. Continue? (y/N): " confirm
if [[ $confirm != [yY] ]]; then
    echo "Cancelled."
    exit 0
fi

# Reset GNOME settings
gsettings reset-recursively org.gnome.desktop.interface
gsettings reset-recursively org.gnome.desktop.wm.preferences
gsettings reset-recursively org.gnome.shell.extensions.dash-to-dock
gsettings reset-recursively org.gnome.desktop.background

# Re-apply OpenOS defaults
bash /etc/xdg/openos-desktop.sh

# Reset Plank
rm -rf ~/.config/plank
mkdir -p ~/.config/plank/dock1
cp /etc/skel/.config/plank/dock1/settings ~/.config/plank/dock1/settings

# Reset Rofi
rm -rf ~/.config/rofi
mkdir -p ~/.config/rofi
cp /etc/skel/.config/rofi/config.rasi ~/.config/rofi/config.rasi

# Reset Picom
rm -rf ~/.config/picom
mkdir -p ~/.config/picom
cp /etc/skel/.config/picom/picom.conf ~/.config/picom/picom.conf

# Restart components
killall plank 2>/dev/null
killall picom 2>/dev/null
killall rofi 2>/dev/null

sleep 1

# Restart
plank &
picom --config ~/.config/picom/picom.conf -b &

echo ""
echo "✅ Settings reset to OpenOS defaults!"
echo "🔄 Log out and back in for full effect."
