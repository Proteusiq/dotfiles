#!/bin/bash
# macOS Setup Script
# Usage: ./install.sh [--dry-run] [--verbose] [--interactive] [--only <function>] [--versions]

set -euo pipefail

# =============================================================================
# Configuration
# =============================================================================

readonly DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
readonly LOG_FILE="${LOG_FILE:-$HOME/macos-setup.log}"

DRY_RUN=false
VERBOSITY=0 # 0=quiet, 1=normal, 2=debug
SKIP_INTERACTIVE=true
ONLY_FUNCTION=""
VERSION_CHANGES=()

# Source modules
source "$DOTFILES_DIR/scripts/logging.sh"
source "$DOTFILES_DIR/scripts/ui.sh"
source "$DOTFILES_DIR/scripts/versions.sh"

# Tools to track: name|version_cmd|type (type: cmd, git, uv)
readonly TRACKED_TOOLS=(
    "bun|bun|cmd"
    "n|n|cmd"
    ""
    "snowsql|snowsql|cmd"
    "repgrep|repgrep|cmd"
    "tpm|tpm|git"
    "yazi-flavors|yazi-flavors|git"
    "harlequin|harlequin|uv"
    "sqlit-tui|sqlit-tui|uv"
)

readonly AVAILABLE_FUNCTIONS=(
    "dirs:create_dirs"
    "xcode:install_xcode_tools"
    "brew:install_brew"
    "node:configure_node"
    "venv:create_virtualenvs"
    "tmux:install_tmux_plugins"
    "yazi:install_yazi_themes"
    "utils:setup_utils"
    "stow:stow_dotfiles"
    "cleanup:cleanup"
)

# Clone or update a git repository, track version changes
# Usage: git_install "tool_name" "url" "folder" "friendly_name"
git_install() {
    local tool="$1" url="$2" folder="$3" name="$4"
    local old_ver was_missing=false

    old_ver=$(get_version "$tool")
    [[ ! -d "$folder" ]] && was_missing=true

    if [[ ! -d "$folder" ]]; then
        run_quiet git clone "$url" "$folder"
    else
        [[ "$DRY_RUN" == false ]] && run_quiet git -C "$folder" pull --quiet 2>/dev/null || true
    fi

    if [[ "$was_missing" == true ]]; then
        log_info "✅ $name installed"
    else
        log_info "✅ $name already installed"
    fi

    [[ "$DRY_RUN" == false ]] && track_version "$tool" "$old_ver"
    return 0
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
    ${GREEN}--list${NC}                List functions with full descriptions
    ${GREEN}--versions${NC} [group]    Show installed versions
    ${GREEN}--info${NC} <tool>         Show info about an installed tool
    ${GREEN}--outdated${NC}            Show packages with available updates
    ${GREEN}--all${NC}                 Update all packages (brew, uv, cargo, git)
    ${GREEN}--interactive${NC}         Enable interactive prompts

${BOLD}Functions:${NC}
    ${BLUE}dirs${NC}        Create ~/Codes and ~/Documents/Screenshots
    ${BLUE}xcode${NC}       Install Xcode Command Line Tools
    ${BLUE}brew${NC}        Install Homebrew and Brewfile packages
    ${BLUE}node${NC}        Install Node.js tools (n, bun)
    ${BLUE}venv${NC}        Create Python virtual environments (neovim, debugpy)
    ${BLUE}tmux${NC}        Install tmux plugin manager (tpm)
    ${BLUE}yazi${NC}        Install Yazi file manager themes
    ${BLUE}utils${NC}       Install CLI utilities (gh-dash, repgrep)
    ${BLUE}stow${NC}        Symlink dotfiles with GNU Stow
    ${BLUE}cleanup${NC}     Run Homebrew cleanup and autoremove

${BOLD}Version Groups:${NC}  ${YELLOW}brew${NC} | ${YELLOW}cask${NC} | ${YELLOW}uv${NC} | ${YELLOW}cargo${NC} | ${YELLOW}git${NC} | ${YELLOW}other${NC} | ${YELLOW}all${NC}

${BOLD}Examples:${NC}
    update                        Full install (quiet mode)
    update bat                    Update only bat (auto-detects brew)
    update harlequin              Update only harlequin (auto-detects uv)
    update --outdated             Check for available updates
    update --all                  Update all packages
    update -v                     Full install with detailed output
    update --only brew            Install only Homebrew packages
    update --versions uv          Show Python UV tool versions
    update --info bat             Show info about bat

${BOLD}Environment:${NC}
    ${GREEN}DOTFILES_DIR${NC}    Dotfiles path (default: \$HOME/dotfiles)
    ${GREEN}LOG_FILE${NC}        Log path (default: \$HOME/macos-setup.log)

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
            ONLY_FUNCTION="$2"
            shift 2
            ;;
        --list)
            list_functions
            exit 0
            ;;
        --versions)
            local group=""
            # Check if next arg exists and is not another flag
            if [[ -n "${2:-}" && "${2:0:1}" != "-" ]]; then
                group="$2"
                shift
            fi
            show_installed_versions "$group"
            exit 0
            ;;
        --info)
            if [[ -z "${2:-}" || "${2:0:1}" == "-" ]]; then
                echo -e "${RED}Error: --info requires a tool name${NC}"
                echo -e "Usage: ${GREEN}update --info <tool>${NC}"
                exit 1
            fi
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
            # Positional argument - treat as tool name to update
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
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        log_error "Dotfiles directory not found at $DOTFILES_DIR"
        log_info "Please clone your dotfiles repository first"
        exit 1
    fi
    [[ ! -f "$DOTFILES_DIR/Brewfile" ]] && log_warn "Brewfile not found at $DOTFILES_DIR/Brewfile"
    return 0
}

create_dirs() {
    log_step "📁 Creating directories"
    local dirs=("$HOME/Codes" "$HOME/Documents/Screenshots")
    for dir in "${dirs[@]}"; do
        [[ ! -d "$dir" ]] && {
            execute mkdir -p "$dir"
            log "Created $dir"
        } || log_info "$dir already exists"
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

install_brew() {
    log_step "🍺 Installing Homebrew packages"

    if [[ "$DRY_RUN" == false ]] && ! has_cmd brew; then
        log "Installing Homebrew..."
        HOMEBREW_NO_INSTALL_FROM_API=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        [[ -f "$HOME/.zprofile" ]] && echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        [[ "$DRY_RUN" == false ]] && log_info "✅ Homebrew already installed"
        dry_run_msg "Would install/check Homebrew"
    fi

    if [[ "$DRY_RUN" == false ]]; then
        run_quiet brew update --force --quiet
        if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
            run_quiet brew bundle --file="$DOTFILES_DIR/Brewfile"
        else
            log_warn "Brewfile not found"
        fi
    else
        dry_run_msg "Would run: brew update && brew bundle"
    fi
}

configure_node() {
    log_step "📦 Installing Node.js tools"
    local old_n old_bun
    old_n=$(get_version "n")
    old_bun=$(get_version "bun")

    if [[ "$DRY_RUN" == false ]]; then
        if has_cmd npm; then
            run_quiet npm install -g n
        else
            log_warn "npm not found, skipping n"
        fi

        if [[ ! -f "$HOME/.bun/bin/bun" ]]; then
            log "Installing Bun..."
            run_quiet bash -c "$(curl -fsSL https://bun.sh/install)"
            [[ -f "$HOME/.bun/bin/bun" ]] && log_info "🍞 Baked bun v$("$HOME/.bun/bin/bun" --version)"
        else
            log_info "✅ Bun already installed: $("$HOME/.bun/bin/bun" --version)"
        fi

        track_version "n" "$old_n"
        track_version "bun" "$old_bun"
    else
        dry_run_msg "Would install n and Bun"
    fi
}

install_tmux_plugins() {
    log_step "💻 Installing tmux plugins"
    git_install "tpm" "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm" "tmux plugin manager"
}

install_yazi_themes() {
    log_step "🎨 Installing Yazi themes"
    execute mkdir -p "$HOME/.config/yazi"
    git_install "yazi-flavors" "https://github.com/yazi-rs/flavors.git" "$HOME/.config/yazi/flavors" "Yazi themes"
}

setup_utils() {
    log_step "🔧 Installing CLI utilities"

    # Capture versions before
    local old_repgrep old_harlequin old_sqlit old_snowsql
    old_repgrep=$(get_version "repgrep")
    old_snowsql=$(get_version "snowsql")
    old_harlequin=$(get_version "harlequin")
    old_sqlit=$(get_version "sqlit-tui")

    # Git LFS
    has_cmd git && run_quiet git lfs install

    # GitHub CLI extensions
    if has_cmd gh; then
        log "📊 Installing GitHub CLI extensions..."
        gh extension list 2>/dev/null | grep -q "dlvhdr/gh-dash" &&
            log_info "✅ gh-dash already installed" ||
            {
                run_quiet gh extension install dlvhdr/gh-dash
                log_info "✅ gh-dash installed"
            }
    fi

    # SnowSQL (installed manually or via Homebrew cask)
    local snowsql_bin="/Applications/SnowSQL.app/Contents/MacOS/snowsql"
    if [[ -f "$snowsql_bin" ]]; then
        log_info "✅ SnowSQL already installed"
    else
        log_info "⚠️  SnowSQL not found — install via: brew install --cask snowflake-snowsql"
    fi

    # UV tools
    if [[ "$DRY_RUN" == false ]] && has_cmd uv; then
        log "🔧 Installing/updating UV tools..."
        start_spinner
        for tool in harlequin sqlit-tui; do
            uv tool list 2>/dev/null | grep -q "^$tool " &&
                uv tool upgrade "$tool" >>"$LOG_FILE" 2>&1 ||
                uv tool install "$tool" >>"$LOG_FILE" 2>&1
        done
        stop_spinner
        log_info "✅ UV tools configured"
    else
        dry_run_msg "Would install/upgrade UV tools"
        [[ "$DRY_RUN" == false ]] && log_warn "UV not found, skipping tool installations"
    fi

    # Repgrep
    if ! has_cmd rgr && has_cmd cargo; then
        run_quiet cargo install repgrep
    fi
    execute touch "$HOME/.rgrc"

    # Custom scripts
    if [[ -d "$DOTFILES_DIR/bin" ]]; then
        execute mkdir -p "$HOME/.local/bin"
        for file in "$DOTFILES_DIR/bin"/*.py; do
            [[ -f "$file" ]] && {
                local name
                name=$(basename "${file%.py}")
                execute cp "$file" "$HOME/.local/bin/$name"
                execute chmod +x "$HOME/.local/bin/$name"
            }
        done
    fi

    # Track changes
    if [[ "$DRY_RUN" == false ]]; then
        track_version "snowsql" "$old_snowsql"

        track_version "repgrep" "$old_repgrep"
        track_version "harlequin" "$old_harlequin"
        track_version "sqlit-tui" "$old_sqlit"
    fi
    return 0
}

create_virtualenvs() {
    log_step "🐍 Creating Python virtual environments"

    if ! has_cmd uv; then
        [[ "$DRY_RUN" == true ]] && dry_run_msg "Would skip (UV not found)" || log_warn "UV not found"
        return 0
    fi
    [[ "$DRY_RUN" == true ]] && {
        dry_run_msg "Would create venvs: neovim, debugpy"
        return 0
    }

    local envs=(
        "$HOME/.virtualenvs/neovim|pynvim"
        "$HOME/.virtualenvs/debugpy|pynvim debugpy ruff"
    )

    execute mkdir -p "$HOME/.virtualenvs"
    for env in "${envs[@]}"; do
        IFS='|' read -r dir packages <<<"$env"
        [[ ! -d "$dir" ]] && {
            log "Creating venv: $(basename "$dir")"
            run_quiet uv venv "$dir"
        }
        log "Installing in $(basename "$dir"): $packages"
        run_quiet bash -c "source $dir/bin/activate && uv pip install --upgrade $packages && deactivate"
    done
    log_info "✅ Virtual environments configured"
}

stow_dotfiles() {
    log_step "🔗 Linking dotfiles"
    has_cmd stow || {
        log_error "GNU Stow not found. Install: brew install stow"
        return 1
    }

    local packages=(fzf git ghostty nvim sesh starship tmux zsh yazi aerospace)
    local existing=()

    for pkg in "${packages[@]}"; do
        [[ -d "$DOTFILES_DIR/$pkg" ]] && existing+=("$pkg") || log_warn "Not found: $pkg"
    done

    if [[ ${#existing[@]} -gt 0 ]]; then
        run_quiet stow --restow -d "$DOTFILES_DIR" -t "$HOME" "${existing[@]}"
        log_info "✅ Dotfiles stowed"
    else
        log_warn "No valid stow packages"
    fi
}

cleanup() {
    log_step "🧹 Cleaning up"
    if [[ "$DRY_RUN" == false ]] && has_cmd brew; then
        run_quiet brew cleanup --prune=all --quiet
        run_quiet brew autoremove --quiet
    else
        dry_run_msg "Would run Homebrew cleanup"
    fi
    log_info "✅ Cleanup completed"
}

# =============================================================================
# Main
# =============================================================================

main() {
    parse_args "$@"
    echo "macOS Setup Script - $(date)" >"$LOG_FILE"

    [[ "$DRY_RUN" == true ]] && log_step "DRY RUN MODE - No changes will be made"

    if [[ -n "$ONLY_FUNCTION" ]]; then
        local target_func
        target_func=$(get_function_by_name "$ONLY_FUNCTION") || {
            log_error "Unknown function: $ONLY_FUNCTION"
            list_functions
            exit 1
        }
        log_step "Running only: $target_func"
        $target_func || {
            log_error "Failed: $target_func"
            exit 1
        }
        [[ "$DRY_RUN" == false ]] && print_version_summary
        log_step "✅ $target_func completed!"
        return 0
    fi

    log_step "🐌 The World Changed! Beginning MacOS setup..."
    log "Log file: $LOG_FILE"

    local functions=(
        check_macos check_prerequisites create_dirs install_xcode_tools
        install_brew configure_node create_virtualenvs install_tmux_plugins
        install_yazi_themes setup_utils stow_dotfiles cleanup
    )

    for func in "${functions[@]}"; do
        $func || {
            log_error "Failed: $func"
            exit 1
        }
    done

    [[ "$DRY_RUN" == false ]] && print_version_summary
    log_step "🦊 The World is restored. Setup completed successfully!"
    log "📋 Log file: $LOG_FILE"
}

main "$@"
