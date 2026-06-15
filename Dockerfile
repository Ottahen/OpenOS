FROM ubuntu:22.04

LABEL maintainer="OpenOS Team"
LABEL version="1.0.0"
LABEL description="OpenOS (bNode) - Glassmorphic Linux Desktop Environment"

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Update and install base packages
RUN apt-get update && apt-get upgrade -y &&     apt-get install -y     curl wget git     software-properties-common     apt-transport-https     ca-certificates     gnupg lsb-release     flatpak     gnome-software-plugin-flatpak     python3 python3-pip     libglib2.0-dev     libgtk-3-dev     libgtk-4-dev     sassc optipng inkscape     gnome-tweaks dconf-editor     dbus-x11 x11-xserver-utils     mutter gnome-shell-extension-manager     chrome-gnome-shell     plank rofi dunst picom     feh nitrogen conky-all     wmctrl xdotool libnotify-bin     htop neofetch     tlp tlp-rdw preload zram-tools     fonts-inter fonts-jetbrains-mono     ufw apparmor apparmor-profiles     unattended-upgrades     xbindkeys     && rm -rf /var/lib/apt/lists/*

# Add Brave repository and install
RUN curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg     https://brave-browser-apt-release.s.brave.com/brave-browser-archive-keyring.gpg &&     echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg]     https://brave-browser-apt-release.s.brave.com/ stable main" |     tee /etc/apt/sources.list.d/brave-browser-release.list &&     apt-get update &&     apt-get install -y brave-browser &&     rm -rf /var/lib/apt/lists/*

# Add OnlyOffice repository and install
RUN curl -fsSL https://download.onlyoffice.com/GPG-KEY-ONLYOFFICE |     gpg --dearmor -o /usr/share/keyrings/onlyoffice.gpg &&     echo "deb [signed-by=/usr/share/keyrings/onlyoffice.gpg]     https://download.onlyoffice.com/repo/debian squeeze main" |     tee /etc/apt/sources.list.d/onlyoffice.list &&     apt-get update &&     apt-get install -y onlyoffice-desktopeditors &&     rm -rf /var/lib/apt/lists/*

# Add VS Code repository and install
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc |     gpg --dearmor -o /usr/share/keyrings/microsoft-archive-keyring.gpg &&     echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg]     https://packages.microsoft.com/repos/code stable main" |     tee /etc/apt/sources.list.d/vscode.list &&     apt-get update &&     apt-get install -y code &&     rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Install WhiteSur theme (Apple-like)
RUN cd /tmp &&     git clone --depth 1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git &&     cd WhiteSur-gtk-theme &&     ./install.sh -d /usr/share/themes -t all -c Dark -s 180 &&     cd /tmp && rm -rf WhiteSur-gtk-theme

# Install WhiteSur icons
RUN cd /tmp &&     git clone --depth 1 https://github.com/vinceliuice/WhiteSur-icon-theme.git &&     cd WhiteSur-icon-theme &&     ./install.sh -d /usr/share/icons &&     cd /tmp && rm -rf WhiteSur-icon-theme

# Install WhiteSur cursors
RUN cd /tmp &&     git clone --depth 1 https://github.com/vinceliuice/WhiteSur-cursors.git &&     cd WhiteSur-cursors &&     mkdir -p /usr/share/icons/WhiteSur-cursors &&     cp -r dist/* /usr/share/icons/WhiteSur-cursors/ &&     cd /tmp && rm -rf WhiteSur-cursors

# Set default theme
ENV GTK_THEME=WhiteSur-Dark
ENV ICON_THEME=WhiteSur-dark
ENV CURSOR_THEME=WhiteSur-cursors

# Create OpenOS directories
RUN mkdir -p /etc/openos /usr/share/backgrounds/openos

# Copy project files
COPY themes/ /usr/share/themes/
COPY ui/ /etc/openos/ui/
COPY scripts/ /usr/local/bin/
COPY docs/ /usr/share/doc/openos/

# Set up font aliases
COPY core/font-config.xml /etc/fonts/local.conf
RUN fc-cache -f

# Expose common ports
EXPOSE 80 443 11434 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3     CMD curl -f http://localhost:11434/api/tags || exit 1

# Default command
CMD ["/bin/bash"]
