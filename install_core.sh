#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export DEBIAN_FRONTEND=noninteractive
source utils.sh

sudo -v

apt_update

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y $* >> "$DIR/install.log"

# Install essentials
apt_inst git
apt_inst git-lfs
apt_inst gh
apt_inst gnupg
apt_inst curl
apt_inst build-essential
apt_inst htop
apt_inst gdebi
apt_inst neovim
apt_inst exuberant-ctags
apt_inst firefox-esr

# Install utils
apt_inst htop
apt_inst entr
apt_inst tree
apt_inst ripgrep
apt_inst entr


# Install python
apt_inst python3
apt_inst pipx
apt_inst python3-pip
apt_inst python3-neovim

# Install rust
log "Installing rust."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y &>> $LOGS >> $LOGS

# Install gay hacker nerd shit
apt_inst python3-pwntools
apt_inst wireshark
apt_inst tshark
apt_inst binwalk

