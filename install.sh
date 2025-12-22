#!/bin/bash

# A utility script to set up a new macOS environment
# Version: 2.0: Claude-4: Prompt: Make my script better 
# Usage: ./setup.sh [--dry-run] [--verbose] [--skip-interactive] [--only <function>]

set -euo pipefail

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
readonly DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
readonly ZSHHOME="$DOTFILES_DIR/zsh"
readonly LOG_FILE="${LOG_FILE:-$HOME/macos-setup.log}"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Flags
DRY_RUN=false
VERBOSE=false
SKIP_INTERACTIVE=true
ONLY_FUNCTION=""

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --verbose)
                VERBOSE=true
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
            -h|--help)
                show_help
                exit 0
                ;;
            --only)
                ONLY_FUNCTION="$2"
                shift 2
                ;;
            --list)
                list_functions
                exit 0
                ;;
            *)
                echo "Unknown option: $1" >&2
                show_help
                exit 1
                ;;
        esac
    done
}

show_help() {
    cat << EOF
macOS Setup Script

Usage: $0 [OPTIONS]

OPTIONS:
    --dry-run           Show what would be done without executing
    --verbose           Show detailed output
    --interactive       Enable interactive prompts (disabled by default)
    --skip-interactive  Disable interactive prompts (default behavior)
    --only <function>   Run only the specified function
    --list              List all available functions
    -h, --help          Show this help message

ENVIRONMENT VARIABLES:
    DOTFILES_DIR        Path to dotfiles directory (default: \$HOME/dotfiles)
    LOG_FILE            Path to log file (default: \$HOME/macos-setup.log)

EXAMPLES:
    $0 --only stow       # Only run the stow_dotfiles function
    $0 --only cleanup    # Only run the cleanup function
    $0 --only utils      # Only run the setup_utils function
    $0 --list            # Show all available functions
EOF
}

# Available functions for --only flag
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

list_functions() {
    echo "Available functions for --only flag:"
    echo ""
    for entry in "${AVAILABLE_FUNCTIONS[@]}"; do
        local name="${entry%%:*}"
        local func="${entry##*:}"
        printf "  %-12s -> %s\n" "$name" "$func"
    done
    echo ""
    echo "Usage: $0 --only <name>"
}

get_function_by_name() {
    local name="$1"
    for entry in "${AVAILABLE_FUNCTIONS[@]}"; do
        local entry_name="${entry%%:*}"
        local entry_func="${entry##*:}"
        if [[ "$entry_name" == "$name" ]]; then
            echo "$entry_func"
            return 0
        fi
    done
    return 1
}

# Logging functions
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $*${NC}" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*${NC}" | tee -a "$LOG_FILE" >&2
}

log_warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $*${NC}" | tee -a "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] INFO: $*${NC}" | tee -a "$LOG_FILE"
}

# Execute command with dry-run support
execute() {
    if [[ "$VERBOSE" == true ]]; then
        log_info "Executing: $*"
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would execute: $*"
        return 0
    fi
    
    "$@"
}

# Check if running on macOS
check_macos() {
    if [[ "$(uname)" != "Darwin" ]]; then
        log_error "This script is designed for macOS only."
        exit 1
    fi
}

# Check prerequisites
check_prerequisites() {
    log "🔍 Checking prerequisites..."
    
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        log_error "Dotfiles directory not found at $DOTFILES_DIR"
        log_info "Please clone your dotfiles repository first:"
        log_info "git clone <your-dotfiles-repo> $DOTFILES_DIR"
        exit 1
    fi
    
    if [[ ! -f "$DOTFILES_DIR/Brewfile" ]]; then
        log_warn "Brewfile not found at $DOTFILES_DIR/Brewfile"
        log_warn "Some packages may not be installed"
    fi
}

# Function to create directories with better error handling
create_dirs() {
    log "🗄 Creating directories..."
    local dirs=(
        "$HOME/Codes"
        "$HOME/Documents/Screenshots"
    )
    
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            execute mkdir -p "$dir"
            log "Created $dir"
        else
            log_info "$dir already exists"
        fi
    done
}

# Function to install Xcode Command Line Tools with better checking
install_xcode_tools() {
    log "🛠 Installing Xcode Command Line Tools..."
    
    if [[ "$DRY_RUN" == false ]] && xcode-select --print-path &>/dev/null; then
        log "✅ Xcode Command Line Tools already installed."
        return 0
    elif [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would check if Xcode Command Line Tools are installed"
    fi
    
    if [[ "$SKIP_INTERACTIVE" == false ]]; then
        echo "Xcode Command Line Tools installation requires interaction."
        read -p "Continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_warn "Skipping Xcode Command Line Tools installation"
            return 0
        fi
    else
        log_info "Running in non-interactive mode, proceeding with Xcode installation"
    fi
    
    execute xcode-select --install
    
    if [[ "$DRY_RUN" == false ]]; then
        # Wait for installation to complete
        while ! xcode-select --print-path &>/dev/null; do
            sleep 5
            echo "Waiting for Xcode Command Line Tools installation..."
        done
    fi
    
    if [[ "$DRY_RUN" == false ]] && [[ -d "/Applications/Xcode.app" ]]; then
        execute sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
        execute sudo xcodebuild -license accept
    elif [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would configure Xcode if installed"
    fi
    
    log "✅ Xcode Command Line Tools installed successfully"
}

# Function to install Homebrew and packages with error handling
install_brew() {
    log "🍺 Installing Homebrew and packages..."
    
    if [[ "$DRY_RUN" == false ]] && ! command -v brew &>/dev/null; then
        log "Installing Homebrew..."
        export HOMEBREW_NO_INSTALL_FROM_API=1
        execute /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add to shell profile
        if [[ -f "$HOME/.zprofile" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        fi
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ "$DRY_RUN" == false ]]; then
        log "✅ Homebrew already installed"
    elif [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would install/check Homebrew"
    fi

    log "🍺 Updating Homebrew..."
    execute brew update --force --quiet
    
    if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
        log "🍺 Installing packages from Brewfile..."
        execute brew bundle --file="$DOTFILES_DIR/Brewfile"
    else
        log_warn "Brewfile not found, skipping package installation"
    fi
}

# Function to configure Node and Bun with version checking
configure_node() {
    log "📦 Configuring Node..."
    
    if [[ "$DRY_RUN" == false ]] && command -v npm &>/dev/null; then
        execute npm install -g n
    elif [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would install 'n' via npm if available"
    else
        log_warn "npm not found, skipping n installation"
    fi
    
    if [[ "$DRY_RUN" == false ]] && [[ ! -f "$HOME/.bun/bin/bun" ]]; then
        log "Installing Bun..."
        execute bash -c "$(curl -fsSL https://bun.sh/install)"
        if [[ -f "$HOME/.bun/bin/bun" ]]; then
            log "🍞 Baked bun -v$($HOME/.bun/bin/bun --version)"
        fi
    elif [[ "$DRY_RUN" == false ]] && [[ -f "$HOME/.bun/bin/bun" ]]; then
        log "✅ Bun already installed: $($HOME/.bun/bin/bun --version)"
    elif [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would install Bun if not present"
    fi
}

# Function to install tmux plugin manager
install_tmux_plugins() {
    log "🖥 Installing tmux plugin manager..."
    local folder="$HOME/.tmux/plugins/tpm"
    local url="https://github.com/tmux-plugins/tpm"

    if [[ ! -d "$folder" ]]; then
        execute git clone "$url" "$folder"
        log "✅ TMux plugin manager installed"
    else
        log "✅ TMux plugin manager already installed"
    fi
}

# Function to install Yazi themes
install_yazi_themes() {
    log "🎨 Installing Yazi themes..."
    local folder="$HOME/.config/yazi/flavors"
    local url="https://github.com/yazi-rs/flavors.git"

    execute mkdir -p "$(dirname "$folder")"
    if [[ ! -d "$folder" ]]; then
        execute git clone "$url" "$folder"
        log "✅ Yazi themes installed"
    else
        log "✅ Yazi themes already installed"
    fi
}

# Function for additional setups with better error handling
setup_utils() {
    log "🔧 Setting up additional utilities..."

    # Git LFS
     if command -v git &>/dev/null; then
         execute git lfs install
     fi

    # GitHub CLI extensions
    if command -v gh &>/dev/null; then
        log "📊 Installing GitHub CLI extensions..."
        
        # Check if gh-dash extension is already installed
        if ! gh extension list 2>/dev/null | grep -q "dlvhdr/gh-dash"; then
            execute gh extension install dlvhdr/gh-dash
            log "✅ gh-dash extension installed"
        else
            log "✅ gh-dash extension already installed"
        fi
    else
        log_warn "GitHub CLI (gh) not found, skipping extension installation"
    fi

    # Goose
    if ! command -v goose &>/dev/null; then
        log "Installing Goose..."
        execute bash -c "$(curl -fsSL https://github.com/block/goose/releases/download/stable/download_cli.sh | CONFIGURE=false bash)"
    fi

    # UV tools installation with error handling
    local uv_tools=(
        "llm"
        "harlequin"
        "sqlit-tui"
    )

    if [[ "$DRY_RUN" == false ]] && command -v uv &>/dev/null; then
        log "🔧 Installing/updating UV tools..."
         for tool_spec in "${uv_tools[@]}"; do
             local tool_name=$(echo "$tool_spec" | cut -d' ' -f1)
             
             if uv tool list 2>/dev/null | grep -q "$tool_name"; then
                 execute uv tool upgrade $tool_spec &>/dev/null
             else
                 execute uv tool install $tool_spec &>/dev/null
             fi
         done
         log "✅ UV tools configured"
    elif [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would install/upgrade UV tools: llm, harlequin, sqlit-tui"
    else
        log_warn "UV not found, skipping tool installations"
    fi

    # LLM configuration
    if [[ "$DRY_RUN" == false ]] && command -v llm &>/dev/null; then
        export PATH="$HOME/.local/bin:$PATH"
        
        # Install LLM plugins
        execute llm install llm-anthropic llm-ollama &>/dev/null
        
        # Create LLM templates
        execute llm --system 'Reply with linux terminal commands only, no extra information' --save cmd &>/dev/null
        execute llm --system 'Reply with neovim commands only, no extra information' --save nvim &>/dev/null
        
         # Set default model
         execute llm models default claude-haiku-4.5 &>/dev/null
        
        log "✅ LLM configured with templates and plugins"
    elif [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would configure LLM with plugins and templates"
    fi

    # Repgrep (better grep)
    if ! command -v rgr &>/dev/null && command -v cargo &>/dev/null; then
        execute cargo install repgrep
    fi
    
    # Create rgrc if it doesn't exist
    execute touch "$HOME/.rgrc"

    # Copy custom scripts
    if [[ -d "$DOTFILES_DIR/bin" ]]; then
        execute mkdir -p "$HOME/.local/bin"
        for file in "$DOTFILES_DIR/bin"/*.py; do
            if [[ -f "$file" ]]; then
                local basename_no_ext=$(basename "${file%.py}")
                execute cp "$file" "$HOME/.local/bin/$basename_no_ext"
                execute chmod +x "$HOME/.local/bin/$basename_no_ext"
            fi
        done
    fi
}

# Function to create Python virtual environments
create_virtualenvs() {
    log "🐍 Creating Python Virtual Environments..."
    
    if [[ "$DRY_RUN" == false ]] && ! command -v uv &>/dev/null; then
        log_warn "UV not found, skipping virtual environment creation"
        return 0
    elif [[ "$DRY_RUN" == true ]] && ! command -v uv &>/dev/null; then
        echo "[DRY RUN] Would skip virtual environment creation (UV not found)"
        return 0
    elif [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would create Python virtual environments: neovim, debugpy"
        return 0
    fi
    
    local envs=(
        "$HOME/.virtualenvs/neovim|pynvim"
        "$HOME/.virtualenvs/debugpy|pynvim debugpy ruff"
    )

    execute mkdir -p "$HOME/.virtualenvs"

    for env in "${envs[@]}"; do
        IFS='|' read -r dir packages <<<"$env"
        
        if [[ ! -d "$dir" ]]; then
            log "Creating virtual environment: $(basename "$dir")"
            execute uv venv "$dir"
        fi

        log "Installing packages in $(basename "$dir"): $packages"
        execute bash -c "source $dir/bin/activate && uv pip install --upgrade $packages && deactivate"
    done

    log "✅ Virtual environments and packages installed."
}

# Function to use GNU Stow to manage dotfiles
stow_dotfiles() {
    log "🐗 Stowing dotfiles..."
    
    if ! command -v stow &>/dev/null; then
        log_error "GNU Stow not found. Please install it first: brew install stow"
        return 1
    fi
    
    local stow_packages=(
        fzf git ghostty nvim sesh starship tmux zsh yazi aerospace
    )
    
    # Check which packages exist
    local existing_packages=()
    for package in "${stow_packages[@]}"; do
        if [[ -d "$DOTFILES_DIR/$package" ]]; then
            existing_packages+=("$package")
        else
            log_warn "Package directory not found: $DOTFILES_DIR/$package"
        fi
    done
    
    if [[ ${#existing_packages[@]} -gt 0 ]]; then
        execute stow --adopt -d "$DOTFILES_DIR" -t "$HOME" "${existing_packages[@]}"
        log "✅ Dotfiles stowed successfully"
    else
        log_warn "No valid stow packages found"
    fi
}

# Cleanup function
cleanup() {
    log "🧹 Performing cleanup..."
    
    # Clean up Homebrew
    if [[ "$DRY_RUN" == false ]] && command -v brew &>/dev/null; then
        execute brew cleanup --prune=all --quiet &>/dev/null
        execute brew autoremove --quiet &>/dev/null
    elif [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would run Homebrew cleanup"
    fi
    
    log "✅ Cleanup completed"
}

# Main function
main() {
    parse_args "$@"
    
    # Initialize log file
    echo "macOS Setup Script - $(date)" > "$LOG_FILE"
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "DRY RUN MODE - No changes will be made"
    fi
    
    # If --only flag is set, run only that function
    if [[ -n "$ONLY_FUNCTION" ]]; then
        local target_func
        if ! target_func=$(get_function_by_name "$ONLY_FUNCTION"); then
            log_error "Unknown function: $ONLY_FUNCTION"
            echo ""
            list_functions
            exit 1
        fi
        
        log "Running only: $target_func"
        if ! $target_func; then
            log_error "Failed during: $target_func"
            exit 1
        fi
        log "✅ $target_func completed successfully!"
        return 0
    fi
    
    log "🐌 The World Changed! Beginning MacOS setup..."
    log "Log file: $LOG_FILE"
    
    # Run setup functions
    local functions=(
        check_macos
        check_prerequisites
        create_dirs
        install_xcode_tools
        install_brew
        configure_node
        create_virtualenvs
        install_tmux_plugins
        install_yazi_themes
        setup_utils
        stow_dotfiles
        cleanup
    )
    
    for func in "${functions[@]}"; do
        if ! $func; then
            log_error "Failed during: $func"
            exit 1
        fi
    done

    log "🦊 The World is restored. Setup completed successfully!"
    log "📋 Log file available at: $LOG_FILE"
}

# Run main function with all arguments
main "$@"
