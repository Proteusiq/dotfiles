---
name: dotfiles
description: Repository knowledge for this dotfiles setup. Use when adding tools, editing shell configs, understanding the architecture, or working with GNU Stow.
---

# Dotfiles Repository Knowledge

This document contains repository-specific knowledge for working with this dotfiles setup.

## Adding Tools

**Important:** Never install tools directly (e.g., `brew install`, `cargo install`). Always add to dotfiles first, then run `update`.

### Full Flow for Adding a Tool

1. **Check availability** - Search for the tool (`brew search`, check taps, PyPI, crates.io, etc.)
2. **Add to correct location** - Brewfile (with tap if needed) or install.sh
3. **Add to `Tools.md`** - Full documentation: description, commands, key bindings, use cases
4. **Add to `bin/tools.py`** - Short entry in the appropriate `*_TOOLS` list for `update --info`
5. **Run `update`** - Use `update --only brew`, `update <tool>`, or `update` to install

### Primary: Brewfile (most tools)

Location: `Brewfile`

```ruby
# CLI tools
brew "newtool"

# GUI applications  
cask "newapp"

# Custom repositories (taps)
tap "user/repo"
brew "user/repo/tool"
```

After editing, run: `update --only brew` or `update <toolname>`

### Secondary: install.sh (non-Homebrew tools)

Location: `~/dotfiles/install.sh`

| Tool Type | Where to Add | Pattern |
|-----------|--------------|---------|
| **UV tools** (Python) | `setup_utils()` | Add to `for tool in llm harlequin ...` loop |
| **Git repos** | `setup_utils()` | `git_install "name" "url" "path" "description"` |
| **Cargo** | `setup_utils()` | `cargo install <tool>` with `has_cmd` guard |
| **Curl scripts** | Appropriate function | `curl -fsSL <url> \| bash` with existence check |
| **LLM plugins** | `setup_utils()` | `llm install <plugin>` |

Example patterns from install.sh:

```bash
# Git-based installation
git_install "tpm" "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm" "tmux plugin manager"

# UV tool installation
for tool in llm harlequin sqlit-tui; do
    uv tool list 2>/dev/null | grep -q "^$tool " &&
        uv tool upgrade "$tool" || uv tool install "$tool"
done

# Cargo installation (with guard)
if ! has_cmd rgr && has_cmd cargo; then
    run_quiet cargo install repgrep
fi
```

### Version Tracking

Location: `~/dotfiles/scripts/versions.sh`

Add to `TRACKED_TOOLS` array:

```bash
readonly TRACKED_TOOLS=(
    # ...existing...
    "toolname|version_cmd|type"  # type: cmd|git|uv|llm-plugin
)
```

### Tool Descriptions (optional)

Location: `~/dotfiles/bin/tools.py`

Add entry for `update --info <tool>` command:

```python
("toolname", "What it does concisely", "toolname --demo → shows practical example"),
```

---

## CLI Commands

```bash
update                    # Full installation (idempotent)
update -v                 # Verbose output
update --dry-run          # Preview changes

update bat                # Update specific tool (auto-detects package manager)
update --only brew        # Run only Homebrew installation
update --list             # List available functions

update --info <tool>      # Show tool info
update --outdated         # Check for available updates
update --versions         # Show all installed versions
update --versions brew    # Filter by group (brew|cask|uv|cargo|llm|git|other)
```

---

## Architecture

```
dotfiles/
├── Brewfile              # Primary tool manifest (Homebrew)
├── install.sh            # Main installation script, setup functions
├── scripts/
│   ├── logging.sh        # Logging, spinner, execute helpers
│   ├── ui.sh             # Table drawing, formatting
│   └── versions.sh       # Version detection, TRACKED_TOOLS
├── bin/
│   └── tools.py          # Tool catalog for --info command
└── run.sh                # Bootstrap script for initial clone
```

### Installation Pipeline

```
📋 Checking prerequisites
📁 Creating directories
🔨 Installing Xcode CLI
🍺 Installing Homebrew packages    ← Brewfile
📦 Installing Node.js tools        ← n, bun
🐍 Creating Python virtual environments
💻 Installing tmux plugins         ← tpm (git)
🎨 Installing Yazi themes          ← yazi-flavors (git)
🔧 Installing CLI utilities        ← uv tools, cargo, llm plugins
🔗 Linking dotfiles                ← GNU Stow
🧹 Cleaning up
```

### Available Functions

| Flag | Function | Description |
|------|----------|-------------|
| `dirs` | create_dirs | Create ~/Codes and ~/Documents/Screenshots |
| `xcode` | install_xcode_tools | Install Xcode Command Line Tools |
| `brew` | install_brew | Install Homebrew and Brewfile packages |
| `node` | configure_node | Install n (Node version manager) and Bun |
| `venv` | create_virtualenvs | Create Python venvs (neovim, debugpy) |
| `tmux` | install_tmux_plugins | Install tmux plugin manager (tpm) |
| `yazi` | install_yazi_themes | Install Yazi file manager themes |
| `utils` | setup_utils | Install UV tools, LLM, Goose, gh-dash, etc. |
| `stow` | stow_dotfiles | Symlink dotfiles with GNU Stow |
| `cleanup` | cleanup | Run Homebrew cleanup and autoremove |

---

## Dotfile Configuration (GNU Stow)

Each directory in the repo is a "stow package" that gets symlinked to `$HOME`:

```bash
stow -d ~/dotfiles -t ~ zsh nvim tmux ghostty ...
```

To add configuration for a new tool:

1. Create directory: `mkdir -p ~/dotfiles/toolname/.config/toolname`
2. Add config files inside
3. Add to stow command in `stow_dotfiles()` function

---

## Sensitive Data

**This repo is public.** Never commit secrets, credentials, or personal identifiers.

### Git Identity

User name, email, and signing key live in `~/.gitconfig.local` (untracked).
The tracked `git/.gitconfig` includes it via:

```ini
[include]
  path = ~/.gitconfig.local
```

On a fresh machine, create `~/.gitconfig.local`:

```ini
[user]
	name = Your Name
	email = your@email.com
	signingkey = ~/.ssh/id_ed25519_signing.pub
```

Without this file, git will prompt for identity on first commit. Everything else (aliases, diff tools, signing config) lives in the tracked `.gitconfig`.

### Secrets in Shell

The `setenv` function in `zsh/.aliases` uses 1Password CLI (`op read`) to resolve secrets at runtime. Never hardcode API keys or tokens in tracked files.

### What NOT to commit

- `.env` files (already in `.gitignore`)
- API keys, tokens, passwords
- Snowflake/cloud account identifiers
- Private SSH/GPG keys
- Connection strings with credentials

---

## Known Issues (non-critical)

These are documented quirks that don't break anything but could be cleaned up:

| Issue | File | Notes |
|-------|------|-------|
| Starship config in `~/.config/starship/starship.toml` | `starship/.config/starship/` | Starship defaults to `~/.config/starship.toml`. Works if `STARSHIP_CONFIG` is set. |
| `python@3.14` not explicit in Brewfile | `Brewfile` | Installed as a dependency. Add `brew "python@3.14"` to be explicit. |
| `GOROOT=/usr/local/go` wrong for Apple Silicon | `zsh/.exports:114` | Should be `/opt/homebrew/opt/go/libexec` |
| `FZF_DEFAULT_OPTS` set twice (overwritten) | `zsh/.exports:53,158` | Catppuccin theme on line 158 wins |
| `FZF_DEFAULT_COMMAND` set twice (overwritten) | `zsh/.exports:42,57` | `fd` version on line 57 wins |
| `%HOME` typo in `.zshrc` bun completions | `zsh/.zshrc:38` | Should be `$HOME`. Dead code (also in `.exports:145`). |
| `.zprofile` brew line appended on every run | `install.sh:301` | Should check if already present |
| `.zshenv.sh` / `.zlogin.sh` never sourced | `zsh/` | Zsh reads `~/.zshenv` not `~/.zshenv.sh`. These files are dead. |
| Duplicate `compinit` calls | `zsh/.zshrc:18,70` | Second call is redundant (~100ms overhead) |
| `n` alias shadows node version manager | `zsh/.aliases:26` | `alias n="nvim"` prevents using `n` for Node |

---

## Key Files by Purpose

| Purpose | File(s) |
|---------|---------|
| Add Homebrew tool | `Brewfile` |
| Add non-brew tool | `install.sh` (setup_utils or appropriate function) |
| Track tool version | `scripts/versions.sh` (TRACKED_TOOLS) |
| Tool descriptions | `bin/tools.py` |
| Shell aliases | `zsh/.aliases` |
| Environment vars | `zsh/.exports` |
| Neovim config | `nvim/.config/nvim/` |
