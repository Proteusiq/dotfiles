# ═══════════════════════════════════════════════════════════════════════════
#                                 BREWFILE
#                     Dotfiles Package Management
# ═══════════════════════════════════════════════════════════════════════════

# TAPS (Package Repositories)
# ───────────────────────────────────────────────────────────────────────────
tap "andrewmd5/tap"
tap "espanso/espanso"
tap "homebrew/bundle"
tap "homebrew/services"
tap "jesseduffield/lazydocker"
tap "jesseduffield/lazygit"
tap "joshmedeski/sesh"
tap "koekeishiya/formulae"
tap "wix/brew"
tap "sst/tap"

cask_args appdir: "/Applications"

# CORE TERMINAL
# ───────────────────────────────────────────────────────────────────────────
# Shell, Prompt, Multiplexer, Emulator
brew "zsh"
brew "zplug"
brew "starship"                          # Cross-shell prompt
brew "tmux"
brew "joshmedeski/sesh/sesh"             # Session manager for tmux
cask "ghostty"                           # GPU-accelerated terminal

# EDITORS
# ───────────────────────────────────────────────────────────────────────────
brew "neovim"
brew "andrewmd5/tap/dawn"                # Distraction-free markdown editor
brew "glow"                              # Terminal markdown viewer

# MODERN CLI REPLACEMENTS
# ───────────────────────────────────────────────────────────────────────────
# Modern alternatives to classic Unix tools (mostly Rust-based)
brew "bat"                               # cat with syntax highlighting
brew "eza"                               # ls with git integration
brew "fd"                                # find that respects .gitignore
brew "ripgrep"                           # grep but faster
brew "zoxide"                            # cd that learns your habits
brew "difftastic"                        # diff with syntax awareness
brew "httpie"                            # curl for humans
brew "tlrc"                              # tldr pages client
brew "thefuck"                           # command correction

# FILE MANAGEMENT
# ───────────────────────────────────────────────────────────────────────────
brew "yazi"                              # Terminal file manager
brew "broot"                             # Interactive tree navigator
brew "fzf"                               # Fuzzy finder
brew "ncdu"                              # Disk usage analyzer
brew "btop"                              # System monitor (better htop)
brew "stow"                              # Symlink farm manager
brew "unar"                              # Archive extractor (yazi requirement)
brew "rename"                            # Batch file renaming
brew "rsync"                             # File synchronization

# GIT & VERSION CONTROL
# ───────────────────────────────────────────────────────────────────────────
brew "git"
brew "git-lfs"                           # Large file storage
brew "git-filter-repo"                   # History rewriting
brew "gh"                                # GitHub CLI
brew "lazygit"                           # Git TUI
brew "serie"                             # Rich git commit graph
brew "gitlogue"                          # Cinematic commit replay

# DATA & DATABASES
# ───────────────────────────────────────────────────────────────────────────
brew "jq"                                # JSON processor
brew "tabiew"                            # CSV/Parquet/JSON viewer with SQL
brew "mongosh"                           # MongoDB shell
brew "lnav"                              # Log file viewer
cask "pgadmin4"                          # PostgreSQL admin

# DEVELOPMENT & BUILD
# ───────────────────────────────────────────────────────────────────────────
brew "watchexec"                         # File watcher for auto-execution
brew "hyperfine"                         # Benchmarking tool
brew "act"                               # Run GitHub Actions locally
brew "vhs"                               # Record terminal sessions as GIFs
brew "scooter"                           # Interactive find-and-replace
brew "direnv"                            # Per-directory environment
brew "universal-ctags"                   # Code indexing
cask "postman"                           # API testing

# INFRASTRUCTURE & CLOUD
# ───────────────────────────────────────────────────────────────────────────
brew "lima"                              # Linux VMs on macOS
brew "lazydocker"                        # Docker TUI
brew "docker-slim"                       # Container image optimizer
brew "terraform"
brew "azure-cli"
brew "temporal"                          # Durable execution platform CLI

# PROGRAMMING LANGUAGES
# ───────────────────────────────────────────────────────────────────────────
# Python
brew "uv"                                # Fast package manager
brew "pixi"                              # Conda-compatible environment manager

# JavaScript/Node
brew "node"
brew "yarn"

# Go
brew "go"

# Rust
brew "rust"

# Shell scripting
brew "gum"                               # Glamorous shell scripts

# AI & LLM
# ───────────────────────────────────────────────────────────────────────────
brew "sst/tap/opencode"                  # AI coding agent CLI
brew "llama.cpp"                         # Local LLM inference
cask "ollama-app"                        # Local LLM runner
cask "lm-studio"                         # LLM GUI (ollama + open-webui)

# GNU COREUTILS
# ───────────────────────────────────────────────────────────────────────────
# GNU versions of standard Unix tools (more features than macOS defaults)
brew "coreutils"                         # cp, mv, rm, mkdir, etc.
brew "findutils"                         # find, xargs
brew "diffutils"                         # diff, cmp
brew "binutils"                          # ar, nm, objdump
brew "moreutils"                         # sponge, parallel, etc.
brew "gnu-sed"
brew "gnu-tar"
brew "gnu-time"
brew "gnu-which"
brew "gawk"
brew "grep"
brew "gzip"
brew "gnupg"
brew "wget"
brew "screen"
brew "ack"                               # Programmer's grep

# MEDIA & DOCUMENTS
# ───────────────────────────────────────────────────────────────────────────
brew "ffmpeg"
brew "ffmpegthumbnailer"                 # Video thumbnails (yazi requirement)
brew "imagemagick"                       # Image manipulation (snacks.nvim)
brew "poppler"                           # PDF rendering (yazi requirement)
brew "ghostscript"                       # PDF rendering (snacks.nvim)
brew "graphviz"                          # Graph visualization (PyMC)
brew "mermaid-cli"                       # Diagram rendering (snacks.nvim)
brew "tectonic"                          # LaTeX rendering (snacks.nvim)
brew "slides"                            # Terminal presentations
brew "figlet"                            # ASCII art text
brew "toilet"                            # ASCII art fonts

# PRODUCTIVITY APPS
# ───────────────────────────────────────────────────────────────────────────
cask "1password"
cask "1password-cli"
cask "raycast"                           # Spotlight replacement
cask "notion"
cask "cleanshot"                         # Screenshot tool
cask "espanso"                           # Text expander
cask "hiddenbar"                         # Menu bar organizer
cask "shortcat"                          # Keyboard-driven UI navigation

# WINDOW MANAGEMENT
# ───────────────────────────────────────────────────────────────────────────
cask "nikitabobko/tap/aerospace"         # Tiling window manager
brew "koekeishiya/formulae/skhd"         # Hotkey daemon
cask "alt-tab"                           # Windows-style alt-tab

# SYSTEM & SECURITY
# ───────────────────────────────────────────────────────────────────────────
brew "wireguard-tools"                   # VPN
cask "lulu"                              # Firewall
cask "aldente"                           # Battery management
cask "flux-app"                          # Night shift

# BROWSERS
# ───────────────────────────────────────────────────────────────────────────
cask "arc"
cask "zen"                               # Firefox-based privacy browser

# FONTS
# ───────────────────────────────────────────────────────────────────────────
cask "font-hack"
cask "font-hack-nerd-font"
cask "font-symbols-only-nerd-font"       # Icons (yazi requirement)

# MISC
# ───────────────────────────────────────────────────────────────────────────
brew "portaudio"                         # Audio I/O (pyaudio)
brew "zlib"                              # Compression library
