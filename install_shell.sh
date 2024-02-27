#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export DEBIAN_FRONTEND=noninteractive
source utils.sh

sudo -v

# ZSH
apt_inst zsh

# Oh My ZSH + funky stuff to set terminal
if [ -d "$HOME/.oh-my-zsh" ]; then
    log "Skipping omz"
else
    log "Installing omz"
    curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o /tmp/install.sh &&
        sed -i 's/CHSH=no/CHSH=yes/g' /tmp/install.sh &&
        echo "Y" | sh /tmp/install.sh > "$DIR/install.log"
fi

# Starship
log "Installing Starship"
SHARTSHIP="$(mktemp /tmp/shartship.XXXXX.sh)"
curl -sS -o "$SHARTSHIP" https://starship.rs/install.sh
sudo sh "$SHARTSHIP" -y > "$DIR/install.log"

# replacements
apt_inst zoxide
apt_inst exa
apt_inst fzf
apt_inst python3-pygments
apt_inst xclip
apt_inst neofetch

link .oh-my-zsh
link .zshrc
link .config/starship.toml



