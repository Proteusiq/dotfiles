# Shell Configuration

The shell setup uses Zsh with Antigen for plugin management, Starship for the prompt, and a collection of modern CLI tools.

## File Structure

```
zsh/
├── .zshrc      # Main configuration, plugins
├── .aliases    # Aliases and functions (500+ lines)
└── .exports    # Environment variables, PATH
```

## Prompt: Starship

[Starship](https://starship.rs) provides a minimal, fast, customizable prompt.

```toml
# starship/.config/starship/starship.toml
format = """
$directory\
$git_branch\
$git_status\
$python\
$rust\
$nodejs\
$character"""
```

Features:
- Shows current directory with smart truncation
- Git branch and status indicators
- Language version when in project directory
- Fast (written in Rust)

## Plugin Management: Antigen

```bash
# .zshrc
source $(brew --prefix)/share/antigen/antigen.zsh

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions

antigen apply
```

## Modern CLI Tools

These aliases replace classic commands with modern alternatives:

```bash
# File listing (eza instead of ls)
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first"
alias lt="eza --tree --level=2 --icons"

# File viewing (bat instead of cat)
alias cat="bat --style=auto"

# Finding files (fd instead of find)
alias find="fd"

# Searching (ripgrep instead of grep)
alias grep="rg"

# Directory jumping (zoxide instead of cd)
eval "$(zoxide init zsh)"
alias cd="z"
```

## Key Aliases

### Navigation

```bash
..      # cd ..
...     # cd ../..
~       # cd ~
-       # cd - (previous directory)
```

### Git

```bash
g       # git
gs      # git status
ga      # git add
gc      # git commit
gp      # git push
gl      # git pull
gco     # git checkout
gb      # git branch
gd      # git diff
lg      # lazygit
```

### Development

```bash
n       # nvim
v       # nvim
py      # python
pip     # uv pip
venv    # source .venv/bin/activate
```

### Utilities

```bash
c       # clear
h       # history
ports   # lsof -i -P -n | grep LISTEN
weather # curl wttr.in
```

## Custom Functions

### `mkcd` - Create and enter directory

```bash
mkcd() {
    mkdir -p "$1" && cd "$1"
}
```

### `extract` - Universal archive extractor

```bash
extract() {
    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.zip)     unzip "$1" ;;
        *.7z)      7z x "$1" ;;
        *)         echo "Unknown format" ;;
    esac
}
```

### `fkill` - Fuzzy process killer

```bash
fkill() {
    ps aux | fzf --height 40% | awk '{print $2}' | xargs kill -9
}
```

## FZF Integration

[fzf](https://github.com/junegunn/fzf) provides fuzzy finding everywhere:

```bash
# Ctrl+R - Search command history
# Ctrl+T - Find files
# Alt+C  - Change directory

# Preview files while searching
export FZF_DEFAULT_OPTS="
  --preview 'bat --color=always --style=numbers {}'
  --preview-window right:60%
"

# Use fd for file finding
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
```

## Zoxide - Smart Directory Jumping

```bash
# Jump to most visited directory matching "proj"
z proj

# Jump to ~/projects/myapp
z myapp

# Interactive selection
zi
```

## Environment Variables

Key exports in `.exports`:

```bash
# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# Language
export LANG="en_US.UTF-8"

# History
export HISTSIZE=50000
export SAVEHIST=50000

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Python (UV)
export UV_SYSTEM_PYTHON=1

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
```

## Exploring Aliases

Use the built-in `aliases` command to explore all available aliases:

```bash
# Interactive TUI
aliases

# List all aliases
aliases --list

# Search for git aliases
aliases --search git

# JSON output for scripting
aliases --json
```
