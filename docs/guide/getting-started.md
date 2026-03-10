# Getting Started

Welcome to Fox's Dotfiles! This guide will help you set up a modern macOS development environment in minutes.

## Prerequisites

- **macOS** (Apple Silicon or Intel)
- **Git** (comes with Xcode Command Line Tools)
- **Terminal** access

## Quick Install

```bash
# Clone the repository
git clone https://github.com/Proteusiq/dotfiles.git ~/dotfiles

# Run the installer
cd ~/dotfiles && ./install.sh
```

That's it! The installer will:

1. Install Xcode Command Line Tools (if needed)
2. Install Homebrew and all packages from the Brewfile
3. Configure Node.js tools (n, Bun)
4. Create Python virtual environments
5. Install tmux and Yazi plugins
6. Symlink all configuration files using GNU Stow

## What Gets Installed

### Terminal Stack

| Tool | Purpose |
|------|---------|
| [Ghostty](https://ghostty.org) | GPU-accelerated terminal emulator |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer |
| [Starship](https://starship.rs) | Cross-shell prompt |
| [sesh](https://github.com/joshmedeski/sesh) | Smart tmux session manager |

### Development Tools

| Tool | Purpose |
|------|---------|
| [Neovim](https://neovim.io) | Modern text editor |
| [LazyVim](https://lazyvim.org) | Neovim configuration framework |
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for git |

### Modern CLI Replacements

| Classic | Modern | Why |
|---------|--------|-----|
| `cat` | `bat` | Syntax highlighting, git integration |
| `ls` | `eza` | Icons, colors, git status |
| `find` | `fd` | Faster, respects .gitignore |
| `grep` | `ripgrep` | 10x faster, smart defaults |
| `cd` | `zoxide` | Learns your habits |

## Verify Installation

After installation, open a new terminal and run:

```bash
# Check if the update command is available
update --help

# See installed tool versions
update --versions

# Check for outdated packages
update --outdated
```

## Next Steps

- [Installation Details](/guide/installation) - Learn about the install system
- [Shell Configuration](/guide/shell) - Customize your Zsh setup
- [Neovim Guide](/guide/neovim) - Master your editor
- [Tools Reference](/reference/tools) - Explore all installed tools
