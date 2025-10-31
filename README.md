![dotfiles banner](https://github.com/Proteusiq/dotfiles/assets/14926709/9e3c4c60-43cd-4e47-9711-49eeb1078ae4)

# dotfiles

Modern macOS dotfiles for developers focused on Rust 🦀, Python 🐍, and data workflows. Optimized for MLOps and Data Science work.

![Terminal Screenshot](https://github.com/Proteusiq/dotfiles/assets/14926709/b5374cdb-753c-4559-ad8e-920d9653de34)

## Table of Contents

- [Quick Start](#quick-start)
- [What's Included](#whats-included)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Managing Aliases](#managing-aliases)
- [File Structure](#file-structure)
- [Customization](#customization)
- [Usage Tips](#usage-tips)
- [Troubleshooting](#troubleshooting)
- [Acknowledgements](#acknowledgements)

## Quick Start

**One-line install:**
```bash
curl -L https://bit.ly/42YwVdi | sh
```

**Preview before running:**
```bash
curl -LsSf https://bit.ly/42YwVdi | less
```

## What's Included

### Core Tools
- **Terminal**: [Ghostty](https://github.com/ghostty-org/ghostty) with zsh & [Starship prompt](https://starship.rs/)
- **Window Management**: [AeroSpace](https://github.com/nikitabobko/AeroSpace)
- **File Manager**: [Yazi](https://github.com/sxyazi/yazi)
- **Hotkeys**: [skhd](https://github.com/koekeishiya/skhd)
- **Editor**: [Neovim](https://neovim.io/) with [LazyVim](https://github.com/LazyVim/LazyVim)
- **Terminal Multiplexer**: [tmux](https://github.com/tmux/tmux)
- **Session Management**: [sesh](https://github.com/joshmedeski/sesh)

### Development Languages & Tools
- **Python**: [uv](https://github.com/astral-sh/uv), [pixi](https://pixi.sh/), [aider](https://github.com/paul-gauthier/aider)
- **Rust**: Full toolchain with cargo
- **Go**: Latest stable version
- **Node.js**: Managed via [n](https://github.com/tj/n)
- **JavaScript/TypeScript**: [Bun](https://bun.sh/) toolkit

### Enhanced CLI Experience
- **Navigation**: [zoxide](https://github.com/ajeetdsouza/zoxide), [fzf](https://github.com/junegunn/fzf)
- **File Operations**: [eza](https://github.com/eza-community/eza), [fd](https://github.com/sharkdp/fd), [ripgrep](https://github.com/BurntSushi/ripgrep)
- **Git**: [lazygit](https://github.com/jesseduffield/lazygit), enhanced aliases
- **AI**: [OpenCode](https://opencode.ai/), [LLM](https://llm.datasette.io/), local models via [Ollama](https://ollama.ai/)

## Prerequisites

**Required:**
- macOS (tested on recent versions)
- Full Disk Access for Terminal (`System Preferences → Privacy → Full Disk Access`)

**Recommended:**
- At least 8GB free disk space
- Stable internet connection for initial setup

## Installation

### Automatic Installation

The install script will:
1. Install Xcode Command Line Tools
2. Install Homebrew and all packages from [Brewfile](./Brewfile)
3. Set up Python, Node, and Bun environments
4. Configure shell environment and dotfiles via GNU Stow
5. Install additional tools and configurations

```bash
# Full installation
curl -L https://bit.ly/42YwVdi | sh

# Manual installation
git clone https://github.com/proteusiq/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

### Installation Options

The install script supports several flags:
```bash
./install.sh --help              # Show all options
./install.sh --dry-run           # Preview changes without executing
./install.sh --verbose           # Show detailed output
./install.sh --skip-interactive  # Non-interactive mode (default)
```

## Configuration

### Git Setup
Update your Git configuration:
```bash
# Edit the global gitconfig
nvim ~/dotfiles/git/.gitconfig

# Or set directly
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### SSH for GitHub
After first installation, configure SSH for GitHub:
```bash
# Generate SSH key (follow GitHub's guide)
ssh-keygen -t ed25519 -C "your.email@example.com"

# Switch to SSH remote
git remote set-url origin git@github.com:Proteusiq/dotfiles.git
```

### Color Scheme
All tools use **Catppuccin Mocha** theme:
- Ghostty
- Tmux  
- Neovim
- fzf

## Managing Aliases

View and manage comprehensive aliases using the built-in CLI:

```bash
# Show all alias categories
aliases

# Show aliases in a specific category
aliases --show git
aliases -s shortcuts

# Get details about a specific alias
aliases --describe ga
aliases -d gp
```

**Available categories:** git, coreutils, yarn, pnpm, shortcuts, special, functions
## File Structure

```
dotfiles/
├── aerospace/        # Window management config
├── bin/             # Custom scripts (aliases, peak)
├── fzf/             # Fuzzy finder config
├── ghostty/         # Terminal emulator config
├── git/             # Git configuration
├── nvim/            # Neovim configuration
├── sesh/            # Session manager config
├── starship/        # Shell prompt config
├── tmux/            # Terminal multiplexer config
├── vim/             # Basic vim config
├── yazi/            # File manager config
├── zsh/             # Shell configuration
│   ├── .aliases     # Command aliases
│   ├── .exports     # Environment variables
│   ├── .zlogin.sh   # Login shell config
│   ├── .zshenv.sh   # Environment setup
│   └── .zshrc       # Main zsh config
├── Brewfile         # Homebrew packages
└── install.sh       # Setup script
```

### Key Configuration Files
- **Shell Environment**: [Antigen](https://github.com/zsh-users/antigen) for zsh plugin management
- **Package Management**: [Brewfile](./Brewfile) contains all Homebrew packages, casks, and Mac App Store apps
- **Language Setup**: [uv](https://github.com/astral-sh/uv) for Python, [n](https://github.com/tj/n) for Node.js, [Bun](https://bun.sh/) for TypeScript/JavaScript

## Customization

## Usage Tips

<details><summary>🖥️ Tmux Session Management</summary>

**Key Bindings** (leader = `Ctrl-b`):
```bash
<leader> + I     # Install plugins
<leader> + c     # New session
<leader> + n     # Next session  
<leader> + "     # Horizontal split
<leader> + %     # Vertical split
<leader> + hjkl  # Navigate panes
<leader> + z     # Zoom/unzoom pane
<leader> + p     # Popup terminal
<leader> + O     # Popup session switcher

# Aliases
iexit    # Kill current session
ikill    # Kill all sessions
iswitch  # Interactive session switcher
```

</details>

<details><summary>🔍 FZF Fuzzy Finding</summary>

**Interactive search:**
```bash
# File/folder operations
nvim **<TAB>     # Open files with fzf
cd **<TAB>       # Navigate with fzf
kill -9 **<TAB>  # Process selection

# History search
<Ctrl-r>         # Search command history
docker <Ctrl-r>  # Filter history by 'docker'
```

</details>

<details><summary>⚡ Neovim/LazyVim</summary>

**Essential bindings:**
```bash
<Space>          # Leader key
<Ctrl-w>w        # Switch to file tree
[b ]b            # Navigate buffers (Alt+8/9)

# Command mode operations
:!<command>      # Execute shell command
:'<,'>!sort      # Sort selected lines
:'<,'>!jq        # Format JSON selection
:r !ls -al       # Insert command output

# Telescope
:Telescope keymap         # Show all keymaps
:Telescope live_grep      # Live grep search
:Telescope git_branches   # Git branch switcher
```

**Debugging shortcuts:**
- `<leader>dm` - Debug test method
- `<leader>dc` - Debug test class  
- `<leader>df` - Debug Python file
- `<leader>du` - Debug function under cursor

</details>

<details><summary>🧘 Vim Grammar Reference</summary>

Vim follows **Verb + Noun** grammar for powerful text editing:

**Verbs (Actions):**
- `d` - delete
- `c` - change (delete + insert mode)
- `y` - yank (copy)

**Nouns (Motions):**
- `w/b` - word forward/backward
- `gg/G` - top/bottom of file
- `{/}` - paragraph navigation

**Text Objects (preferred for repeatability):**
- `iw/aw` - inner/around word
- `i"/a"` - inner/around quotes
- `i(/a(` - inner/around parentheses

**Examples:**
- `diw` - delete inner word
- `ci"` - change inside quotes
- `yap` - yank around paragraph

**Pro tip:** Text objects work regardless of cursor position and support the `.` repeat command.

</details>

## Troubleshooting

**Common issues:**

1. **Homebrew installation fails**: Ensure Xcode Command Line Tools are installed first
2. **Stow conflicts**: Remove existing dotfiles before running stow
3. **Permission errors**: Grant Full Disk Access to your terminal
4. **Python/Node issues**: Check that uv and n are properly installed
5. **Terminal theme issues**: Restart terminal after font installation

**Need help?**
- Check the [install log](~/macos-setup.log) for detailed error information
- Run install script with `--verbose` flag for debugging
- Ensure all prerequisites are met before installation

**Useful resources:**
- [cheat.sh](https://cheat.sh/) - `curl https://cheat.sh/<command>`
- Command reference: `tldr <command>`
- Vim help: `:help <topic>` or `:Telescope help_tags`



## Acknowledgements

Inspired by [Sara Pope's dotfiles](https://github.com/gretzky/dotfiles) and the broader dotfiles community.

---

*A fork focused on modern development workflows with Rust, Python, and AI tooling.*
