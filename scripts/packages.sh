#!/bin/bash
# Stow packages: top-level directories linked into $HOME.
# Single list used by install.sh, scripts/doctor.sh and CI.
# shellcheck disable=SC2034 # used by the scripts that source this file
readonly STOW_PACKAGES=(aerospace atuin ghostty git mise nvim sesh starship tmux uv yazi zsh)

# Some casks need sudo. Keep the sudo timestamp fresh only while Homebrew runs,
# then drop it, so later third-party installers cannot use it.
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

# A cask needs admin rights when it installs a package or deletes under /Library.
cask_needs_sudo() {
    brew info --cask --json=v2 "$1" 2>/dev/null | grep -qE '"pkg"|"/Library'
}

# Upgrade outdated casks. Casks that need admin wait for --with-sudo, so an
# unattended update never blocks on a password prompt.
upgrade_casks() {
    local cask ready="" blocked="" needs_sudo
    while read -r cask; do
        [[ -n "$cask" ]] || continue
        needs_sudo=false
        cask_needs_sudo "$cask" && needs_sudo=true
        if [[ "$needs_sudo" == true ]]; then
            blocked="$blocked $cask"
            [[ "${WITH_SUDO:-false}" == true ]] || continue
        fi
        ready="$ready $cask"
    done < <(brew outdated --cask --quiet 2>/dev/null)

    if [[ -n "$blocked" && "${WITH_SUDO:-false}" != true ]]; then
        log_warn "Skipped casks that need admin:${blocked} (run: update --all --with-sudo)"
    fi

    local -a targets=()
    read -ra targets <<<"$ready" || true
    ((${#targets[@]} > 0)) || return 0

    local keepalive=false
    if [[ "${WITH_SUDO:-false}" == true && -n "$blocked" ]]; then
        start_sudo_keepalive || return 1
        keepalive=true
    fi
    local output="" status=0
    output="$(brew upgrade --cask "${targets[@]}" 2>&1)" || status=$?
    [[ -n "$output" ]] && printf '%s\n' "$output"
    [[ "$keepalive" == true ]] && stop_sudo_keepalive
    ((status == 0)) || log_warn "Some casks did not upgrade (see above)"
    return 0
}
