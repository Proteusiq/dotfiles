# ═══════════════════════════════════════════════════════════════════════════
#                                 BREWFILE
#                     Dotfiles Package Management
# ═══════════════════════════════════════════════════════════════════════════
# One list for everything installed system-wide: formulae, casks, uv tools and
# cargo crates. Language runtimes (node, go, bun) live in mise/.config/mise/config.toml.
#
#   brew bundle check --file=Brewfile     # anything missing?
#   brew bundle cleanup --file=Brewfile   # anything installed but not listed?

# TAPS (third-party repositories)
# ───────────────────────────────────────────────────────────────────────────
# install.sh trusts exactly these taps. Adding one here is a reviewed change.
tap "andrewmd5/tap"
tap "azure/azd"
tap "dbt-labs/dbt-cli"
tap "jordond/tap"
tap "nikitabobko/tap"

# CORE TERMINAL
# ───────────────────────────────────────────────────────────────────────────
brew "zsh"
brew "antidote"                          # zsh plugin manager (static bundle)
brew "starship"                          # Cross-shell prompt
brew "tmux"
brew "sesh"                              # Session manager for tmux
brew "atuin"                             # Shell history search and sync
brew "pam-reattach"                      # Touch ID for sudo inside tmux
cask "ghostty"                           # GPU-accelerated terminal

# EDITORS
# ───────────────────────────────────────────────────────────────────────────
brew "neovim"
brew "andrewmd5/tap/dawn"                # Distraction-free markdown editor
brew "glow"                              # Terminal markdown viewer
brew "leaf-markdown-viewer"              # GUI-like terminal markdown previewer

# MODERN CLI REPLACEMENTS
# ───────────────────────────────────────────────────────────────────────────
brew "bat"                               # cat with syntax highlighting
brew "eza"                               # ls with git integration
brew "fd"                                # find that respects .gitignore
brew "ripgrep"                           # grep but faster
brew "zoxide"                            # cd that learns your habits
brew "httpie"                            # curl for humans
brew "tlrc"                              # tldr pages client

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
brew "croc"                              # Secure P2P file transfer

# GIT & VERSION CONTROL
# ───────────────────────────────────────────────────────────────────────────
brew "git"
brew "git-lfs"                           # Large file storage
brew "git-filter-repo"                   # History rewriting
brew "git-delta"                         # Pager for git diff and log
brew "difftastic"                        # Syntax-aware diff (git dft, git dlog)
brew "gh"                                # GitHub CLI
brew "lazygit"                           # Git TUI
brew "serie"                             # Rich git commit graph
brew "gitlogue"                          # Cinematic commit replay

# CODE QUALITY & SECURITY
# ───────────────────────────────────────────────────────────────────────────
brew "prek"                              # Git hooks runner (pre-commit compatible)
brew "gitleaks"                          # Secret scanner
brew "shellcheck"                        # Shell linter
brew "shfmt"                             # Shell formatter
brew "stylua"                            # Lua formatter
brew "actionlint"                        # GitHub Actions linter
brew "ruff"                              # Python linter and formatter
brew "ty"                                # Python type checker
brew "biome"                             # JS/TS linter and formatter
brew "bacon"                             # Background Rust checker

# DATA & DATABASES
# ───────────────────────────────────────────────────────────────────────────
brew "jq"                                # JSON processor
brew "yq"                                # YAML processor
brew "duckdb"                            # In-process analytical SQL
brew "tabiew"                            # CSV/Parquet/JSON viewer with SQL
brew "dbt-labs/dbt-cli/dbt"              # dbt Cloud CLI
brew "snowflake-cli"                     # Snowflake CLI (snow)
brew "sqlfluff"                          # SQL linter (dbt, Snowflake dialects)
brew "mongosh"                           # MongoDB shell
brew "lnav"                              # Log file viewer

# DEVELOPMENT & BUILD
# ───────────────────────────────────────────────────────────────────────────
brew "resterm"                           # Terminal API client (REST/GraphQL/gRPC)
brew "watchexec"                         # File watcher for auto-execution
brew "hyperfine"                         # Benchmarking tool
brew "act"                               # Run GitHub Actions locally
brew "vhs"                               # Record terminal sessions as GIFs
brew "scooter"                           # Interactive find-and-replace
brew "universal-ctags"                   # Code indexing
brew "gum"                               # Glamorous shell scripts
cask "postman"                           # API testing

# CONTAINERS, INFRASTRUCTURE & CLOUD
# ───────────────────────────────────────────────────────────────────────────
cask "orbstack"                          # Docker and Linux VMs (default engine)
brew "colima"                            # Open-source container runtime (alternative)
brew "lima"                              # Linux VMs on macOS
brew "docker"                            # Docker CLI
brew "docker-compose"
brew "docker-buildx"
brew "lazydocker"                        # Docker TUI
brew "mintoolkit"                        # Container image optimizer (was docker-slim)
brew "opentofu"                          # Terraform-compatible IaC (tofu)
brew "azure-cli"                         # az (Bicep via: az bicep install)
brew "azure/azd/azd"                     # Azure Developer CLI
brew "temporal"                          # Durable execution platform CLI

# LANGUAGES & TOOLCHAINS
# ───────────────────────────────────────────────────────────────────────────
brew "mise"                              # Runtime manager: node, go, bun (see mise/)
brew "uv"                                # Python: packages, tools, versions
brew "pixi"                              # Conda-compatible environment manager
brew "rustup"                            # Rust toolchains (rustup default stable)

# AI & LLM
# ───────────────────────────────────────────────────────────────────────────
brew "opencode"                          # AI coding agent CLI
brew "llama.cpp"                         # Local LLM inference
brew "hf"                                # Hugging Face Hub CLI
cask "ollama-app"                        # Local LLM runner

# GNU TOOLS
# ───────────────────────────────────────────────────────────────────────────
# Interactive shells put these first on PATH under their usual names (see zsh/.zshrc).
brew "coreutils"                         # cp, mv, rm, mkdir, etc.
brew "findutils"                         # find, xargs
brew "diffutils"                         # diff, cmp
brew "binutils"                          # ar, nm, objdump (keg-only, not on PATH)
brew "moreutils"                         # sponge, parallel, etc.
brew "gnu-sed"
brew "gnu-tar"
brew "gnu-time"
brew "gnu-which"
brew "gawk"
brew "grep"
brew "gzip"
brew "wget"
brew "gnupg"

# MEDIA & DOCUMENTS
# ───────────────────────────────────────────────────────────────────────────
brew "ffmpeg"
brew "ffmpegthumbnailer"                 # Video thumbnails (yazi requirement)
brew "gifsicle"                          # GIF optimizer (gifify)
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
# cleanshot: intentionally unmanaged — frozen at v4 (license doesn't cover v5); install v4 manually
cask "hiddenbar"                         # Menu bar organizer
cask "shortcat"                          # Keyboard-driven UI navigation
cask "flux-app"                          # Screen colour temperature at night (f.lux)
brew "mas"                               # Mac App Store CLI

# WINDOW MANAGEMENT
# ───────────────────────────────────────────────────────────────────────────
cask "nikitabobko/tap/aerospace"         # Tiling window manager
cask "alt-tab"                           # Windows-style alt-tab

# SYSTEM & SECURITY
# ───────────────────────────────────────────────────────────────────────────
brew "jordond/tap/jolt"                  # Battery and energy monitor TUI
brew "wireguard-tools"                   # VPN
cask "lulu"                              # Firewall
cask "aldente"                           # Battery management

# BROWSERS
# ───────────────────────────────────────────────────────────────────────────
cask "arc"
cask "zen"                               # Firefox-based privacy browser

# FONTS
# ───────────────────────────────────────────────────────────────────────────
cask "font-hack-nerd-font"
cask "font-symbols-only-nerd-font"       # Icons (yazi requirement)

# MISC
# ───────────────────────────────────────────────────────────────────────────
brew "portaudio"                         # Audio I/O (pyaudio)
brew "zlib"                              # Compression library

# PYTHON TOOLS (uv tool install)
# ───────────────────────────────────────────────────────────────────────────
uv "harlequin[duckdb,mysql,postgres,sqlite]" # SQL IDE in the terminal, with adapters
uv "sqlit-tui"                           # SQLite TUI

# RUST TOOLS (cargo install --locked)
# ───────────────────────────────────────────────────────────────────────────
cargo "repgrep"                          # Interactive ripgrep replacer (rgr)
cargo "tmux-expose"                      # Binary for the tmux.expose plugin
cargo "pay-respects"                     # Fix the last command (replaces thefuck); alias: f
