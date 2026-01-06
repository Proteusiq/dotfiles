#!/bin/bash
# macOS Setup Script
# Usage: ./install.sh [--dry-run] [--verbose] [--interactive] [--only <function>] [--versions]

set -euo pipefail

# =============================================================================
# Configuration
# =============================================================================

readonly DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
readonly LOG_FILE="${LOG_FILE:-$HOME/macos-setup.log}"

readonly RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m' BOLD='\033[1m' NC='\033[0m'

DRY_RUN=false
VERBOSE=false
SKIP_INTERACTIVE=true
ONLY_FUNCTION=""
VERSION_CHANGES=()

# Tools to track: name|version_cmd|type (type: cmd, git, uv, llm-plugin)
readonly TRACKED_TOOLS=(
    "bun|bun|cmd"
    "n|n|cmd"
    "goose|goose|cmd"
    "repgrep|repgrep|cmd"
    "llm|llm|cmd"
    "tpm|tpm|git"
    "yazi-flavors|yazi-flavors|git"
    "harlequin|harlequin|uv"
    "sqlit-tui|sqlit-tui|uv"
    "llm-anthropic|llm-anthropic|llm-plugin"
    "llm-ollama|llm-ollama|llm-plugin"
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

# =============================================================================
# Core Utilities
# =============================================================================

log()       { echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $*${NC}" | tee -a "$LOG_FILE"; }
log_error() { echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*${NC}" | tee -a "$LOG_FILE" >&2; }
log_warn()  { echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $*${NC}" | tee -a "$LOG_FILE"; }
log_info()  { echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $*${NC}" | tee -a "$LOG_FILE"; }

execute() {
    [[ "$VERBOSE" == true ]] && log_info "Executing: $*"
    [[ "$DRY_RUN" == true ]] && { echo "[DRY RUN] Would execute: $*"; return 0; }
    "$@"
}

dry_run_msg() { [[ "$DRY_RUN" == true ]] && echo "[DRY RUN] $*"; }

has_cmd() { command -v "$1" &>/dev/null; }

# Clone or update a git repository. Returns 0 if cloned, 1 if already existed (but always succeeds)
git_clone_or_pull() {
    local url="$1" folder="$2"
    if [[ ! -d "$folder" ]]; then
        execute git clone "$url" "$folder"
        return 0
    fi
    [[ "$DRY_RUN" == false ]] && git -C "$folder" pull --quiet 2>/dev/null || true
    return 0
}

# Check if repo was freshly cloned (folder didn't exist before)
is_new_clone() {
    local folder="$1"
    [[ ! -d "$folder" ]]
}

# =============================================================================
# Version Detection
# =============================================================================

get_version() {
    local tool="$1"
    case "$tool" in
        bun)         [[ -f "$HOME/.bun/bin/bun" ]] && "$HOME/.bun/bin/bun" --version 2>/dev/null ;;
        goose)       has_cmd goose && goose --version 2>/dev/null | tr -d ' ' ;;
        llm)         has_cmd llm && llm --version 2>/dev/null | awk '{print $3}' ;;
        repgrep)     has_cmd rgr && cargo install --list 2>/dev/null | awk '/^repgrep/{print $2}' | tr -d 'v:' ;;
        n)           has_cmd npm && npm list -g --depth=0 2>/dev/null | sed -n 's/.*n@//p' ;;
        tpm)         [[ -d "$HOME/.tmux/plugins/tpm/.git" ]] && git -C "$HOME/.tmux/plugins/tpm" rev-parse --short HEAD 2>/dev/null ;;
        yazi-flavors) [[ -d "$HOME/.config/yazi/flavors/.git" ]] && git -C "$HOME/.config/yazi/flavors" rev-parse --short HEAD 2>/dev/null ;;
        *)           get_version_by_type "$tool" ;;
    esac
}

get_version_by_type() {
    local tool="$1"
    for entry in "${TRACKED_TOOLS[@]}"; do
        IFS='|' read -r name _ type <<< "$entry"
        [[ "$name" != "$tool" ]] && continue
        case "$type" in
            uv)         uv tool list 2>/dev/null | awk -v t="$tool" '$1==t{print $2}' | tr -d 'v' ;;
            llm-plugin) has_cmd llm && llm plugins 2>/dev/null | jq -r ".[] | select(.name==\"$tool\") | .version" 2>/dev/null ;;
        esac
        return
    done
}

record_change() {
    local tool="$1" old="$2" new="$3"
    [[ "$old" == "$new" || (-z "$old" && -z "$new") ]] && return
    local status="Updated"
    [[ -z "$old" ]] && { status="New"; old="-"; }
    VERSION_CHANGES+=("$tool|$old|$new|$status")
}

track_version() {
    local tool="$1" old="$2"
    record_change "$tool" "$old" "$(get_version "$tool")"
}

# =============================================================================
# Table Drawing
# =============================================================================

draw_table() {
    local -a headers=() widths=() rows=()
    local title=""
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --title)   title="$2"; shift 2 ;;
            --headers) IFS=',' read -ra headers <<< "$2"; shift 2 ;;
            --widths)  IFS=',' read -ra widths <<< "$2"; shift 2 ;;
            --rows)    IFS=';' read -ra rows <<< "$2"; shift 2 ;;
            *) shift ;;
        esac
    done

    [[ ${#rows[@]} -eq 0 ]] && return 1

    local hc="─" vc="│" tl="┌" tr="┐" bl="└" br="┘" ml="├" mr="┤" tm="┬" bm="┴" xc="┼"

    draw_hline() {
        local l="$1" m="$2" r="$3"
        local last_idx=$((${#widths[@]} - 1))
        local idx=0
        printf "${BLUE}%s" "$l"
        for w in "${widths[@]}"; do
            printf '%*s' "$w" '' | tr ' ' "$hc"
            [[ $idx -lt $last_idx ]] && printf "%s" "$m"
            ((idx++))
        done
        printf "%s${NC}\n" "$r"
    }

    draw_row() {
        local -a cells
        IFS='|' read -ra cells <<< "$1"
        local colors=("${@:2}")
        printf "${BLUE}%s${NC}" "$vc"
        for i in "${!cells[@]}"; do
            local color="${colors[$i]:-$NC}"
            printf " ${color}%-*s${NC}${BLUE}%s${NC}" "$((${widths[$i]} - 2))" "${cells[$i]}" "$vc"
        done
        printf "\n"
    }

    [[ -n "$title" ]] && { echo ""; log "$title"; echo ""; }
    
    draw_hline "$tl" "$tm" "$tr"
    
    local header_str="" hdr
    for hdr in "${headers[@]}"; do header_str+="$hdr|"; done
    draw_row "${header_str%|}" "$BOLD" "$BOLD" "$BOLD" "$BOLD"
    
    draw_hline "$ml" "$xc" "$mr"
    
    for row in "${rows[@]}"; do
        IFS='|' read -r _ _ _ status <<< "$row"
        local sc="$NC"
        [[ "$status" == "New" ]] && sc="$GREEN"
        [[ "$status" == "Updated" ]] && sc="$YELLOW"
        draw_row "$row" "$NC" "$RED" "$GREEN" "$sc"
    done
    
    draw_hline "$bl" "$bm" "$br"
    echo ""
}

print_section() {
    local icon="$1" title="$2"
    shift 2
    local -a items=()
    [[ $# -gt 0 ]] && items=("$@")
    
    [[ ${#items[@]} -eq 0 ]] && return
    
    # Calculate max widths
    local w1=4 w2=7
    for item in "${items[@]}"; do
        IFS='|' read -r name ver <<< "$item"
        (( ${#name} > w1 )) && w1=${#name}
        (( ${#ver} > w2 )) && w2=${#ver}
    done
    ((w1 += 2)); ((w2 += 2))
    
    local hc="─" vc="│"
    
    # Section header
    echo -e "${BOLD}${icon} ${title}${NC}"
    
    # Top border
    printf "${BLUE}┌%${w1}s┬%${w2}s┐${NC}\n" "" "" | tr ' ' "$hc"
    
    # Column headers
    printf "${BLUE}${vc}${NC} ${BOLD}%-$((w1-1))s${NC}${BLUE}${vc}${NC} ${BOLD}%-$((w2-1))s${NC}${BLUE}${vc}${NC}\n" "Tool" "Version"
    
    # Separator
    printf "${BLUE}├%${w1}s┼%${w2}s┤${NC}\n" "" "" | tr ' ' "$hc"
    
    # Data rows
    for item in "${items[@]}"; do
        IFS='|' read -r name ver <<< "$item"
        printf "${BLUE}${vc}${NC} %-$((w1-1))s${BLUE}${vc}${NC} ${GREEN}%-$((w2-1))s${NC}${BLUE}${vc}${NC}\n" "$name" "$ver"
    done
    
    # Bottom border
    printf "${BLUE}└%${w1}s┴%${w2}s┘${NC}\n" "" "" | tr ' ' "$hc"
    echo ""
}

readonly VERSION_GROUPS="brew|cask|uv|cargo|llm|git|other|all"

show_version_group_menu() {
    echo -e "\n${BOLD}Select a group to view:${NC}\n"
    echo -e "  ${GREEN}brew${NC}   - Homebrew Formulae"
    echo -e "  ${GREEN}cask${NC}   - Homebrew Casks"
    echo -e "  ${GREEN}uv${NC}     - UV Tools (Python)"
    echo -e "  ${GREEN}cargo${NC}  - Cargo Packages (Rust)"
    echo -e "  ${GREEN}llm${NC}    - LLM Plugins"
    echo -e "  ${GREEN}git${NC}    - Git Repositories"
    echo -e "  ${GREEN}other${NC}  - Other Tools (bun, n, goose)"
    echo -e "  ${GREEN}all${NC}    - All groups"
    echo ""
    echo -e "Usage: ${BOLD}./install.sh --versions <group>${NC}"
    echo ""
}

get_brew_versions() {
    local -a items=()
    if has_cmd brew; then
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            local name ver
            name=$(echo "$line" | awk '{print $1}')
            ver=$(echo "$line" | awk '{print $2}')
            [[ -n "$name" && -n "$ver" ]] && items+=("$name|$ver")
        done < <(brew list --formula --versions 2>/dev/null)
    fi
    [[ ${#items[@]} -gt 0 ]] && print_section "🍺" "Homebrew Formulae (${#items[@]})" "${items[@]}"
}

get_cask_versions() {
    local -a items=()
    if has_cmd brew; then
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            local name ver
            name=$(echo "$line" | awk '{print $1}')
            ver=$(echo "$line" | awk '{print $2}')
            [[ -n "$name" && -n "$ver" ]] && items+=("$name|$ver")
        done < <(brew list --cask --versions 2>/dev/null)
    fi
    [[ ${#items[@]} -gt 0 ]] && print_section "🖥️ " "Homebrew Casks (${#items[@]})" "${items[@]}"
}

get_uv_versions() {
    local -a items=()
    if has_cmd uv; then
        while IFS= read -r line; do
            [[ -z "$line" || "$line" == -* ]] && continue
            local name ver
            name=$(echo "$line" | awk '{print $1}')
            ver=$(echo "$line" | awk '{print $2}' | tr -d 'v')
            [[ -n "$name" && -n "$ver" ]] && items+=("$name|$ver")
        done < <(uv tool list 2>/dev/null)
    fi
    [[ ${#items[@]} -gt 0 ]] && print_section "🐍" "UV Tools (${#items[@]})" "${items[@]}"
}

get_cargo_versions() {
    local -a items=()
    if has_cmd cargo; then
        while IFS= read -r line; do
            [[ -z "$line" || "$line" == " "* ]] && continue
            local name ver
            name=$(echo "$line" | awk -F' v' '{print $1}')
            ver=$(echo "$line" | awk -F' v' '{print $2}' | tr -d ':')
            [[ -n "$name" && -n "$ver" ]] && items+=("$name|$ver")
        done < <(cargo install --list 2>/dev/null)
    fi
    [[ ${#items[@]} -gt 0 ]] && print_section "🦀" "Cargo Packages (${#items[@]})" "${items[@]}"
}

get_llm_versions() {
    local -a items=()
    if has_cmd llm && has_cmd jq; then
        while IFS= read -r line; do
            [[ -n "$line" ]] && items+=("$line")
        done < <(llm plugins 2>/dev/null | jq -r '.[] | "\(.name)|\(.version)"' 2>/dev/null)
    fi
    [[ ${#items[@]} -gt 0 ]] && print_section "🤖" "LLM Plugins (${#items[@]})" "${items[@]}"
}

get_git_versions() {
    local -a items=()
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    local yazi_dir="$HOME/.config/yazi/flavors"
    
    [[ -d "$tpm_dir/.git" ]] && items+=("tpm|$(git -C "$tpm_dir" rev-parse --short HEAD 2>/dev/null)")
    [[ -d "$yazi_dir/.git" ]] && items+=("yazi-flavors|$(git -C "$yazi_dir" rev-parse --short HEAD 2>/dev/null)")
    
    [[ ${#items[@]} -gt 0 ]] && print_section "📦" "Git Repositories (${#items[@]})" "${items[@]}"
}

get_other_versions() {
    local -a items=()
    
    [[ -f "$HOME/.bun/bin/bun" ]] && items+=("bun|$("$HOME/.bun/bin/bun" --version 2>/dev/null)")
    has_cmd npm && {
        local n_ver
        n_ver=$(npm list -g --depth=0 2>/dev/null | sed -n 's/.*n@//p')
        [[ -n "$n_ver" ]] && items+=("n|$n_ver")
    }
    has_cmd goose && items+=("goose|$(goose --version 2>/dev/null | tr -d ' ')")
    
    [[ ${#items[@]} -gt 0 ]] && print_section "⚙️ " "Other Tools (${#items[@]})" "${items[@]}"
}

show_installed_versions() {
    local group="${1:-}"
    
    # No group specified - show menu
    if [[ -z "$group" ]]; then
        show_version_group_menu
        return 0
    fi
    
    echo -e "\n${BOLD}Installed Tool Versions${NC}\n"
    
    case "$group" in
        brew)  get_brew_versions ;;
        cask)  get_cask_versions ;;
        uv)    get_uv_versions ;;
        cargo) get_cargo_versions ;;
        llm)   get_llm_versions ;;
        git)   get_git_versions ;;
        other) get_other_versions ;;
        all)
            get_brew_versions
            get_cask_versions
            get_uv_versions
            get_cargo_versions
            get_llm_versions
            get_git_versions
            get_other_versions
            ;;
        *)
            echo -e "${RED}Unknown group: $group${NC}"
            echo -e "Valid groups: ${GREEN}${VERSION_GROUPS}${NC}"
            return 1
            ;;
    esac
}

print_version_summary() {
    [[ ${#VERSION_CHANGES[@]} -eq 0 ]] && { log_info "No version changes detected."; return; }
    
    local -a changes=()
    for entry in "${VERSION_CHANGES[@]}"; do
        IFS='|' read -r _ _ _ status <<< "$entry"
        [[ "$status" == "New" || "$status" == "Updated" ]] && changes+=("$entry")
    done
    
    [[ ${#changes[@]} -eq 0 ]] && { log_info "No version changes detected."; return; }

    local w_tool=6 w_prev=10 w_new=9 w_status=8
    for entry in "${changes[@]}"; do
        IFS='|' read -r tool old new status <<< "$entry"
        (( ${#tool} + 2 > w_tool )) && w_tool=$((${#tool} + 2))
        (( ${#old} + 2 > w_prev )) && w_prev=$((${#old} + 2))
        (( ${#new} + 2 > w_new )) && w_new=$((${#new} + 2))
        (( ${#status} + 2 > w_status )) && w_status=$((${#status} + 2))
    done

    local rows=""
    for entry in "${changes[@]}"; do rows+="$entry;"; done
    
    draw_table \
        --title "📊 Version Changes Summary:" \
        --headers "Tool,Previous,Current,Status" \
        --widths "$w_tool,$w_prev,$w_new,$w_status" \
        --rows "${rows%;}"
}

# =============================================================================
# CLI Interface
# =============================================================================

show_help() {
    cat << 'EOF'
macOS Setup Script

Usage: ./install.sh [OPTIONS]

OPTIONS:
    --dry-run             Show what would be done without executing
    --verbose             Show detailed output
    --interactive         Enable interactive prompts (disabled by default)
    --only <function>     Run only the specified function
    --list                List all available functions
    --versions [group]    Show installed versions (brew|cask|uv|cargo|llm|git|other|all)
    -h, --help            Show this help message

ENVIRONMENT VARIABLES:
    DOTFILES_DIR        Path to dotfiles directory (default: $HOME/dotfiles)
    LOG_FILE            Path to log file (default: $HOME/macos-setup.log)
EOF
}

list_functions() {
    echo "Available functions for --only flag:"
    echo ""
    for entry in "${AVAILABLE_FUNCTIONS[@]}"; do
        printf "  %-12s -> %s\n" "${entry%%:*}" "${entry##*:}"
    done
    echo ""
    echo "Usage: $0 --only <name>"
}

get_function_by_name() {
    for entry in "${AVAILABLE_FUNCTIONS[@]}"; do
        [[ "${entry%%:*}" == "$1" ]] && { echo "${entry##*:}"; return 0; }
    done
    return 1
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)          DRY_RUN=true; shift ;;
            --verbose)          VERBOSE=true; shift ;;
            --interactive)      SKIP_INTERACTIVE=false; shift ;;
            --skip-interactive) SKIP_INTERACTIVE=true; shift ;;
            --only)             ONLY_FUNCTION="$2"; shift 2 ;;
            --list)             list_functions; exit 0 ;;
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
            -h|--help)          show_help; exit 0 ;;
            *)                  echo "Unknown option: $1" >&2; show_help; exit 1 ;;
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
    log "🔍 Checking prerequisites..."
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        log_error "Dotfiles directory not found at $DOTFILES_DIR"
        log_info "Please clone your dotfiles repository first"
        exit 1
    fi
    [[ ! -f "$DOTFILES_DIR/Brewfile" ]] && log_warn "Brewfile not found at $DOTFILES_DIR/Brewfile"
    return 0
}

create_dirs() {
    log "🗄 Creating directories..."
    local dirs=("$HOME/Codes" "$HOME/Documents/Screenshots")
    for dir in "${dirs[@]}"; do
        [[ ! -d "$dir" ]] && { execute mkdir -p "$dir"; log "Created $dir"; } || log_info "$dir already exists"
    done
}

install_xcode_tools() {
    log "🛠 Installing Xcode Command Line Tools..."
    
    if [[ "$DRY_RUN" == false ]] && xcode-select --print-path &>/dev/null; then
        log "✅ Xcode Command Line Tools already installed."
        return 0
    fi
    dry_run_msg "Would check/install Xcode Command Line Tools"
    
    if [[ "$SKIP_INTERACTIVE" == false ]]; then
        read -p "Xcode installation requires interaction. Continue? (y/N): " -n 1 -r
        echo
        [[ ! $REPLY =~ ^[Yy]$ ]] && { log_warn "Skipping Xcode installation"; return 0; }
    fi
    
    execute xcode-select --install
    
    if [[ "$DRY_RUN" == false ]]; then
        while ! xcode-select --print-path &>/dev/null; do
            sleep 5; echo "Waiting for Xcode Command Line Tools..."
        done
        [[ -d "/Applications/Xcode.app" ]] && {
            execute sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
            execute sudo xcodebuild -license accept
        }
    fi
    log "✅ Xcode Command Line Tools installed successfully"
}

install_brew() {
    log "🍺 Installing Homebrew and packages..."
    
    if [[ "$DRY_RUN" == false ]] && ! has_cmd brew; then
        log "Installing Homebrew..."
        HOMEBREW_NO_INSTALL_FROM_API=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        [[ -f "$HOME/.zprofile" ]] && echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        [[ "$DRY_RUN" == false ]] && log "✅ Homebrew already installed"
        dry_run_msg "Would install/check Homebrew"
    fi

    execute brew update --force --quiet
    [[ -f "$DOTFILES_DIR/Brewfile" ]] && execute brew bundle --file="$DOTFILES_DIR/Brewfile" || log_warn "Brewfile not found"
}

configure_node() {
    log "📦 Configuring Node..."
    local old_n old_bun
    old_n=$(get_version "n")
    old_bun=$(get_version "bun")
    
    if [[ "$DRY_RUN" == false ]]; then
        has_cmd npm && execute npm install -g n || log_warn "npm not found, skipping n"
        
        if [[ ! -f "$HOME/.bun/bin/bun" ]]; then
            log "Installing Bun..."
            bash -c "$(curl -fsSL https://bun.sh/install)"
            [[ -f "$HOME/.bun/bin/bun" ]] && log "🍞 Baked bun v$("$HOME/.bun/bin/bun" --version)"
        else
            log "✅ Bun already installed: $("$HOME/.bun/bin/bun" --version)"
        fi
        
        track_version "n" "$old_n"
        track_version "bun" "$old_bun"
    else
        dry_run_msg "Would install n and Bun"
    fi
}

install_tmux_plugins() {
    log "🖥 Installing tmux plugin manager..."
    local folder="$HOME/.tmux/plugins/tpm"
    local old_ver
    old_ver=$(get_version "tpm")
    local was_missing=false
    [[ ! -d "$folder" ]] && was_missing=true
    
    git_clone_or_pull "https://github.com/tmux-plugins/tpm" "$folder"
    
    if [[ "$was_missing" == true ]]; then
        log "✅ TMux plugin manager installed"
    else
        log "✅ TMux plugin manager already installed"
    fi
    [[ "$DRY_RUN" == false ]] && track_version "tpm" "$old_ver"
    return 0
}

install_yazi_themes() {
    log "🎨 Installing Yazi themes..."
    local folder="$HOME/.config/yazi/flavors"
    local old_ver
    old_ver=$(get_version "yazi-flavors")
    local was_missing=false
    [[ ! -d "$folder" ]] && was_missing=true
    
    execute mkdir -p "$HOME/.config/yazi"
    git_clone_or_pull "https://github.com/yazi-rs/flavors.git" "$folder"
    
    if [[ "$was_missing" == true ]]; then
        log "✅ Yazi themes installed"
    else
        log "✅ Yazi themes already installed"
    fi
    [[ "$DRY_RUN" == false ]] && track_version "yazi-flavors" "$old_ver"
    return 0
}

setup_utils() {
    log "🔧 Setting up additional utilities..."
    
    # Capture versions before
    local old_goose old_repgrep old_harlequin old_sqlit old_llm_anthropic old_llm_ollama
    old_goose=$(get_version "goose")
    old_repgrep=$(get_version "repgrep")
    old_harlequin=$(get_version "harlequin")
    old_sqlit=$(get_version "sqlit-tui")
    old_llm_anthropic=$(get_version "llm-anthropic")
    old_llm_ollama=$(get_version "llm-ollama")

    # Git LFS
    has_cmd git && execute git lfs install

    # GitHub CLI extensions
    if has_cmd gh; then
        log "📊 Installing GitHub CLI extensions..."
        gh extension list 2>/dev/null | grep -q "dlvhdr/gh-dash" \
            && log "✅ gh-dash already installed" \
            || { execute gh extension install dlvhdr/gh-dash; log "✅ gh-dash installed"; }
    fi

    # Goose
    has_cmd goose || {
        log "Installing Goose..."
        execute bash -c "$(curl -fsSL https://github.com/block/goose/releases/download/stable/download_cli.sh | CONFIGURE=false bash)"
    }

    # UV tools
    if [[ "$DRY_RUN" == false ]] && has_cmd uv; then
        log "🔧 Installing/updating UV tools..."
        for tool in llm harlequin sqlit-tui; do
            uv tool list 2>/dev/null | grep -q "^$tool " \
                && uv tool upgrade "$tool" &>/dev/null \
                || uv tool install "$tool" &>/dev/null
        done
        log "✅ UV tools configured"
    else
        dry_run_msg "Would install/upgrade UV tools"
        [[ "$DRY_RUN" == false ]] && log_warn "UV not found, skipping tool installations"
    fi

    # LLM configuration
    if [[ "$DRY_RUN" == false ]] && has_cmd llm; then
        export PATH="$HOME/.local/bin:$PATH"
        llm install llm-anthropic llm-ollama &>/dev/null
        llm --system 'Reply with linux terminal commands only, no extra information' --save cmd &>/dev/null
        llm --system 'Reply with neovim commands only, no extra information' --save nvim &>/dev/null
        llm models default claude-haiku-4.5 &>/dev/null
        log "✅ LLM configured"
    else
        dry_run_msg "Would configure LLM"
    fi

    # Repgrep
    ! has_cmd rgr && has_cmd cargo && execute cargo install repgrep
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
        track_version "goose" "$old_goose"
        track_version "repgrep" "$old_repgrep"
        track_version "harlequin" "$old_harlequin"
        track_version "sqlit-tui" "$old_sqlit"
        track_version "llm-anthropic" "$old_llm_anthropic"
        track_version "llm-ollama" "$old_llm_ollama"
    fi
    return 0
}

create_virtualenvs() {
    log "🐍 Creating Python Virtual Environments..."
    
    if ! has_cmd uv; then
        [[ "$DRY_RUN" == true ]] && dry_run_msg "Would skip (UV not found)" || log_warn "UV not found"
        return 0
    fi
    [[ "$DRY_RUN" == true ]] && { dry_run_msg "Would create venvs: neovim, debugpy"; return 0; }
    
    local envs=(
        "$HOME/.virtualenvs/neovim|pynvim"
        "$HOME/.virtualenvs/debugpy|pynvim debugpy ruff"
    )

    execute mkdir -p "$HOME/.virtualenvs"
    for env in "${envs[@]}"; do
        IFS='|' read -r dir packages <<< "$env"
        [[ ! -d "$dir" ]] && { log "Creating venv: $(basename "$dir")"; execute uv venv "$dir"; }
        log "Installing in $(basename "$dir"): $packages"
        bash -c "source $dir/bin/activate && uv pip install --upgrade $packages && deactivate"
    done
    log "✅ Virtual environments configured"
}

stow_dotfiles() {
    log "🐗 Stowing dotfiles..."
    has_cmd stow || { log_error "GNU Stow not found. Install: brew install stow"; return 1; }
    
    local packages=(fzf git ghostty nvim sesh starship tmux zsh yazi aerospace)
    local existing=()
    
    for pkg in "${packages[@]}"; do
        [[ -d "$DOTFILES_DIR/$pkg" ]] && existing+=("$pkg") || log_warn "Not found: $pkg"
    done
    
    [[ ${#existing[@]} -gt 0 ]] \
        && { execute stow --adopt -d "$DOTFILES_DIR" -t "$HOME" "${existing[@]}"; log "✅ Dotfiles stowed"; } \
        || log_warn "No valid stow packages"
}

cleanup() {
    log "🧹 Performing cleanup..."
    if [[ "$DRY_RUN" == false ]] && has_cmd brew; then
        brew cleanup --prune=all --quiet &>/dev/null
        brew autoremove --quiet &>/dev/null
    else
        dry_run_msg "Would run Homebrew cleanup"
    fi
    log "✅ Cleanup completed"
}

# =============================================================================
# Main
# =============================================================================

main() {
    parse_args "$@"
    echo "macOS Setup Script - $(date)" > "$LOG_FILE"
    
    [[ "$DRY_RUN" == true ]] && log_info "DRY RUN MODE - No changes will be made"
    
    if [[ -n "$ONLY_FUNCTION" ]]; then
        local target_func
        target_func=$(get_function_by_name "$ONLY_FUNCTION") || {
            log_error "Unknown function: $ONLY_FUNCTION"
            list_functions
            exit 1
        }
        log "Running only: $target_func"
        $target_func || { log_error "Failed: $target_func"; exit 1; }
        [[ "$DRY_RUN" == false ]] && print_version_summary
        log "✅ $target_func completed!"
        return 0
    fi
    
    log "🐌 The World Changed! Beginning MacOS setup..."
    log "Log file: $LOG_FILE"
    
    local functions=(
        check_macos check_prerequisites create_dirs install_xcode_tools
        install_brew configure_node create_virtualenvs install_tmux_plugins
        install_yazi_themes setup_utils stow_dotfiles cleanup
    )
    
    for func in "${functions[@]}"; do
        $func || { log_error "Failed: $func"; exit 1; }
    done
    
    [[ "$DRY_RUN" == false ]] && print_version_summary
    log "🦊 The World is restored. Setup completed successfully!"
    log "📋 Log file: $LOG_FILE"
}

main "$@"
