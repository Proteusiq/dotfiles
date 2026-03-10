# Installation

The installation system is built around a single `install.sh` script that orchestrates the entire setup process.

## The `update` Command

After initial installation, an `update` alias becomes available:

```bash
alias update="~/dotfiles/install.sh"
```

### Basic Usage

```bash
update              # Run full installation (safe to re-run)
update -v           # Verbose mode with timestamps
update -vv          # Debug mode (shows all commands)
update --dry-run    # Preview changes without executing
```

### Selective Installation

```bash
# Run only a specific function
update --only brew      # Just Homebrew packages
update --only stow      # Just symlink dotfiles
update --only venv      # Just Python virtual environments

# Skip specific functions
update --skip venv           # Skip Python venvs
update --skip "venv brew"    # Skip multiple functions

# List available functions
update --list
```

### Version Management

```bash
# Show all installed versions
update --versions

# Filter by package manager
update --versions brew    # Homebrew packages
update --versions uv      # UV Python tools
update --versions cargo   # Rust crates
update --versions git     # Git-installed tools

# Check for updates
update --outdated

# Update everything
update --all

# Update a specific tool
update bat          # Auto-detects package manager
update harlequin    # Works with UV tools too
```

## Available Functions

| Function | Description |
|----------|-------------|
| `dirs` | Create `~/Codes` and `~/Documents/Screenshots` |
| `xcode` | Install Xcode Command Line Tools |
| `brew` | Install Homebrew and Brewfile packages |
| `node` | Install Node.js tools (n version manager, Bun) |
| `venv` | Create Python virtual environments for Neovim |
| `tmux` | Install tmux plugin manager (tpm) |
| `yazi` | Install Yazi themes and plugins |
| `utils` | Install CLI utilities (gh-dash, repgrep, etc.) |
| `stow` | Symlink dotfiles with GNU Stow |
| `cleanup` | Run Homebrew cleanup and autoremove |

## Architecture

```
install.sh                 # Main orchestrator
├── scripts/
│   ├── logging.sh         # Logging, spinners, execute helpers
│   ├── ui.sh              # Table drawing utilities
│   └── versions.sh        # Version tracking and detection
└── Brewfile               # Homebrew package manifest
```

### Stow Packages

Each directory is a GNU Stow package that gets symlinked to `$HOME`:

```
dotfiles/
├── aerospace/    → ~/.config/aerospace/
├── fzf/          → ~/.fzf/
├── ghostty/      → ~/.config/ghostty/
├── git/          → ~/.gitconfig
├── nvim/         → ~/.config/nvim/
├── sesh/         → ~/.config/sesh/
├── starship/     → ~/.config/starship/
├── tmux/         → ~/.tmux.conf
├── yazi/         → ~/.config/yazi/
└── zsh/          → ~/.zshrc, ~/.aliases, ~/.exports
```

## Idempotency

The install script is designed to be **idempotent** - you can run it multiple times safely:

- Already installed tools are skipped
- Existing symlinks are refreshed with `stow --restow`
- Version changes are tracked and reported

```bash
# Safe to run anytime
update

# Output shows what changed
📊 Version Changes:
┌──────────────┬──────────┬──────────┬─────────┐
│ Tool         │ Previous │ Current  │ Status  │
├──────────────┼──────────┼──────────┼─────────┤
│ bat          │ 0.24.0   │ 0.25.0   │ Updated │
│ ripgrep      │ 14.1.0   │ 14.1.0   │ Same    │
└──────────────┴──────────┴──────────┴─────────┘
```

## Customization

### Adding New Homebrew Packages

Edit the `Brewfile`:

```ruby
# Brewfile
brew "your-package"
cask "your-app"
```

Then run:

```bash
update --only brew
```

### Adding New Stow Packages

1. Create a new directory with the tool name
2. Mirror the target structure inside it
3. Add to the `stow_dotfiles()` function in `install.sh`

Example for adding `alacritty`:

```bash
mkdir -p alacritty/.config/alacritty
# Add your config file
touch alacritty/.config/alacritty/alacritty.toml
```
