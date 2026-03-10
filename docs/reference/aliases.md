# Aliases Reference

A comprehensive list of shell aliases and functions.

## Navigation

| Alias | Command | Description |
|-------|---------|-------------|
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |
| `....` | `cd ../../..` | Go up three directories |
| `~` | `cd ~` | Go to home |
| `-` | `cd -` | Go to previous directory |

## File Operations

### Listing (eza)

| Alias | Command | Description |
|-------|---------|-------------|
| `ls` | `eza --icons --group-directories-first` | List files |
| `ll` | `eza -la --icons --group-directories-first` | Long list |
| `la` | `eza -a --icons` | List all |
| `lt` | `eza --tree --level=2 --icons` | Tree view |
| `l.` | `eza -d .*` | List hidden files |

### Viewing (bat)

| Alias | Command | Description |
|-------|---------|-------------|
| `cat` | `bat --style=auto` | View file with syntax highlighting |
| `less` | `bat --style=auto --paging=always` | Page through file |

### Finding

| Alias | Command | Description |
|-------|---------|-------------|
| `find` | `fd` | Find files (fd) |
| `grep` | `rg` | Search content (ripgrep) |

## Git

### Basic Commands

| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Git shorthand |
| `gs` | `git status` | Status |
| `ga` | `git add` | Stage files |
| `gaa` | `git add --all` | Stage all |
| `gc` | `git commit` | Commit |
| `gcm` | `git commit -m` | Commit with message |
| `gca` | `git commit --amend` | Amend last commit |

### Branches

| Alias | Command | Description |
|-------|---------|-------------|
| `gb` | `git branch` | List branches |
| `gba` | `git branch -a` | All branches |
| `gbd` | `git branch -d` | Delete branch |
| `gco` | `git checkout` | Checkout |
| `gcb` | `git checkout -b` | New branch |
| `gm` | `git merge` | Merge |

### Remote

| Alias | Command | Description |
|-------|---------|-------------|
| `gp` | `git push` | Push |
| `gpf` | `git push --force-with-lease` | Force push (safe) |
| `gl` | `git pull` | Pull |
| `gf` | `git fetch` | Fetch |
| `gr` | `git remote -v` | List remotes |

### History & Diff

| Alias | Command | Description |
|-------|---------|-------------|
| `gd` | `git diff` | Diff |
| `gds` | `git diff --staged` | Diff staged |
| `glog` | `git log --oneline --graph --decorate` | Pretty log |
| `glast` | `git log -1 HEAD --stat` | Last commit |

### Tools

| Alias | Command | Description |
|-------|---------|-------------|
| `lg` | `lazygit` | Open lazygit |

## Editors

| Alias | Command | Description |
|-------|---------|-------------|
| `n` | `nvim` | Neovim |
| `v` | `nvim` | Neovim |
| `vim` | `nvim` | Neovim |

## Python

| Alias | Command | Description |
|-------|---------|-------------|
| `py` | `python` | Python |
| `py3` | `python3` | Python 3 |
| `pip` | `uv pip` | UV pip |
| `venv` | `source .venv/bin/activate` | Activate venv |
| `mkvenv` | `uv venv` | Create venv |

## Docker

| Alias | Command | Description |
|-------|---------|-------------|
| `d` | `docker` | Docker |
| `dc` | `docker compose` | Docker Compose |
| `dps` | `docker ps` | List containers |
| `dimg` | `docker images` | List images |
| `lzd` | `lazydocker` | Lazydocker |

## System

| Alias | Command | Description |
|-------|---------|-------------|
| `c` | `clear` | Clear terminal |
| `h` | `history` | Command history |
| `path` | `echo $PATH \| tr ':' '\n'` | Show PATH |
| `ports` | `lsof -i -P -n \| grep LISTEN` | Show listening ports |
| `ip` | `curl -s ifconfig.me` | Public IP |
| `localip` | `ipconfig getifaddr en0` | Local IP |

## Homebrew

| Alias | Command | Description |
|-------|---------|-------------|
| `br` | `brew` | Homebrew |
| `bri` | `brew install` | Install |
| `bru` | `brew update && brew upgrade` | Update all |
| `brc` | `brew cleanup` | Cleanup |
| `brs` | `brew search` | Search |

## Utilities

| Alias | Command | Description |
|-------|---------|-------------|
| `weather` | `curl wttr.in` | Weather |
| `moon` | `curl wttr.in/moon` | Moon phase |
| `cheat` | `curl cheat.sh/` | Cheat sheets |
| `myip` | `curl ifconfig.me` | Public IP |

## Functions

### `mkcd` - Create and enter directory

```bash
mkcd mydir
# Creates mydir and cd into it
```

### `extract` - Universal extractor

```bash
extract archive.tar.gz
extract file.zip
extract package.7z
```

### `fkill` - Fuzzy process killer

```bash
fkill
# Shows process list, select to kill
```

### `take` - Create nested directories

```bash
take path/to/nested/dir
# Creates all directories and enters the last one
```

### `backup` - Create timestamped backup

```bash
backup myfile.txt
# Creates myfile.txt.2024-01-15_10-30-00.bak
```

### `serve` - Quick HTTP server

```bash
serve
# Starts server at http://localhost:8000

serve 3000
# Starts server at http://localhost:3000
```

## Exploring Aliases

Use the built-in `aliases` command:

```bash
# Interactive TUI mode
aliases

# List all aliases as table
aliases --list

# Search for specific aliases
aliases --search git

# Export as JSON
aliases --json
```

## Adding Custom Aliases

Edit `~/.aliases` or `~/dotfiles/zsh/.aliases`:

```bash
# Add your alias
alias myalias="my command"

# Add a function
myfunction() {
    echo "Hello, $1!"
}
```

Then reload:

```bash
source ~/.aliases
# or
exec zsh
```
