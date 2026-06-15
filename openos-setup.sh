#!/bin/bash
# OpenOS (bNode) Setup Installer
# Version: 1.0.0
# Base: Ubuntu 22.04/24.04 LTS
# Description: Glassmorphic Apple-like Linux desktop

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging
LOG_FILE="/var/log/openos-install.log"
exec 1> >(tee -a "$LOG_FILE")
exec 2> >(tee -a "$LOG_FILE" >&2)

# Project paths
OPENOS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$OPENOS_DIR/themes"
UI_DIR="$OPENOS_DIR/ui"
SCRIPTS_DIR="$OPENOS_DIR/scripts"

print_banner() {
    echo -e "${PURPLE}"
    cat << "EOF"
   ____                   _____ ____  
  / __ \____  ___  ____  / ___// __ \ 
 / / / / __ \/ _ \/ __ \ \__ \/ / / / 
/ /_/ / /_/ /  __/ / / /___/ / /_/ /  
\____/ .___/\___/_/ /_//____/\____/   
    /_/                                
   bNode Desktop Environment v1.0
EOF
    echo -e "${NC}"
    echo -e "${CYAN}Glassmorphic Linux Experience${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════${NC}"
}

log_step() {
    echo -e "${BLUE}[$(date +%H:%M:%S)]${NC} ${GREEN}►${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        log_error "Please run as root (sudo bash openos-setup.sh)"
        exit 1
    fi
}

# Detect Ubuntu version
detect_ubuntu() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" != "ubuntu" ]]; then
            log_warn "This is designed for Ubuntu. Detected: $ID"
            read -p "Continue anyway? (y/N): " confirm
            [[ $confirm == [yY] ]] || exit 1
        fi
        UBUNTU_VERSION="$VERSION_ID"
        log_step "Detected Ubuntu $UBUNTU_VERSION"
    else
        log_error "Cannot detect OS"
        exit 1
    fi
}

# System update and base dependencies
update_system() {
    log_step "Updating system packages..."
    apt-get update -qq
    apt-get upgrade -y -qq

    log_step "Installing base dependencies..."
    apt-get install -y -qq \
        curl wget git \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg lsb-release \
        flatpak \
        gnome-software-plugin-flatpak \
        python3 python3-pip \
        libglib2.0-dev \
        libgtk-3-dev \
        libgtk-4-dev \
        sassc \
        optipng \
        inkscape \
        cinnamon-desktop-environment \
        gnome-tweaks \
        dconf-editor \
        dbus-x11 \
        x11-xserver-utils \
        libbluray2 \
        libgjs0g \
        gir1.2-gtkclutter-1.0 \
        gir1.2-clutter-1.0 \
        libclutter-1.0-0 \
        libclutter-gst-3.0-0 \
        libclutter-gtk-1.0-0 \
        mutter \
        gnome-shell-extension-manager \
        chrome-gnome-shell \
        plank \
        rofi \
        dunst \
        picom \
        feh \
        nitrogen \
        conky-all \
        wmctrl \
        xdotool \
        libnotify-bin \
        htop neofetch \
        tlp tlp-rdw \
        preload \
        zram-tools \
        2>&1 | tee -a "$LOG_FILE"

    log_step "Base system ready"
}

# Add Flathub repository
setup_flatpak() {
    log_step "Setting up Flatpak repository..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

# Install Brave Browser
install_brave() {
    log_step "Installing Brave Browser..."

    # Add Brave repository
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list

    apt-get update -qq
    apt-get install -y -qq brave-browser

    # Set as default browser
    xdg-settings set default-web-browser brave-browser.desktop 2>/dev/null || true
    update-alternatives --set x-www-browser /usr/bin/brave-browser 2>/dev/null || true

    log_step "Brave Browser installed and set as default"
}

# Install OnlyOffice
install_onlyoffice() {
    log_step "Installing OnlyOffice Desktop Editors..."

    # Add OnlyOffice repository
    curl -fsSL https://download.onlyoffice.com/GPG-KEY-ONLYOFFICE | gpg --dearmor -o /usr/share/keyrings/onlyoffice.gpg
    echo "deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main" | tee /etc/apt/sources.list.d/onlyoffice.list

    apt-get update -qq
    apt-get install -y -qq onlyoffice-desktopeditors

    # Integrate with file manager
    apt-get install -y -qq nautilus-actions

    log_step "OnlyOffice installed"
}

# Install VS Code
install_vscode() {
    log_step "Installing Visual Studio Code..."

    # Add VS Code repository
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list

    apt-get update -qq
    apt-get install -y -qq code

    log_step "VS Code installed"
}

# Install Ollama (optional, for AI workloads)
install_ollama() {
    log_step "Installing Ollama (AI model runner)..."

    curl -fsSL https://ollama.com/install.sh | sh

    # Enable service
    systemctl enable ollama
    systemctl start ollama

    log_step "Ollama installed and running"
}

# Install glassmorphic theme and UI
install_theme() {
    log_step "Installing OpenOS Glassmorphic Theme..."

    # Create theme directories
    mkdir -p /usr/share/themes/OpenOS-Dark
    mkdir -p /usr/share/themes/OpenOS-Light
    mkdir -p /usr/share/icons/OpenOS
    mkdir -p /usr/share/backgrounds/openos

    # Copy theme files from project
    if [ -d "$THEMES_DIR/gtk" ]; then
        cp -r "$THEMES_DIR/gtk/"* /usr/share/themes/OpenOS-Dark/ 2>/dev/null || true
        cp -r "$THEMES_DIR/gtk-light/"* /usr/share/themes/OpenOS-Light/ 2>/dev/null || true
    fi

    if [ -d "$THEMES_DIR/icons" ]; then
        cp -r "$THEMES_DIR/icons/"* /usr/share/icons/OpenOS/ 2>/dev/null || true
    fi

    if [ -d "$THEMES_DIR/wallpapers" ]; then
        cp -r "$THEMES_DIR/wallpapers/"* /usr/share/backgrounds/openos/ 2>/dev/null || true
    fi

    # Install WhiteSur as fallback (Apple-like GTK theme)
    log_step "Installing WhiteSur fallback theme..."
    cd /tmp
    git clone --depth 1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git 2>/dev/null || true
    if [ -d "WhiteSur-gtk-theme" ]; then
        cd WhiteSur-gtk-theme
        ./install.sh -d /usr/share/themes -t all -c Dark -s 180 2>/dev/null || true
        cd /tmp
        rm -rf WhiteSur-gtk-theme
    fi

    # Install WhiteSur icons
    git clone --depth 1 https://github.com/vinceliuice/WhiteSur-icon-theme.git 2>/dev/null || true
    if [ -d "WhiteSur-icon-theme" ]; then
        cd WhiteSur-icon-theme
        ./install.sh -d /usr/share/icons 2>/dev/null || true
        cd /tmp
        rm -rf WhiteSur-icon-theme
    fi

    # Install WhiteSur cursors
    git clone --depth 1 https://github.com/vinceliuice/WhiteSur-cursors.git 2>/dev/null || true
    if [ -d "WhiteSur-cursors" ]; then
        cd WhiteSur-cursors
        mkdir -p /usr/share/icons/WhiteSur-cursors
        cp -r dist/* /usr/share/icons/WhiteSur-cursors/ 2>/dev/null || true
        cd /tmp
        rm -rf WhiteSur-cursors
    fi

    log_step "Glassmorphic themes installed"
}

# Configure GNOME desktop for Apple-like experience
configure_desktop() {
    log_step "Configuring desktop environment..."

    # Create system-wide gsettings
    cat > /etc/xdg/openos-desktop.sh << 'EOF'
#!/bin/bash
# OpenOS Desktop Configuration

# Set theme
export GTK_THEME="WhiteSur-Dark"
export ICON_THEME="WhiteSur-dark"
export CURSOR_THEME="WhiteSur-cursors"

# GNOME settings for Apple-like experience
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark" 2>/dev/null || true
gsettings set org.gnome.desktop.interface icon-theme "WhiteSur-dark" 2>/dev/null || true
gsettings set org.gnome.desktop.interface cursor-theme "WhiteSur-cursors" 2>/dev/null || true
gsettings set org.gnome.desktop.interface font-name "SF Pro Display 11" 2>/dev/null || true
gsettings set org.gnome.desktop.interface monospace-font-name "SF Mono 10" 2>/dev/null || true
gsettings set org.gnome.desktop.interface document-font-name "SF Pro Text 11" 2>/dev/null || true

# Enable dark mode by default
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true

# Rounded corners and blur
gsettings set org.gnome.shell.extensions.user-theme name "WhiteSur-Dark" 2>/dev/null || true

# Dock configuration (Apple-like)
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'bottom' 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock icon-size-fixed true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock running-indicator-style 'DEFAULT' 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-overview' 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock scroll-action 'cycle-windows' 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts true 2>/dev/null || true

# Workspace settings
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4 2>/dev/null || true
gsettings set org.gnome.shell.app-switcher current-workspace-only true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true 2>/dev/null || true

# Window management
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:' 2>/dev/null || true
gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true 2>/dev/null || true

# Touchpad and gestures
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true 2>/dev/null || true
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true 2>/dev/null || true
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true 2>/dev/null || true

# Keyboard shortcuts
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "<Super>l" 2>/dev/null || true
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "<Super>1" 2>/dev/null || true
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "<Super>2" 2>/dev/null || true
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "<Super>3" 2>/dev/null || true
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "<Super>4" 2>/dev/null || true

# Power settings (performance)
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 3600 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 1800 2>/dev/null || true

# File manager (Nautilus) settings
gsettings set org.gnome.nautilus.preferences show-hidden-files false 2>/dev/null || true
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'icon-view' 2>/dev/null || true
gsettings set org.gnome.nautilus.icon-view default-zoom-level 'standard' 2>/dev/null || true

# Set wallpaper
WALLPAPER="/usr/share/backgrounds/openos/default-cloud.jpg"
if [ -f "$WALLPAPER" ]; then
    gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER" 2>/dev/null || true
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER" 2>/dev/null || true
    gsettings set org.gnome.desktop.background picture-options 'zoom' 2>/dev/null || true
fi
EOF
    chmod +x /etc/xdg/openos-desktop.sh

    # Add to session startup
    mkdir -p /etc/xdg/autostart
    cat > /etc/xdg/autostart/openos-desktop.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=OpenOS Desktop Configuration
Exec=/etc/xdg/openos-desktop.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

    log_step "Desktop configured with Apple-like glassmorphic UI"
}

# Configure Plank dock (Apple-style dock)
configure_dock() {
    log_step "Configuring Plank dock..."

    mkdir -p /etc/skel/.config/plank/dock1

    cat > /etc/skel/.config/plank/dock1/settings << 'EOF'
[PlankDockPreferences]
Theme=Glassmorphic
IconSize=48
ZoomPercent=150
ZoomEnabled=true
HideMode=Intelligent
HideDelay=0
UnhideDelay=0
Monitor=0
Position=3
Offset=0
Alignment=3
ItemsAlignment=3
LockItems=false
PressureReveal=false
ShowDockItem=false
Pinned=brave-browser.desktop;org.onlyoffice.desktopeditors.desktop;code.desktop;nautilus.desktop;org.gnome.Terminal.desktop;
EOF

    # Create glassmorphic Plank theme
    mkdir -p /usr/share/plank/themes/Glassmorphic
    cat > /usr/share/plank/themes/Glassmorphic/dock.theme << 'EOF'
[PlankTheme]
Name=Glassmorphic
Description=Glassmorphic dock theme for OpenOS

[PlankDockTheme]
TopPadding=2
BottomPadding=2
RightPadding=2
LeftPadding=2
ItemPadding=4
IndicatorSize=5
IconShadowSize=0
UrgentBounceHeight=1.5
LaunchBounceHeight=0.625
FadeOpacity=1
HideOpacity=0.75
GlowSize=30
GlowTime=0.5
GlowPulseTime=1.5
UrgentHueShift=150
ItemMoveTime=0.5
CascadeHide=true

# Glassmorphic colors (RGBA)
# Background: semi-transparent dark with blur
BgRed=0.12
BgGreen=0.12
BgBlue=0.15
BgAlpha=0.65

# Border: subtle light edge
BorderRed=0.3
BorderGreen=0.3
BorderBlue=0.4
BorderAlpha=0.3

# Gradient for depth
GradientTop=0.15
GradientBottom=0.08
EOF

    # Add Plank to autostart
    cat > /etc/xdg/autostart/plank.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Plank
Exec=plank
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF

    log_step "Plank dock configured with glassmorphic theme"
}

# Configure Rofi launcher (Apple-like Spotlight)
configure_launcher() {
    log_step "Configuring Rofi app launcher..."

    mkdir -p /etc/skel/.config/rofi

    cat > /etc/skel/.config/rofi/config.rasi << 'EOF'
configuration {
    modi: "drun,run,window";
    icon-theme: "WhiteSur-dark";
    show-icons: true;
    terminal: "gnome-terminal";
    drun-display-format: "{name}";
    location: 0;
    disable-history: false;
    hide-scrollbar: true;
    display-drun: "  Apps";
    display-run: "  Run";
    display-window: "  Window";
    sidebar-mode: false;
}

@theme "/etc/openos/rofi-glassmorphic.rasi"
EOF

    mkdir -p /etc/openos
    cat > /etc/openos/rofi-glassmorphic.rasi << 'EOF'
* {
    bg: rgba(18, 18, 25, 0.85);
    bg-alt: rgba(30, 30, 45, 0.7);
    fg: #ffffff;
    fg-alt: #b0b0c0;
    accent: #a78bfa;
    accent-alt: #8b5cf6;
    border: rgba(255, 255, 255, 0.15);
    urgent: #f87171;

    background-color: @bg;
    text-color: @fg;
    font: "SF Pro Display 13";
    border-radius: 16px;
    border: 2px;
    border-color: @border;
    padding: 12px;
    margin: 0px;
    spacing: 8px;
}

window {
    width: 700px;
    height: 500px;
    border-radius: 24px;
    border: 2px solid;
    border-color: @border;
    background-color: @bg;
    location: center;
    anchor: center;
    x-offset: 0;
    y-offset: 0;
    padding: 20px;
}

mainbox {
    background-color: transparent;
    border-radius: 24px;
    children: [inputbar, listview];
    spacing: 16px;
    padding: 0px;
}

inputbar {
    background-color: @bg-alt;
    border-radius: 16px;
    padding: 16px 20px;
    spacing: 12px;
    children: [prompt, entry];
    border: 1px solid;
    border-color: @border;
}

prompt {
    background-color: transparent;
    text-color: @accent;
    font: "SF Pro Display 14";
    padding: 0px 8px 0px 0px;
}

entry {
    background-color: transparent;
    text-color: @fg;
    font: "SF Pro Display 14";
    placeholder: "Search apps, files, commands...";
    placeholder-color: @fg-alt;
    cursor: text;
    expand: true;
    padding: 0px;
}

listview {
    background-color: transparent;
    border-radius: 16px;
    padding: 8px;
    spacing: 6px;
    columns: 1;
    lines: 8;
    fixed-height: false;
    dynamic: true;
    scrollbar: false;
    border: 0px;
}

element {
    background-color: transparent;
    text-color: @fg;
    border-radius: 12px;
    padding: 12px 16px;
    spacing: 16px;
    children: [element-icon, element-text];
}

element-icon {
    background-color: transparent;
    text-color: inherit;
    size: 36px;
    border: 0px;
    padding: 0px;
}

element-text {
    background-color: transparent;
    text-color: inherit;
    font: "SF Pro Display 13";
    expand: true;
    vertical-align: 0.5;
    padding: 0px;
}

element selected {
    background-color: @accent-alt;
    text-color: #ffffff;
    border-radius: 12px;
    border: 0px;
}

element selected.normal {
    background-color: @accent-alt;
}

element normal.normal {
    background-color: transparent;
}

element alternate.normal {
    background-color: transparent;
}

element urgent.normal {
    background-color: @urgent;
    text-color: #ffffff;
}
EOF

    # Add keyboard shortcut for Rofi (Super+Space like Spotlight)
    cat > /etc/xdg/autostart/rofi-shortcut.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Rofi Shortcut
Exec=bash -c 'sleep 5 && xbindkeys'
Hidden=false
X-GNOME-Autostart-enabled=true
EOF

    # Install xbindkeys for shortcuts
    apt-get install -y -qq xbindkeys

    cat > /etc/skel/.xbindkeysrc << 'EOF'
# OpenOS Keyboard Shortcuts
# Super+Space: App Launcher (Spotlight-style)
"rofi -show drun -show-icons"
    Mod4 + space

# Super+Return: Terminal
"gnome-terminal"
    Mod4 + Return

# Super+E: File Manager
"nautilus"
    Mod4 + e

# Super+B: Brave Browser
"brave-browser"
    Mod4 + b
EOF

    log_step "Rofi launcher configured with glassmorphic theme"
}

# Configure Picom compositor for blur and transparency
configure_compositor() {
    log_step "Configuring Picom compositor for glassmorphic effects..."

    mkdir -p /etc/skel/.config/picom

    cat > /etc/skel/.config/picom/picom.conf << 'EOF'
# OpenOS Picom Configuration
# Glassmorphic blur and transparency effects

# Backend
backend = "glx";
vsync = true;

# Opacity rules for glassmorphic effect
opacity-rule = [
    "85:class_g = 'Plank'",
    "90:class_g = 'Rofi'",
    "85:class_g = 'gnome-terminal' && focused",
    "75:class_g = 'gnome-terminal' && !focused",
    "95:class_g = 'Brave-browser' && focused",
    "90:class_g = 'Brave-browser' && !focused",
    "85:class_g = 'Code' && focused",
    "80:class_g = 'Code' && !focused",
    "90:class_g = 'org.onlyoffice.desktopeditors' && focused",
    "85:class_g = 'org.onlyoffice.desktopeditors' && !focused",
    "80:class_g = 'Nautilus' && !focused",
    "90:class_g = 'Nautilus' && focused"
];

# Blur settings
blur-method = "dual_kawase";
blur-strength = 8;
blur-background = true;
blur-background-frame = true;
blur-background-fixed = true;

blur-kern = "3x3box";

# Background blur for specific windows
blur-background-exclude = [
    "window_type = 'dock'",
    "window_type = 'desktop'",
    "class_g = 'slop'",
    "class_g = 'Conky'"
];

# Rounded corners
corner-radius = 16;
rounded-corners-exclude = [
    "window_type = 'dock'",
    "window_type = 'desktop'",
    "class_g = 'Plank'",
    "class_g = 'Rofi'"
];

# Shadow
shadow = true;
shadow-radius = 18;
shadow-offset-x = -8;
shadow-offset-y = -8;
shadow-opacity = 0.25;
shadow-color = "#000000";

shadow-exclude = [
    "window_type = 'menu'",
    "window_type = 'dropdown_menu'",
    "window_type = 'popup_menu'",
    "window_type = 'tooltip'",
    "class_g = 'Plank'",
    "class_g = 'Rofi'"
];

# Fading
fading = true;
fade-in-step = 0.03;
fade-out-step = 0.03;
fade-delta = 4;

# Animation settings
animations = true;
animation-stiffness = 200;
animation-dampening = 25;
animation-clamping = true;

# Window type settings
wintypes:
{
    tooltip = { fade = true; shadow = false; opacity = 0.9; focus = true; full-shadow = false; };
    menu = { shadow = false; opacity = 0.95; };
    popup_menu = { shadow = false; opacity = 0.95; };
    dropdown_menu = { shadow = false; opacity = 0.95; };
    dialog = { shadow = true; opacity = 0.95; };
    normal = { shadow = true; opacity = 0.95; };
    dock = { shadow = false; opacity = 0.85; };
    dnd = { shadow = false; opacity = 0.9; };
    notification = { shadow = true; opacity = 0.9; };
};

# Other settings
detect-rounded-corners = true;
detect-client-opacity = true;
use-damage = true;
log-level = "warn";
EOF

    # Add Picom to autostart
    cat > /etc/xdg/autostart/picom.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Picom Compositor
Exec=picom --config /etc/skel/.config/picom/picom.conf
Hidden=false
X-GNOME-Autostart-enabled=true
EOF

    log_step "Picom compositor configured for glassmorphic blur effects"
}

# Security hardening
configure_security() {
    log_step "Applying security hardening..."

    # Disable telemetry and tracking
    apt-get remove -y --purge ubuntu-report popularity-contest 2>/dev/null || true
    apt-get autoremove -y 2>/dev/null || true

    # Disable apport (crash reporting)
    systemctl stop apport 2>/dev/null || true
    systemctl disable apport 2>/dev/null || true
    sed -i 's/enabled=1/enabled=0/' /etc/default/apport 2>/dev/null || true

    # Disable whoopsie (error reporting)
    systemctl stop whoopsie 2>/dev/null || true
    systemctl disable whoopsie 2>/dev/null || true

    # Configure UFW firewall
    apt-get install -y -qq ufw
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw --force enable

    # Harden sysctl settings
    cat >> /etc/sysctl.conf << 'EOF'

# OpenOS Security Hardening
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
kernel.yama.ptrace_scope = 1
fs.suid_dumpable = 0
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1
EOF

    sysctl -p

    # Enable AppArmor
    apt-get install -y -qq apparmor apparmor-profiles apparmor-utils
    systemctl enable apparmor
    systemctl start apparmor

    # Configure automatic security updates
    apt-get install -y -qq unattended-upgrades
    cat > /etc/apt/apt.conf.d/50unattended-upgrades << 'EOF'
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
};
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
EOF

    log_step "Security hardening applied"
}

# Performance optimization
configure_performance() {
    log_step "Applying performance optimizations..."

    # Enable zram for compressed RAM swap
    apt-get install -y -qq zram-tools
    cat > /etc/default/zramswap << 'EOF'
ALGO=lz4
PERCENT=50
PRIORITY=100
EOF
    systemctl restart zramswap

    # Enable TLP for power management
    systemctl enable tlp
    systemctl start tlp

    # Enable preload for faster app startup
    systemctl enable preload
    systemctl start preload

    # Optimize swappiness
    echo 'vm.swappiness=10' >> /etc/sysctl.conf
    echo 'vm.vfs_cache_pressure=50' >> /etc/sysctl.conf
    sysctl -p

    # Disable unnecessary services
    systemctl disable bluetooth 2>/dev/null || true
    systemctl disable cups 2>/dev/null || true
    systemctl disable cups-browsed 2>/dev/null || true

    log_step "Performance optimizations applied"
}

# Create user template
setup_user_template() {
    log_step "Setting up user template..."

    # Copy configs to /etc/skel for new users
    mkdir -p /etc/skel/.config
    cp -r /etc/skel/.config/plank /etc/skel/.config/ 2>/dev/null || true
    cp -r /etc/skel/.config/rofi /etc/skel/.config/ 2>/dev/null || true
    cp -r /etc/skel/.config/picom /etc/skel/.config/ 2>/dev/null || true
    cp /etc/skel/.xbindkeysrc /etc/skel/ 2>/dev/null || true

    # Create .bashrc additions
    cat >> /etc/skel/.bashrc << 'EOF'

# OpenOS Customizations
export GTK_THEME="WhiteSur-Dark"
export ICON_THEME="WhiteSur-dark"
export QT_STYLE_OVERRIDE="kvantum"

# Aliases
alias update='sudo apt update && sudo apt upgrade -y'
alias clean='sudo apt autoremove -y && sudo apt clean'
alias ..='cd ..'
alias ...='cd ../..'

# Neofetch on terminal open
if command -v neofetch &> /dev/null; then
    neofetch --ascii_distro Ubuntu --disable packages resolution theme icons term --colors 4 7 7 4 7 7
fi
EOF

    log_step "User template configured"
}

# Create desktop entries for core apps
create_desktop_entries() {
    log_step "Creating desktop entries..."

    # OpenOS Settings app
    cat > /usr/share/applications/openos-settings.desktop << 'EOF'
[Desktop Entry]
Name=OpenOS Settings
Comment=System settings for OpenOS
Exec=gnome-control-center
Icon=preferences-system
Type=Application
Categories=Settings;System;
Keywords=settings;system;control;panel;
EOF

    # Theme switcher
    cat > /usr/share/applications/openos-theme.desktop << 'EOF'
[Desktop Entry]
Name=Theme Switcher
Comment=Switch between light and dark themes
Exec=/usr/local/bin/openos-theme-switcher
Icon=preferences-desktop-theme
Type=Application
Categories=Settings;
EOF

    # Create theme switcher script
    cat > /usr/local/bin/openos-theme-switcher << 'EOF'
#!/bin/bash
# OpenOS Theme Switcher

CURRENT=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null || echo "'WhiteSur-Dark'")

if [[ "$CURRENT" == *"Dark"* ]]; then
    gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Light" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme "WhiteSur" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' 2>/dev/null || true
    notify-send "Theme Switched" "Light theme applied" -i preferences-desktop-theme
else
    gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme "WhiteSur-dark" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true
    notify-send "Theme Switched" "Dark theme applied" -i preferences-desktop-theme
fi
EOF
    chmod +x /usr/local/bin/openos-theme-switcher

    log_step "Desktop entries created"
}

# Install fonts
install_fonts() {
    log_step "Installing fonts..."

    # Install SF Pro alternatives (Inter + JetBrains Mono)
    apt-get install -y -qq fonts-inter fonts-jetbrains-mono

    # Download and install SF Pro if possible (fallback to Inter)
    mkdir -p /usr/share/fonts/openos

    # Create font config
    cat > /etc/fonts/local.conf << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <match target="pattern">
        <test name="family" qual="any">
            <string>SF Pro Display</string>
        </test>
        <edit name="family" mode="assign" binding="same">
            <string>Inter</string>
        </edit>
    </match>
    <match target="pattern">
        <test name="family" qual="any">
            <string>SF Pro Text</string>
        </test>
        <edit name="family" mode="assign" binding="same">
            <string>Inter</string>
        </edit>
    </match>
    <match target="pattern">
        <test name="family" qual="any">
            <string>SF Mono</string>
        </test>
        <edit name="family" mode="assign" binding="same">
            <string>JetBrains Mono</string>
        </edit>
    </match>
</fontconfig>
EOF

    fc-cache -f

    log_step "Fonts installed"
}

# Generate package list
generate_package_list() {
    log_step "Generating package list..."

    cat > "$OPENOS_DIR/docs/installed-packages.txt" << 'EOF'
# OpenOS (bNode) Installed Packages
# Generated during installation

## Core System
- ubuntu-desktop / cinnamon-desktop-environment
- gnome-tweaks, dconf-editor
- flatpak, gnome-software-plugin-flatpak

## Browser
- brave-browser (from official repo)

## Productivity
- onlyoffice-desktopeditors (from official repo)
- code (VS Code from Microsoft repo)

## AI/Development
- ollama (from official install script)
- git, curl, wget
- python3, python3-pip

## UI/UX
- plank (dock)
- rofi (launcher)
- picom (compositor)
- dunst (notifications)
- conky-all (system widgets)
- feh, nitrogen (wallpaper tools)

## Fonts
- fonts-inter
- fonts-jetbrains-mono

## Security
- ufw (firewall)
- apparmor, apparmor-profiles
- unattended-upgrades

## Performance
- zram-tools
- tlp, tlp-rdw
- preload

## Utilities
- htop, neofetch
- wmctrl, xdotool
- libnotify-bin
- xbindkeys
EOF

    log_step "Package list saved to docs/installed-packages.txt"
}

# Main installation flow
main() {
    print_banner

    check_root
    detect_ubuntu

    echo -e "${YELLOW}═══════════════════════════════════════${NC}"
    echo -e "${CYAN}Starting OpenOS (bNode) Installation${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════${NC}"
    echo ""

    # Core setup
    update_system
    setup_flatpak

    # App installations
    install_brave
    install_onlyoffice
    install_vscode
    install_ollama

    # UI/UX setup
    install_theme
    install_fonts
    configure_desktop
    configure_dock
    configure_launcher
    configure_compositor

    # Security and performance
    configure_security
    configure_performance

    # Final setup
    setup_user_template
    create_desktop_entries
    generate_package_list

    # Cleanup
    apt-get autoremove -y
    apt-get clean

    echo ""
    echo -e "${GREEN}═══════════════════════════════════════${NC}"
    echo -e "${GREEN}  OpenOS (bNode) Installation Complete!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}Next steps:${NC}"
    echo -e "  1. Reboot your system: ${YELLOW}sudo reboot${NC}"
    echo -e "  2. Log in and enjoy your glassmorphic desktop"
    echo -e "  3. Press ${YELLOW}Super+Space${NC} for the app launcher"
    echo -e "  4. Press ${YELLOW}Super+Enter${NC} for terminal"
    echo ""
    echo -e "${CYAN}Keyboard Shortcuts:${NC}"
    echo -e "  Super+Space    → App Launcher (Spotlight-style)"
    echo -e "  Super+Enter    → Terminal"
    echo -e "  Super+E        → File Manager"
    echo -e "  Super+B        → Brave Browser"
    echo -e "  Super+1/2/3/4  → Switch Workspaces"
    echo -e "  Super+L        → Lock Screen"
    echo ""
    echo -e "${PURPLE}Welcome to OpenOS / bNode!${NC}"
    echo -e "${YELLOW}Log file: $LOG_FILE${NC}"
}

# Run main function
main "$@"
