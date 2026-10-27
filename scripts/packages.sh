#!/bin/bash
# Stow packages: top-level directories linked into $HOME.
# Single list used by install.sh, scripts/doctor.sh and CI.
# shellcheck disable=SC2034 # used by the scripts that source this file
readonly STOW_PACKAGES=(aerospace atuin ghostty git mise nvim sesh starship tmux uv yazi zsh)

# Some casks need sudo. Keep the sudo timestamp fresh only while Homebrew runs,
# then drop it, so later third-party installers cannot use it. Plain sudo on
# purpose: the first install has no 1Password and no Touch ID yet, and no
# password is ever stored.
start_sudo_keepalive() {
    sudo -v || {
        log_error "Could not obtain sudo access"
        return 1
    }
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" 2>/dev/null || exit
    done &
    SUDO_KEEPALIVE_PID=$!
}

stop_sudo_keepalive() {
    [[ -n "${SUDO_KEEPALIVE_PID:-}" ]] || return 0
    kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
    SUDO_KEEPALIVE_PID=""
    sudo -k
}
