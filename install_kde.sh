#!/usr/bin/env bash

set -euo pipefail
shopt -s inherit_errexit
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export DEBIAN_FRONTEND=noninteractive
source utils.sh

sudo -v

# Install kde-plasma
apt_inst kde-plasma-desktop

# Link theme
link .config/plasmarc
link .local/share/plasma/desktoptheme/Scratchy
link .config/plasma-org.kde.plasma.desktop-appletsrc

# Get funky dock
apt_inst latte-dock
link .config/latte

# VSCode
log "Installing VSCodium."

# Add GPG keys
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

# Add repo
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list > $LOGS

# Get codium
apt_update
apt_inst codium

# Codium settings
log "Configuring codium"
codium --install-extension Catppuccin.catppuccin-vsc > $LOGS
codium --install-extension Catppuccin.catppuccin-vsc-icons > $LOGS
link .config/VSCodium/User/settings.json

# Link konsole settings
link .local/share/konsole



