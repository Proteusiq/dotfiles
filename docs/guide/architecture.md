# Architecture

This page describes the repository layout, how files reach your home directory, and the order in which the shell reads them.

## Repository Layout

```
dotfiles/
├── aerospace/              # stow package: AeroSpace window manager
├── atuin/                  # stow package: shell history
├── ghostty/                # stow package: terminal
├── git/                    # stow package: Git config and global ignore
├── mise/                   # stow package: runtimes
├── nvim/                   # stow package: Neovim (LazyVim)
├── sesh/                   # stow package: tmux sessions
├── starship/               # stow package: prompt
├── tmux/                   # stow package: tmux
├── yazi/                   # stow package: file manager
├── zsh/                    # stow package: shell
├── bin/
│   ├── aliases.py          # `aliases` command
│   └── tools.py            # `tools` command and tool catalog
├── scripts/
│   ├── logging.sh          # installer module
│   ├── ui.sh               # installer module
│   ├── versions.sh         # installer module
│   ├── doctor.sh           # update --doctor
│   └── check_catalog.py    # Brewfile/mise vs. tools.py check
├── docs/                   # this site (VitePress)
├── .github/                # CI workflows and Dependabot
├── Brewfile                # system packages
├── install.sh              # installer (the `update` command)
├── run.sh                  # bootstrap
├── .pre-commit-config.yaml # Git hooks, run by prek
├── MANIFESTO.md
├── AGENTS.md
└── SKILL.md
```

## Stow Packages

[GNU Stow](https://www.gnu.org/software/stow/) links each package directory into `$HOME`. The path inside the package is the path in your home directory.

| Package | Links |
|---------|-------|
| `aerospace` | `~/.config/aerospace/aerospace.toml` |
| `atuin` | `~/.config/atuin/config.toml` |
| `ghostty` | `~/.config/ghostty/config` |
| `git` | `~/.config/git/config`, `~/.config/git/ignore` |
| `mise` | `~/.config/mise/config.toml` |
| `nvim` | files under `~/.config/nvim/` |
| `sesh` | `~/.config/sesh/sesh.toml` |
| `starship` | `~/.config/starship.toml` |
| `tmux` | `~/.tmux.conf` |
| `yazi` | `~/.config/yazi/{yazi,keymap,theme}.toml`, `~/.config/yazi/plugins/smart-enter.yazi/init.lua` |
| `zsh` | `~/.zshenv`, `~/.zprofile`, `~/.zshrc`, files under `~/.config/zsh/` |

The installer runs:

```bash
stow --no-folding --restow -d "$DOTFILES_DIR" -t "$HOME" <packages>
```

`--no-folding` links files, not directories. The directories, such as `~/.config/git/`, stay real. Untracked files can therefore live next to the links without entering the repository, for example the Git identity files in `~/.config/git/` and the Yazi flavors in `~/.config/yazi/flavors/`.

Because the links point into the repository, editing `~/.zshrc` edits `zsh/.zshrc` in the repository.

## Shell Load Order

```
every zsh         ~/.zshenv
login shells      /etc/zprofile    (macOS path_helper reorders PATH)
                  ~/.zprofile
interactive       ~/.zshrc
                  ~/.zshrc.local   (untracked)
```

| File | Read by | Purpose |
|------|---------|---------|
| `~/.zshenv` | every zsh, including scripts, IDEs and agents | XDG directories, `DOTFILES_DIR`, `EDITOR`, `PAGER`, tool variables, `HOMEBREW_PREFIX`. Defines and runs `dotfiles_path`, which builds `PATH`. No output, no side effects. |
| `/etc/zprofile` | login shells | Part of macOS. Runs `path_helper`, which moves the system directories to the front of `PATH`. |
| `~/.zprofile` | login shells | Runs `dotfiles_path` again to restore the order. Sources `~/.zprofile.local` if it exists. |
| `~/.zshrc` | interactive shells | tmux auto-start, GNU tools, history, plugins, completions, tool integrations, aliases and functions. |
| `~/.zshrc.local` | interactive shells | Machine-local settings and lines that installers append. Not tracked. |

See [Shell](/guide/shell) for details.

## Single Sources of Truth

Each kind of knowledge lives in one file:

| What | Where |
|------|-------|
| Formulae, casks, uv tools, cargo crates, trusted taps | `Brewfile` |
| Node, Go, Bun, pnpm and npm-based tools | `mise/.config/mise/config.toml` |
| zsh plugins | `zsh/.config/zsh/plugins.txt` |
| Aliases and functions | `zsh/.config/zsh/aliases.zsh`, `functions.zsh`. The `aliases` command parses these files. |
| Neovim language extras | `nvim/.config/nvim/lazyvim.json` |
| Tool descriptions | `bin/tools.py`. `scripts/check_catalog.py` fails when a `Brewfile` or mise tool has no entry. |
| Git identity | untracked files in `~/.config/git/` |

## Installer Modules

`install.sh` holds the CLI, the steps and the orchestration. It sources three modules:

| Module | Responsibility |
|--------|----------------|
| `scripts/logging.sh` | Colors, log levels, spinner. `run_quiet` runs a command, sends its output to the log in quiet mode, and records a failure. `execute` respects `--dry-run`. |
| `scripts/ui.sh` | Table drawing for the version summary. |
| `scripts/versions.sh` | `--versions`, `--info`, `--outdated`, `--all`, `update <tool>`, and the version change summary. |

`scripts/doctor.sh` is a separate script. `update --doctor` runs it, and it sources only `logging.sh`.

## CI and Hooks

| File | What it does |
|------|--------------|
| `.pre-commit-config.yaml` | Git hooks, run by [prek](https://prek.j178.dev). Install once per clone with `prek install`. See [Git](/guide/git#hooks-in-this-repository). |
| `.github/workflows/lint.yml` | On macOS: runs all hooks on all files, scans the full history with gitleaks, runs `install.sh --dry-run -v`, simulates stowing every package into an empty home, and starts zsh with only this config. |
| `.github/workflows/docs.yml` | Builds this site with VitePress (Node 24) and deploys it to GitHub Pages. Actions are pinned by commit SHA. |
| `.github/dependabot.yml` | Monthly updates for GitHub Actions and the docs npm packages. |

## Project Documents

| File | Content |
|------|---------|
| `MANIFESTO.md` | Principles, in 19 sections. |
| `AGENTS.md` | Development conventions and per-language tooling. |
| `SKILL.md` | Repository knowledge for coding agents, in the [Agent Skills](https://agentskills.io) format. |
