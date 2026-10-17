# Read by every zsh: interactive shells, scripts, IDEs and agents.
# Keep it fast and free of output and side effects.

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

export LANG="en_US.UTF-8"
export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"
export PAGER="less"
export LESS="-F -g -i -M -R -S -w -X -z-4"
export MANPAGER="nvim +Man!"

export PYTHONIOENCODING="UTF-8"
export RIPGREP_CONFIG_PATH="$HOME/.rgrc"
export GOPATH="$HOME/projects/go"
export GOBIN="$GOPATH/bin"
export PNPM_HOME="$HOME/Library/pnpm"
export PIXI_BETA_WARNING_OFF=true
export SNACKS_GHOSTTY=true

if [[ -x /opt/homebrew/bin/brew ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -x /usr/local/bin/brew ]]; then
    export HOMEBREW_PREFIX="/usr/local"
fi

# macOS runs path_helper from /etc/zprofile, which moves system directories to
# the front for login shells. ~/.zprofile calls this again to restore the order.
dotfiles_path() {
    typeset -gU path
    local -a brew_paths=()
    [[ -n "$HOMEBREW_PREFIX" ]] && brew_paths=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin")
    path=(
        "$HOME/.local/bin"
        "$XDG_DATA_HOME/mise/shims"
        "$HOME/.cargo/bin"
        "$GOBIN"
        "$PNPM_HOME"
        "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/rustup/bin"
        "${brew_paths[@]}"
        $path
        /usr/local/bin /usr/bin /bin /usr/sbin /sbin
    )
    path=($^path(N-/))
    export PATH
}

dotfiles_path
