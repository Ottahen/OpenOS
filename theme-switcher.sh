#!/bin/bash
# OpenOS Theme Switcher
# Toggle between light and dark glassmorphic themes

CURRENT_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d "'")

if [[ "$CURRENT_THEME" == *"Dark"* ]] || [[ "$CURRENT_THEME" == "OpenOS-Dark" ]]; then
    # Switch to Light
    gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Light" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme "WhiteSur" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' 2>/dev/null || true

    # Update Plank theme
    sed -i 's/Theme=.*/Theme=Glassmorphic-Light/' ~/.config/plank/dock1/settings 2>/dev/null || true

    # Update wallpaper
    WALLPAPER="/usr/share/backgrounds/openos/light-cloud.jpg"
    if [ -f "$WALLPAPER" ]; then
        gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER" 2>/dev/null || true
    fi

    # Update Rofi theme
    sed -i 's/@theme ".*"/@theme "\/etc\/openos\/rofi-glassmorphic-light.rasi"/' ~/.config/rofi/config.rasi 2>/dev/null || true

    notify-send "OpenOS Theme" "☀️  Light theme activated" -i preferences-desktop-theme
    echo "☀️  Switched to Light theme"
else
    # Switch to Dark
    gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme "WhiteSur-dark" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true

    # Update Plank theme
    sed -i 's/Theme=.*/Theme=Glassmorphic/' ~/.config/plank/dock1/settings 2>/dev/null || true

    # Update wallpaper
    WALLPAPER="/usr/share/backgrounds/openos/default-cloud.jpg"
    if [ -f "$WALLPAPER" ]; then
        gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER" 2>/dev/null || true
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER" 2>/dev/null || true
    fi

    # Update Rofi theme
    sed -i 's/@theme ".*"/@theme "\/etc\/openos\/rofi-glassmorphic.rasi"/' ~/.config/rofi/config.rasi 2>/dev/null || true

    notify-send "OpenOS Theme" "🌙  Dark theme activated" -i preferences-desktop-theme
    echo "🌙  Switched to Dark theme"
fi

# Restart Plank to apply theme
killall plank 2>/dev/null || true
sleep 0.5
plank &
