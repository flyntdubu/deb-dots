#!/usr/bin/env bash
set -euo pipefail
shopt -s inherit_errexit

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

TIMESTAMP=$(date -d "today" +"%Y-%m-%d_%H-%M-%S")
BACKUPS="$DIR/backups/$TIMESTAMP"
LINK_DIR="$DIR/links"
LOGS="$DIR/install.log"

# Logging
function success() {
    echo -e "\e[32m[+] $*\e[0m" | tee "$DIR/install.log"
}

function log() {
    echo -e "\e[34m[*] $*\e[0m" | tee -a "$DIR/install.log"
}

function err() {
    echo -e "\e[31m[-] $*\e[0m" | tee -a "$DIR/install.log"
}

# Utility
function apt_inst() {
    if dpkg -s "$1" &> /dev/null; then
        log "Skipping $*."
    else
        log "Installing $*."
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y $* >> "$DIR/install.log" 2>> "$DIR/install.log" || err "Failed to install $*."
    fi
}


function apt_update() {
    sudo DEBIAN_FRONTEND=noninteractive apt-get update -y $* >> "$DIR/install.log"
}

function apt_upgrade() {
    sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y $* >> "$DIR/install.log"
}

function link() {
    if [ -L "$HOME/$1" ]; then
        log "$1 is a symlink. Removing the symlink."
        rm "$HOME/$1"
    elif [ -d "$HOME/$1" ]; then
        log "Removing directory $1."
        rm -rf "$HOME/$1"
    elif [ -f "$HOME/$1" ]; then
        log "Removing file $1."
        rm "$HOME/$1"
    else
        log "$1 does not exist, nothing to remove."
    fi
    log "Linking $1."
    ln -s "$LINK_DIR/$1" "$HOME/$1"
}
