#!/bin/bash
# macOS Setup Script
# Usage: ./install.sh [--dry-run] [--verbose] [--interactive] [--only <function>] [--versions]

set -euo pipefail

# =============================================================================
# Configuration
# =============================================================================

readonly DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
readonly LOG_FILE="${LOG_FILE:-${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/install.log}"
readonly BACKUP_ROOT="$HOME/.dotfiles-backup"
readonly UNSLOTH_DIR="$HOME/unsloth_studio"
# Default Python for uv and for python/python3 on PATH. Same file uv reads globally.
readonly PYTHON_VERSION_FILE="$DOTFILES_DIR/uv/.config/uv/.python-version"
readonly GH_EXTENSIONS=(dlvhdr/gh-dash)

DRY_RUN=false
VERBOSITY=0 # 0=quiet, 1=normal, 2=debug
SKIP_INTERACTIVE=true
ONLY_FUNCTION=""
SKIP_FUNCTIONS=()
FAILED_STEPS=()
VERSION_CHANGES=()
SUDO_KEEPALIVE_PID=""

# Source modules
source "$DOTFILES_DIR/scripts/packages.sh"
source "$DOTFILES_DIR/scripts/logging.sh"
source "$DOTFILES_DIR/scripts/ui.sh"
source "$DOTFILES_DIR/scripts/versions.sh"

readonly AVAILABLE_FUNCTIONS=(
    "dirs:create_dirs"
    "xcode:install_xcode_tools"
    "brew:install_brew"
    "stow:stow_dotfiles"
    "runtimes:install_runtimes"
    "venv:create_virtualenvs"
    "tmux:install_tmux_plugins"
    "yazi:install_yazi_themes"
    "utils:setup_utils"
    "macos:configure_macos"
    "cleanup:cleanup"
)

# Clone or update a git repository, track version changes
# Usage: git_install "tool_name" "url" "folder" "friendly_name"
git_install() {
    local tool="$1" url="$2" folder="$3" name="$4"
    local old_ver
    old_ver=$(get_version "$tool")

    if [[ ! -d "$folder" ]]; then
        run_quiet git clone --depth 1 "$url" "$folder" || return 1
        log_info "✅ $name installed"
    else
        run_quiet git -C "$folder" pull --ff-only --quiet || log_warn "Could not update $name"
        log_info "✅ $name up to date"
    fi

    [[ "$DRY_RUN" == false ]] && track_version "$tool" "$old_ver"
    return 0
}

# Run a third-party install script from its official URL, never with sudo.
# Usage: run_remote_installer "name" "https://url/install.sh" [workdir]
run_remote_installer() {
    local name="$1" url="$2" workdir="${3:-$HOME}"
    if [[ "$DRY_RUN" == true ]]; then
        dry_run_msg "Would run the $name installer from $url"
        return 0
    fi
    log "Running the $name installer from $url"
    local script rc=0
    script="$(mktemp)"
    run_quiet curl -fsSL -o "$script" "$url" || {
        rm -f "$script"
        return 1
    }
    # shellcheck disable=SC2016 # expanded by the inner bash
    run_quiet bash -c 'cd "$1" && sh "$2"' _ "$workdir" "$script" || rc=$?
    rm -f "$script"
    return $rc
}

# =============================================================================
# CLI Interface
# =============================================================================

show_help() {
    echo -e "Modern macOS dotfiles installer

${BOLD}Usage:${NC} update [OPTIONS] [TOOL]

${BOLD}Options:${NC}
    ${GREEN}-h${NC}, ${GREEN}--help${NC}            Show this help message
    ${GREEN}-v${NC}, ${GREEN}--verbose${NC}         Show detailed output with timestamps
    ${GREEN}-vv${NC}                   Debug mode (show executed commands)
    ${GREEN}--dry-run${NC}             Preview changes without executing
    ${GREEN}--only${NC} <fn>           Run only a specific function
    ${GREEN}--skip${NC} \"<fn...>\"      Skip functions; quote several (e.g., --skip \"venv brew\")
    ${GREEN}--list${NC}                List functions with full descriptions
    ${GREEN}--versions${NC} [group]    Show installed versions
    ${GREEN}--info${NC} <tool>         Show info about an installed tool
    ${GREEN}--outdated${NC}            Show packages with available updates
    ${GREEN}--all${NC}                 Update all packages (brew, uv, cargo, mise, git)
    ${GREEN}--doctor${NC}              Check links, PATH order, configs and Brewfile
    ${GREEN}--interactive${NC}         Enable interactive prompts

${BOLD}Functions:${NC}
    ${BLUE}dirs${NC}        Create ~/Codes and ~/Documents/Screenshots
    ${BLUE}xcode${NC}       Install Xcode Command Line Tools
    ${BLUE}brew${NC}        Install Homebrew and everything in the Brewfile (brew, cask, uv, cargo)
    ${BLUE}stow${NC}        Symlink dotfiles with GNU Stow (backs up conflicting files)
    ${BLUE}runtimes${NC}    Install Python (uv, version from uv/.config/uv/.python-version), mise runtimes and Rust
    ${BLUE}venv${NC}        Create the Python venv Neovim uses for plugins (pynvim)
    ${BLUE}tmux${NC}        Install tmux plugin manager (tpm) and plugins
    ${BLUE}yazi${NC}        Install Yazi file manager themes
    ${BLUE}utils${NC}       Install extras: gh extensions, Bicep, Herdr, Unsloth Studio, bin scripts
    ${BLUE}macos${NC}       Configure macOS: Touch ID for sudo, screenshot folder
    ${BLUE}cleanup${NC}     Run Homebrew cleanup and autoremove

${BOLD}Version Groups:${NC}  ${YELLOW}brew${NC} | ${YELLOW}cask${NC} | ${YELLOW}uv${NC} | ${YELLOW}cargo${NC} | ${YELLOW}mise${NC} | ${YELLOW}git${NC} | ${YELLOW}other${NC} | ${YELLOW}all${NC}

${BOLD}Examples:${NC}
    update                        Full install (quiet mode)
    update bat                    Update only bat (auto-detects brew)
    update harlequin              Update only harlequin (auto-detects uv)
    update --outdated             Check for available updates
    update --all                  Update all packages
    update --doctor               Check that the setup is healthy
    update -v                     Full install with detailed output
    update --only brew            Install only Homebrew packages
    update --skip venv            Skip venv setup
    update --skip \"venv brew\"     Skip multiple functions
    update --versions uv          Show Python UV tool versions
    update --info bat             Show info about bat

${BOLD}Environment:${NC}
    ${GREEN}DOTFILES_DIR${NC}    Dotfiles path (default: \$HOME/dotfiles)
    ${GREEN}LOG_FILE${NC}        Log path (default: \$XDG_STATE_HOME/dotfiles/install.log)

${YELLOW}Note:${NC} If 'update' alias is unavailable, run ~/dotfiles/install.sh directly"
}

list_functions() {
    echo -e "${BOLD}Available functions for --only flag:${NC}"
    echo ""
    for entry in "${AVAILABLE_FUNCTIONS[@]}"; do
        printf "  ${BLUE}%-12s${NC} %s\n" "${entry%%:*}" "${entry##*:}"
    done
    echo ""
    echo -e "Usage: ${GREEN}update --only <name>${NC}"
}

get_function_by_name() {
    for entry in "${AVAILABLE_FUNCTIONS[@]}"; do
        [[ "${entry%%:*}" == "$1" ]] && {
            echo "${entry##*:}"
            return 0
        }
    done
    return 1
}

should_skip() {
    local fn_name="$1"
    for skip in ${SKIP_FUNCTIONS[@]+"${SKIP_FUNCTIONS[@]}"}; do
        [[ "$skip" == "$fn_name" ]] && return 0
    done
    return 1
}

require_value() {
    local flag="$1" value="${2:-}"
    if [[ -z "$value" || "${value:0:1}" == "-" ]]; then
        echo -e "${RED}Error: $flag requires a value${NC}" >&2
        exit 1
    fi
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -v | --verbose)
            VERBOSITY=1
            shift
            ;;
        -vv)
            VERBOSITY=2
            shift
            ;;
        --interactive)
            SKIP_INTERACTIVE=false
            shift
            ;;
        --skip-interactive)
            SKIP_INTERACTIVE=true
            shift
            ;;
        --only)
            require_value "--only" "${2:-}"
            ONLY_FUNCTION="$2"
            shift 2
            ;;
        --skip)
            require_value "--skip" "${2:-}"
            read -ra skip_args <<<"$2"
            for skip_fn in "${skip_args[@]}"; do
                if ! get_function_by_name "$skip_fn" &>/dev/null; then
                    echo -e "${RED}Error: Unknown function to skip: $skip_fn${NC}"
                    list_functions
                    exit 1
                fi
                SKIP_FUNCTIONS+=("$skip_fn")
            done
            shift 2
            ;;
        --list)
            list_functions
            exit 0
            ;;
        --versions)
            local group=""
            if [[ -n "${2:-}" && "${2:0:1}" != "-" ]]; then
                group="$2"
                shift
            fi
            show_installed_versions "$group"
            exit 0
            ;;
        --info)
            require_value "--info" "${2:-}"
            get_tool_info "$2"
            exit $?
            ;;
        --outdated)
            show_outdated
            exit 0
            ;;
        --all)
            update_all
            exit 0
            ;;
        --doctor)
            "$DOTFILES_DIR/scripts/doctor.sh"
            exit $?
            ;;
        -h | --help)
            show_help
            exit 0
            ;;
        -*)
            echo "Unknown option: $1" >&2
            show_help
            exit 1
            ;;
        *)
            update_tool "$1"
            exit $?
            ;;
        esac
    done

}

# =============================================================================
# Setup Functions
# =============================================================================

check_macos() {
    if [[ "$(uname)" != "Darwin" ]]; then
        log_error "This script is designed for macOS only."
        exit 1
    fi
}

check_prerequisites() {
    log_step "📋 Checking prerequisites"
    [[ -f "$DOTFILES_DIR/Brewfile" ]] || {
        log_error "Brewfile not found at $DOTFILES_DIR/Brewfile"
        return 1
    }
}

create_dirs() {
    log_step "📁 Creating directories"
    local dir
    for dir in "$HOME/Codes" "$HOME/Documents/Screenshots" "$(dirname "$LOG_FILE")"; do
        if [[ -d "$dir" ]]; then
            log_info "$dir already exists"
        else
            execute mkdir -p "$dir"
            log "Created $dir"
        fi
    done
}

install_xcode_tools() {
    log_step "🔨 Installing Xcode CLI"

    if [[ "$DRY_RUN" == false ]] && xcode-select --print-path &>/dev/null; then
        log_info "✅ Xcode Command Line Tools already installed."
        return 0
    fi
    dry_run_msg "Would check/install Xcode Command Line Tools"

    if [[ "$SKIP_INTERACTIVE" == false ]]; then
        read -p "Xcode installation requires interaction. Continue? (y/N): " -n 1 -r
        echo
        [[ ! $REPLY =~ ^[Yy]$ ]] && {
            log_warn "Skipping Xcode installation"
            return 0
        }
    fi

    execute xcode-select --install

    if [[ "$DRY_RUN" == false ]]; then
        while ! xcode-select --print-path &>/dev/null; do
            sleep 5
            echo "Waiting for Xcode Command Line Tools..."
        done
        [[ -d "/Applications/Xcode.app" ]] && {
            execute sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
            execute sudo xcodebuild -license accept
        }
    fi
    log_info "✅ Xcode Command Line Tools installed successfully"
}

# Homebrew blocks third-party taps until you trust them. Only taps declared with
# an explicit `tap` line in the Brewfile are trusted, so adding one is a reviewed change.
trust_brewfile_taps() {
    local tap
    while read -r tap; do
        run_quiet brew trust "$tap" || return 1
    done < <(sed -nE 's/^tap "([^"]+)".*/\1/p' "$DOTFILES_DIR/Brewfile")
}

install_brew() {
    log_step "🍺 Installing Homebrew packages"

    if [[ "$DRY_RUN" == true ]]; then
        dry_run_msg "Would install Homebrew if missing, then run: brew update && brew bundle"
        return 0
    fi

    if ! has_cmd brew; then
        log "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        local brew_bin
        for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
            [[ -x "$brew_bin" ]] && eval "$("$brew_bin" shellenv)" && break
        done
    fi

    run_quiet brew update --quiet || log_warn "brew update failed; using the current formulae"
    trust_brewfile_taps || return 1

    start_sudo_keepalive || return 1
    run_quiet brew bundle install --file="$DOTFILES_DIR/Brewfile"
    ensure_rust_toolchain
    # cargo and uv entries need the toolchains above. A second pass picks them up.
    if ! brew bundle check --no-upgrade --file="$DOTFILES_DIR/Brewfile" &>/dev/null; then
        run_quiet brew bundle install --file="$DOTFILES_DIR/Brewfile"
    fi
    stop_sudo_keepalive

    if brew bundle check --no-upgrade --file="$DOTFILES_DIR/Brewfile" &>/dev/null; then
        log_info "✅ Everything in the Brewfile is installed"
    else
        log_error "Some Brewfile entries are missing. Run: brew bundle check --verbose --file=$DOTFILES_DIR/Brewfile"
        return 1
    fi
}

ensure_rust_toolchain() {
    has_cmd rustup || return 0
    rustup default &>/dev/null && return 0
    log "Installing the stable Rust toolchain..."
    run_quiet rustup default stable
}

# Symlinks that stow may own: top level of $HOME and anything under ~/.config
list_home_links() {
    find "$HOME" -maxdepth 1 -type l 2>/dev/null
    find "$HOME/.config" -maxdepth 5 -type l 2>/dev/null
}

# Stow refuses to replace real files. Move them to a timestamped backup first,
# and remove links that point to files no longer in the repository.
prepare_stow_targets() {
    local -a packages=("$@")
    local backup_dir link target conflict
    backup_dir="$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)"

    while IFS= read -r link; do
        target="$(readlink "$link")"
        [[ "$target" == *dotfiles/* && ! -e "$link" ]] || continue
        execute rm "$link"
        log_info "Removing stale link $link"
    done < <(list_home_links)

    while IFS= read -r conflict; do
        [[ -n "$conflict" ]] || continue
        execute mkdir -p "$backup_dir/$(dirname "$conflict")"
        execute mv "$HOME/$conflict" "$backup_dir/$conflict"
        log_warn "Moved ~/$conflict to $backup_dir/$conflict"
    done < <(stow --no --no-folding --restow -d "$DOTFILES_DIR" -t "$HOME" "${packages[@]}" 2>&1 |
        sed -nE 's/.*over existing target (.*) since.*/\1/p; s/.*existing target is not owned by stow: (.*)/\1/p')
}

stow_dotfiles() {
    log_step "🔗 Linking dotfiles"
    has_cmd stow || {
        log_error "GNU Stow not found. Install: brew install stow"
        return 1
    }

    local -a existing=()
    local pkg
    for pkg in "${STOW_PACKAGES[@]}"; do
        if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
            existing+=("$pkg")
        else
            log_warn "Not found: $pkg"
        fi
    done
    [[ ${#existing[@]} -gt 0 ]] || {
        log_warn "No valid stow packages"
        return 0
    }

    prepare_stow_targets "${existing[@]}"
    run_quiet stow --no-folding --restow -d "$DOTFILES_DIR" -t "$HOME" "${existing[@]}" || return 1
    log_info "✅ Dotfiles stowed"
}

python_version() {
    tr -d '[:space:]' <"$PYTHON_VERSION_FILE"
}

# Install the pinned Python with uv, upgrade it to the latest patch release, and
# link python and python3 in ~/.local/bin (first on PATH) to it.
install_default_python() {
    has_cmd uv || {
        log_warn "uv not found; run 'update --only brew' first"
        return 0
    }
    local version
    version="$(python_version)"
    run_quiet uv python install --upgrade --default --preview-features python-install-default "$version" || return 1
    log_info "✅ Python $version is the default python and python3"
}

install_runtimes() {
    log_step "📦 Installing runtimes"
    if [[ "$DRY_RUN" == true ]]; then
        dry_run_msg "Would run: uv python install $(python_version) --default && mise install && rustup default stable"
        return 0
    fi

    install_default_python || return 1

    if has_cmd mise; then
        run_quiet env MISE_YES=1 mise install || return 1
        log_info "✅ mise runtimes installed"
    else
        log_warn "mise not found; run 'update --only brew' first"
    fi
    ensure_rust_toolchain
}

install_tmux_plugins() {
    log_step "💻 Installing tmux plugins"
    git_install "tpm" "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm" "tmux plugin manager" || return 1
    [[ "$DRY_RUN" == false ]] && run_quiet "$HOME/.tmux/plugins/tpm/bin/install_plugins"
    return 0
}

install_yazi_themes() {
    log_step "🎨 Installing Yazi themes"
    execute mkdir -p "$HOME/.config/yazi"
    git_install "yazi-flavors" "https://github.com/yazi-rs/flavors.git" "$HOME/.config/yazi/flavors" "Yazi themes"
}

install_gh_extensions() {
    has_cmd gh || return 0
    local extension
    for extension in "${GH_EXTENSIONS[@]}"; do
        if gh extension list 2>/dev/null | grep -q "$extension"; then
            log_info "✅ $extension already installed"
        else
            run_quiet gh extension install "$extension" && log_info "✅ $extension installed"
        fi
    done
}

link_bin_scripts() {
    execute mkdir -p "$HOME/.local/bin"
    local file name
    for file in "$DOTFILES_DIR/bin"/*.py; do
        [[ -f "$file" ]] || continue
        name="$(basename "${file%.py}")"
        execute ln -sfn "$file" "$HOME/.local/bin/$name"
    done
}

setup_utils() {
    log_step "🔧 Installing CLI utilities"

    has_cmd git && run_quiet git lfs install
    install_gh_extensions

    if has_cmd az && ! az bicep version &>/dev/null; then
        run_quiet az bicep install && log_info "✅ Bicep installed"
    fi

    local old_herdr
    old_herdr=$(get_version "herdr")
    if has_cmd herdr; then
        log_info "✅ Herdr already installed"
    else
        run_remote_installer "Herdr" "https://herdr.dev/install.sh" && log_info "✅ Herdr installed"
    fi
    [[ "$DRY_RUN" == false ]] && track_version "herdr" "$old_herdr"

    if [[ -d "$UNSLOTH_DIR" ]]; then
        log_info "✅ Unsloth Studio already installed"
    else
        run_remote_installer "Unsloth Studio" "https://unsloth.ai/install.sh" "$HOME" &&
            log_info "✅ Unsloth Studio installed"
    fi

    execute touch "$HOME/.rgrc"
    link_bin_scripts
    return 0
}

create_virtualenvs() {
    log_step "🐍 Creating Python virtual environments"

    if ! has_cmd uv; then
        log_warn "uv not found; run 'update --only brew' first"
        return 0
    fi
    [[ "$DRY_RUN" == true ]] && {
        dry_run_msg "Would create venv: neovim"
        return 0
    }

    local -a envs=(
        "$HOME/.virtualenvs/neovim|pynvim"
    )
    local env dir packages version
    version="$(python_version)"
    execute mkdir -p "$HOME/.virtualenvs"
    for env in "${envs[@]}"; do
        IFS='|' read -r dir packages <<<"$env"
        # Recreate the venv when it was built with another Python version.
        if [[ ! -x "$dir/bin/python" ]] || ! "$dir/bin/python" -c "import sys; sys.exit(f'{sys.version_info[0]}.{sys.version_info[1]}' != '$version')"; then
            run_quiet uv venv --clear --python "$version" "$dir" || return 1
        fi
        # shellcheck disable=SC2086 # packages is a space-separated list
        run_quiet uv pip install --python "$dir/bin/python" --upgrade $packages || return 1
    done
    log_info "✅ Virtual environments configured"
}

# Touch ID for sudo, also inside tmux (pam_reattach). sudo_local survives macOS updates.
# A Mac without a sensor (or a desktop without its Touch ID keyboard) still asks
# for the password, but do not write the module where it cannot answer.
has_touch_id() {
    ioreg -c AppleBiometricSensor -r -d 1 2>/dev/null | grep -q "AppleBiometricSensor"
}

enable_touch_id_sudo() {
    local sudo_local="/etc/pam.d/sudo_local"
    local reattach="${HOMEBREW_PREFIX:-/opt/homebrew}/lib/pam/pam_reattach.so"
    has_touch_id || {
        log_info "No Touch ID sensor reported; sudo keeps asking for your password"
        return 0
    }
    grep -qs "pam_tid.so" "$sudo_local" && {
        log_info "✅ Touch ID for sudo already enabled"
        return 0
    }
    local config="auth       sufficient     pam_tid.so"
    [[ -f "$reattach" ]] && config="auth       optional       $reattach ignore_ssh
$config"
    if [[ "$DRY_RUN" == true ]]; then
        dry_run_msg "Would write $sudo_local"
        return 0
    fi
    printf '%s\n' "$config" | sudo tee "$sudo_local" >/dev/null && log_info "✅ Touch ID for sudo enabled"
}

configure_macos() {
    log_step "🍎 Configuring macOS"
    enable_touch_id_sudo
    execute defaults write com.apple.screencapture location -string "$HOME/Documents/Screenshots"
    execute killall SystemUIServer 2>/dev/null || true
    log_info "✅ Screenshots saved to ~/Documents/Screenshots"
}

cleanup() {
    log_step "🧹 Cleaning up"
    if [[ "$DRY_RUN" == false ]] && has_cmd brew; then
        run_quiet brew cleanup --prune=all --quiet
        run_quiet brew autoremove --quiet
        local undeclared
        undeclared="$(brew bundle cleanup --file="$DOTFILES_DIR/Brewfile" 2>/dev/null | grep -vE '^(Would|Run )' || true)"
        [[ -n "$undeclared" ]] && log_warn "Installed but not in the Brewfile (review with: brew bundle cleanup --file=$DOTFILES_DIR/Brewfile):
$undeclared"
    else
        dry_run_msg "Would run Homebrew cleanup"
    fi
    log_info "✅ Cleanup completed"
}

# =============================================================================
# Main
# =============================================================================

on_exit() {
    stop_spinner
    stop_sudo_keepalive
}

run_step() {
    local func="$1"
    "$func" && return 0
    FAILED_STEPS+=("$func")
    log_error "Step failed: $func (continuing)"
}

report_failures() {
    [[ ${#FAILED_STEPS[@]} -eq 0 && ${#FAILED_COMMANDS[@]} -eq 0 ]] && return 0
    log_error "Setup finished with failures. Details in $LOG_FILE"
    local item
    for item in ${FAILED_STEPS[@]+"${FAILED_STEPS[@]}"}; do log_error "  step: $item"; done
    for item in ${FAILED_COMMANDS[@]+"${FAILED_COMMANDS[@]}"}; do log_error "  command: $item"; done
    return 1
}

main() {
    trap on_exit EXIT
    trap 'exit 130' INT TERM
    parse_args "$@"
    mkdir -p "$(dirname "$LOG_FILE")"
    echo "macOS Setup Script - $(date)" >"$LOG_FILE"

    check_macos
    check_prerequisites
    [[ "$DRY_RUN" == true ]] && log_step "DRY RUN MODE - No changes will be made"

    if [[ -n "$ONLY_FUNCTION" ]]; then
        local target_func
        target_func=$(get_function_by_name "$ONLY_FUNCTION") || {
            log_error "Unknown function: $ONLY_FUNCTION"
            list_functions
            exit 1
        }
        log_step "Running only: $target_func"
        run_step "$target_func"
        [[ "$DRY_RUN" == false ]] && print_version_summary
        report_failures || exit 1
        log_step "✅ $target_func completed!"
        return 0
    fi

    log_step "🐌 The World Changed! Beginning MacOS setup..."
    log "Log file: $LOG_FILE"

    local entry short_name func
    for entry in "${AVAILABLE_FUNCTIONS[@]}"; do
        short_name="${entry%%:*}"
        func="${entry##*:}"
        if should_skip "$short_name"; then
            log_info "⏭️  Skipping $func (--skip $short_name)"
            continue
        fi
        run_step "$func"
    done

    [[ "$DRY_RUN" == false ]] && print_version_summary
    report_failures || exit 1
    log_step "🦊 The World is restored. Setup completed successfully!"
    log "📋 Log file: $LOG_FILE"
}

main "$@"
