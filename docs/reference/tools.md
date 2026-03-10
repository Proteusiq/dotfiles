# Tools Reference

A comprehensive list of all tools included in this dotfiles setup.

## Terminal & Shell

| Tool | Description | Install |
|------|-------------|---------|
| [Ghostty](https://ghostty.org) | GPU-accelerated terminal emulator | `brew install ghostty` |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer | `brew install tmux` |
| [Zsh](https://www.zsh.org) | Modern shell | `brew install zsh` |
| [Starship](https://starship.rs) | Cross-shell prompt | `brew install starship` |
| [sesh](https://github.com/joshmedeski/sesh) | tmux session manager | `brew install sesh` |

## Modern CLI Replacements

| Classic | Modern | Description |
|---------|--------|-------------|
| `cat` | [bat](https://github.com/sharkdp/bat) | Syntax highlighting, git integration |
| `ls` | [eza](https://github.com/eza-community/eza) | Icons, colors, tree view |
| `find` | [fd](https://github.com/sharkdp/fd) | Faster, respects .gitignore |
| `grep` | [ripgrep](https://github.com/BurntSushi/ripgrep) | 10x faster search |
| `cd` | [zoxide](https://github.com/ajeetdsouza/zoxide) | Smart directory jumping |
| `diff` | [difftastic](https://difftastic.wilfred.me.uk) | Structural diff |
| `du` | [dust](https://github.com/bootandy/dust) | Intuitive disk usage |
| `top` | [btop](https://github.com/aristocratos/btop) | Beautiful process viewer |
| `curl` | [httpie](https://httpie.io) | Human-friendly HTTP |
| `man` | [tldr](https://tldr.sh) | Simplified man pages |

## File Management

| Tool | Description |
|------|-------------|
| [Yazi](https://yazi-rs.github.io) | Terminal file manager |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder |
| [broot](https://dystroy.org/broot) | Tree navigation |
| [ncdu](https://dev.yorhel.nl/ncdu) | Disk usage analyzer |
| [stow](https://www.gnu.org/software/stow) | Symlink manager |

## Development

### Editors

| Tool | Description |
|------|-------------|
| [Neovim](https://neovim.io) | Modern Vim |
| [LazyVim](https://lazyvim.org) | Neovim configuration |
| [dawn](https://github.com/decahedron1/dawn) | Markdown editor |

### Git

| Tool | Description |
|------|-------------|
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for git |
| [gh](https://cli.github.com) | GitHub CLI |
| [delta](https://github.com/dandavison/delta) | Better git diffs |
| [serie](https://github.com/lusingander/serie) | Commit graph viewer |
| [gitlogue](https://github.com/bensadeh/gitlogue) | Git log viewer |

### Languages & Runtimes

| Tool | Description |
|------|-------------|
| [uv](https://github.com/astral-sh/uv) | Fast Python package manager |
| [pixi](https://prefix.dev/pixi) | Conda-compatible manager |
| [n](https://github.com/tj/n) | Node.js version manager |
| [Bun](https://bun.sh) | Fast JS runtime |
| [Go](https://go.dev) | Go programming language |
| [Rust](https://www.rust-lang.org) | Rust toolchain |

### Testing & Debugging

| Tool | Description |
|------|-------------|
| [hyperfine](https://github.com/sharkdp/hyperfine) | Benchmarking tool |
| [watchexec](https://github.com/watchexec/watchexec) | File watcher |
| [act](https://github.com/nektos/act) | Run GitHub Actions locally |
| [vhs](https://github.com/charmbracelet/vhs) | Terminal GIF recorder |

## Data & Database

| Tool | Description |
|------|-------------|
| [jq](https://jqlang.github.io/jq) | JSON processor |
| [yq](https://github.com/mikefarah/yq) | YAML processor |
| [harlequin](https://harlequin.sh) | Terminal SQL IDE |
| [tabiew](https://github.com/shshemi/tabiew) | CSV/Parquet viewer |
| [mongosh](https://www.mongodb.com/docs/mongodb-shell) | MongoDB shell |
| [dbt](https://www.getdbt.com) | Data build tool |
| [lnav](https://lnav.org) | Log file navigator |

## Infrastructure

| Tool | Description |
|------|-------------|
| [lima](https://lima-vm.io) | Linux VMs on macOS |
| [lazydocker](https://github.com/jesseduffield/lazydocker) | Docker TUI |
| [terraform](https://www.terraform.io) | Infrastructure as code |
| [azure-cli](https://docs.microsoft.com/cli/azure) | Azure CLI |

## AI & LLM

| Tool | Description |
|------|-------------|
| [OpenCode](https://opencode.ai) | AI coding agent |
| [Ollama](https://ollama.ai) | Local LLM runner |
| [llamabarn](https://llamabarn.ai) | Menu bar LLM |
| [llama.cpp](https://github.com/ggerganov/llama.cpp) | Local inference |

## Productivity

| Tool | Description |
|------|-------------|
| [AeroSpace](https://github.com/nikitabobko/AeroSpace) | Tiling window manager |
| [Raycast](https://raycast.com) | Spotlight replacement |
| [1Password](https://1password.com) | Password manager |
| [CleanShot](https://cleanshot.com) | Screenshot tool |
| [espanso](https://espanso.org) | Text expander |

## Exploring Tools

Use the built-in `tools` command to explore installed tools:

```bash
# Interactive TUI
tools

# List all tools
tools --list

# Filter by category
tools --category "Modern CLI"

# Search tools
tools --search "git"

# JSON output
tools --json
```

## Checking Versions

```bash
# All tools
update --versions

# By package manager
update --versions brew
update --versions uv
update --versions cargo
update --versions git

# Tool info
update --info bat
update --info ripgrep
```

## Updating Tools

```bash
# Check for updates
update --outdated

# Update everything
update --all

# Update specific tool
update bat
update harlequin
```
