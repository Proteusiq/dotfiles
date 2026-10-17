#!/bin/bash
# Bootstrap: clone (or update) the dotfiles, then run install.sh.
# Usage:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/Proteusiq/dotfiles/main/run.sh)"
# Read this file before you run it; it is short on purpose.

set -euo pipefail

readonly REPO_URL="https://github.com/Proteusiq/dotfiles"
readonly DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log() { echo -e "${GREEN}▶ $*${NC}"; }
error() {
    echo -e "${RED}✗ $*${NC}" >&2
    exit 1
}

# /usr/bin/git is only a stub until the Xcode Command Line Tools are installed.
git_works() {
    xcode-select -p &>/dev/null && command -v git &>/dev/null
}

download_zip() {
    local zip
    zip="$(mktemp -t dotfiles).zip"
    curl -fsSL "$REPO_URL/archive/main.zip" -o "$zip" || error "Failed to download"
    unzip -q "$zip" -d "${zip%.zip}" || error "Failed to unzip"
    mv "${zip%.zip}/dotfiles-main" "$DOTFILES_DIR"
    rm -rf "$zip" "${zip%.zip}"
}

if [[ -d "$DOTFILES_DIR/.git" ]]; then
    log "Dotfiles found. Updating..."
    git -C "$DOTFILES_DIR" pull --ff-only || error "Failed to update repository"
elif [[ -d "$DOTFILES_DIR" ]]; then
    log "Dotfiles found (not a git clone). Using them as they are."
elif git_works; then
    log "Cloning dotfiles..."
    git clone "$REPO_URL" "$DOTFILES_DIR" || error "Failed to clone repository"
else
    log "Git is not available yet, downloading a zip..."
    download_zip
fi

log "Running install script..."
exec bash "$DOTFILES_DIR/install.sh"
