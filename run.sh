#!/bin/bash
# Bootstrap script for dotfiles installation
# Usage: curl -L https://bit.ly/42YwVdi | sh

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${GREEN}▶ $*${NC}"; }
error() { echo -e "${RED}✗ $*${NC}" >&2; exit 1; }

DOTFILES_DIR="$HOME/dotfiles"

if [[ -d "$DOTFILES_DIR" ]]; then
    log "Dotfiles found. Updating..."
    cd "$DOTFILES_DIR"
    git pull || error "Failed to update repository"
else
    log "Cloning dotfiles..."
    if command -v git &>/dev/null; then
        git clone https://github.com/proteusiq/dotfiles "$DOTFILES_DIR" || error "Failed to clone repository"
    else
        log "Git not found, downloading zip..."
        curl -fsSL https://github.com/proteusiq/dotfiles/archive/main.zip -o /tmp/dotfiles.zip || error "Failed to download"
        unzip -q /tmp/dotfiles.zip -d /tmp || error "Failed to unzip"
        mv /tmp/dotfiles-main "$DOTFILES_DIR"
        rm -f /tmp/dotfiles.zip
    fi
    cd "$DOTFILES_DIR"
fi

log "Running install script..."
chmod +x "$DOTFILES_DIR/install.sh"
exec "$DOTFILES_DIR/install.sh"
