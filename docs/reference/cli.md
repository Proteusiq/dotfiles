# CLI Reference

The `update` command is the main interface for managing your dotfiles.

## Synopsis

```bash
update [OPTIONS] [TOOL]
```

## Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help message |
| `-v, --verbose` | Show detailed output with timestamps |
| `-vv` | Debug mode (show executed commands) |
| `--dry-run` | Preview changes without executing |
| `--only <fn>` | Run only a specific function |
| `--skip <fn...>` | Skip specific functions |
| `--list` | List available functions |
| `--versions [group]` | Show installed versions |
| `--info <tool>` | Show info about a tool |
| `--outdated` | Show packages with updates |
| `--all` | Update all packages |
| `--interactive` | Enable interactive prompts |

## Commands

### Full Installation

```bash
# Run all installation steps
update

# With verbose output
update -v

# Debug mode
update -vv

# Preview only
update --dry-run
```

### Selective Installation

```bash
# Run single function
update --only brew
update --only stow
update --only venv

# Skip functions
update --skip venv
update --skip "venv brew"

# List available functions
update --list
```

### Version Management

```bash
# Show all versions
update --versions

# Filter by manager
update --versions brew
update --versions cask
update --versions uv
update --versions cargo
update --versions git
update --versions other
update --versions all
```

### Tool Information

```bash
# Get tool info
update --info bat
update --info ripgrep
update --info harlequin
```

Output:
```
📦 bat
├─ Version: 0.25.0
├─ Manager: brew
├─ Type: formula
└─ Description: Clone of cat(1) with syntax highlighting and Git integration
```

### Updates

```bash
# Check for outdated packages
update --outdated

# Update everything
update --all

# Update specific tool
update bat
update harlequin
update yazi
```

## Available Functions

| Name | Function | Description |
|------|----------|-------------|
| `dirs` | `create_dirs` | Create ~/Codes and ~/Documents/Screenshots |
| `xcode` | `install_xcode_tools` | Install Xcode Command Line Tools |
| `brew` | `install_brew` | Install Homebrew and Brewfile packages |
| `node` | `configure_node` | Install Node.js tools (n, Bun) |
| `venv` | `create_virtualenvs` | Create Python venvs for Neovim |
| `tmux` | `install_tmux_plugins` | Install tmux plugin manager |
| `yazi` | `install_yazi_themes` | Install Yazi themes |
| `utils` | `setup_utils` | Install CLI utilities |
| `stow` | `stow_dotfiles` | Symlink dotfiles with GNU Stow |
| `cleanup` | `cleanup` | Run Homebrew cleanup |

## Examples

### Initial Setup

```bash
# Clone and install
git clone https://github.com/Proteusiq/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

### Daily Usage

```bash
# Check what needs updating
update --outdated

# Update everything
update --all

# Or update specific tools
update bat ripgrep
```

### Debugging

```bash
# See what would happen
update --dry-run -v

# Full debug output
update -vv

# Check specific function
update --only brew --dry-run -v
```

### After Editing Configs

```bash
# Re-stow dotfiles
update --only stow

# Or manually
stow --restow -d ~/dotfiles -t ~ zsh nvim tmux
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DOTFILES_DIR` | `$HOME/dotfiles` | Dotfiles location |
| `LOG_FILE` | `$HOME/macos-setup.log` | Log file path |

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Error (check log file) |

## Log File

All operations are logged to `$LOG_FILE` (default: `~/macos-setup.log`).

```bash
# View log
cat ~/macos-setup.log

# Follow log
tail -f ~/macos-setup.log

# Search log
grep "error" ~/macos-setup.log
```

## Custom Tools Commands

### `aliases` - Alias Explorer

```bash
aliases              # Interactive TUI
aliases --list       # List all aliases
aliases --search git # Search aliases
aliases --json       # JSON output
```

### `tools` - Tool Explorer

```bash
tools                     # Interactive TUI
tools --list              # List all tools
tools --category "Git"    # Filter by category
tools --search ripgrep    # Search tools
tools --json              # JSON output
```
