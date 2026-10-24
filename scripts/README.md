# Scripts Architecture

How the installer (`install.sh`, the `update` command) and its modules work.

## Overview

```
┌──────────────────────────────────────────────────────────────────────────┐
│                               install.sh                                 │
├──────────────────────────────────────────────────────────────────────────┤
│  Config  │  CLI parser  │  Step functions  │  run_step / report_failures │
└────┬─────┴──────┬───────┴────────┬─────────┴──────────────┬──────────────┘
     │ source     │ source         │ source                 │ exec
     ▼            ▼                ▼                        ▼
┌────────────┐ ┌──────────┐ ┌──────────────┐ ┌────────────────────────────┐
│ logging.sh │ │  ui.sh   │ │ versions.sh  │ │ doctor.sh (--doctor)       │
├────────────┤ ├──────────┤ ├──────────────┤ ├────────────────────────────┤
│ colors     │ │ tables   │ │ --versions   │ │ sources logging.sh         │
│ log_*      │ │ sections │ │ --info       │ │ links, repo, PATH, startup │
│ spinner    │ │          │ │ --outdated   │ │ configs, Brewfile,         │
│ run_quiet  │ │          │ │ --all        │ │ git identity, runtimes     │
│ execute    │ │          │ │ update <tool>│ │                            │
└────────────┘ └──────────┘ └──────────────┘ └────────────────────────────┘

check_catalog.py runs as a prek hook, not from install.sh.
```

## Files

```
scripts/
├── README.md          # This file
├── logging.sh         # Colors, logging, spinner, command execution, failure recording
├── ui.sh              # Table drawing
├── versions.sh        # Versions, tool info, outdated, update one or all tools
├── doctor.sh          # Health check (update --doctor)
└── check_catalog.py   # Every Brewfile/mise tool has an entry in bin/tools.py
```

## Modules

### logging.sh

Defines the colors (`RED`, `GREEN`, `YELLOW`, `BLUE`, `CYAN`, `BOLD`, `DIM`, `NC`) used by every script that sources it.

| Function | Purpose |
|----------|---------|
| `log_step` | Step header. Always shown |
| `log` | Message with timestamp (`-v`). Otherwise written to the log only |
| `log_info` | Info message (`-v`). Otherwise written to the log only |
| `log_warn` | Warning. Always shown |
| `log_error` | Error, to stderr. Always shown |
| `log_debug` | Debug message (`-vv` only) |
| `start_spinner` / `stop_spinner` | Spinner in quiet mode, on a terminal only |
| `run_quiet` | Run a command. Quiet: output goes to the log, spinner shown. Verbose: output shown. On failure: append `"<command> (exit N)"` to `FAILED_COMMANDS`, log the error, return the exit code. In `--dry-run`: print only |
| `execute` | Run a command with debug logging. In `--dry-run`: print only |
| `dry_run_msg` | Print a `[DRY RUN]` message (`--dry-run` with `-v`) |
| `has_cmd` | True if a command exists |

Verbosity levels:

| Level | Flag | Output |
|-------|------|--------|
| 0 | (default) | Step headers, spinner, warnings, errors |
| 1 | `-v` | Also messages with timestamps and command output |
| 2 | `-vv` | Also each executed command |

### ui.sh

| Function | Purpose |
|----------|---------|
| `draw_table` | Box table from `--headers`, `--widths`, `--rows`. Colors the status column (`New`, `Updated`) |
| `print_section` | Section with icon, title and a Tool/Version table |

### versions.sh

| Function | CLI | Purpose |
|----------|-----|---------|
| `show_installed_versions` | `--versions [group]` | Table of installed versions, paged with `less -RFX` |
| `collect_all_versions` | | Rows `group\|name\|version` for brew, cask, uv, cargo, git, mise, other |
| `get_tool_info` | `--info <tool>` | Description and example from `bin/tools.py --json`, else from brew or PyPI. Source and version from `detect_tool_source` |
| `show_outdated` | `--outdated` | Outdated brew formulae, casks, uv tools (PyPI lookup), mise tools |
| `update_all` | `--all` | `brew update` + `brew upgrade`, `uv tool upgrade --all`, `cargo install --locked` for each crate in the Brewfile, `mise upgrade`, tpm `update_plugins all`, Yazi flavors `git pull`, brew cleanup |
| `brewfile_cargo_crates` | | Crate names from `cargo "..."` lines in the Brewfile |
| `detect_tool_source` | | Which package manager owns a tool (see below) |
| `tool_version` | | Version of a tool for a given source |
| `update_tool` | `update <tool>` | Upgrade one tool, print old and new version |
| `get_version` | | Version of `herdr`, `tpm`, `yazi-flavors` (installed outside the Brewfile and mise) |
| `track_version` / `record_change` | | Record a version change in `VERSION_CHANGES` |
| `print_version_summary` | | Table of new and updated tools at the end of a run |

### doctor.sh

Runs on its own (`set -uo pipefail`) and sources `logging.sh`. Each check prints `✓` (pass), `!` (warning) or `✗` (failure). Exit code 1 if there is a failure.

| Check | What it tests |
|-------|---------------|
| `check_links` | `stow --no` reports no conflicts; no stale links into the repository |
| `check_repo_clean` | `git status --porcelain` is empty (warning) |
| `check_path_order` | `git`, `rsync`, `python3`, `node` do not resolve to `/usr/bin` or `/bin` in a fresh interactive zsh; Homebrew/uv binaries win over `/usr/bin`; `python3` is the pinned version |
| `check_startup_time` | Interactive zsh starts in less than `MAX_STARTUP_MS` (300) (warning) |
| `check_configs` | `zsh -n` on the zsh files, `ghostty +validate-config`, `tmux source-file -n`, `yazi --version`, `~/.config/aerospace/aerospace.toml` exists |
| `check_brewfile` | `brew bundle check --no-upgrade`; packages installed but not declared (warning) |
| `check_git_identity` | `personal.gitconfig` and `work.gitconfig` exist (warning); this repository has a `user.email` |
| `check_runtimes` | `mise doctor`, `rustup default` |

The checks run zsh with `DOTFILES_NO_TMUX=1`, so the greeting and the multiplexer do not start.

### check_catalog.py

Standard library only. Reads `brew`, `cask`, `uv` and `cargo` entries from the Brewfile and `[tools]` from `mise/.config/mise/config.toml`, removes tap prefixes and extras (`azure/azd/azd` → `azd`, `harlequin[duckdb]` → `harlequin`), and fails if a name has no entry in `bin/tools.py`.

- `NOT_CATALOGUED`: libraries, fonts and helpers that need no entry.
- `CATALOG_NAMES`: package names that differ from the catalog name (`npm:@earendil-works/pi-coding-agent` → `pi`).

The prek hook `tool-catalog` runs it when the Brewfile, `mise/`, `bin/tools.py` or the script changes.

## Installation Flow

```
update [flags]
   │
   ▼
1. parse_args
   • Query commands run and exit: --list, --versions, --info, --outdated,
     --all, --doctor, --help, update <tool>
   • Otherwise set DRY_RUN, VERBOSITY, ONLY_FUNCTION, SKIP_FUNCTIONS
   │
   ▼
2. Start log ($LOG_FILE), check_macos, check_prerequisites (Brewfile exists)
   │
   ▼
3. Steps (AVAILABLE_FUNCTIONS, in order; --only runs one, --skip removes some)

   dirs ──► xcode ──► brew ──► stow ──► runtimes ──► venv
                                                       │
   cleanup ◄── macos ◄── utils ◄── yazi ◄── tmux ◄─────┘

   Each step runs through run_step. A failed step is added to FAILED_STEPS
   and the run continues.
   │
   ▼
4. print_version_summary (herdr, tpm, yazi-flavors changes)
   │
   ▼
5. report_failures: if FAILED_STEPS or FAILED_COMMANDS is not empty,
   print them and exit 1
```

| Step | Function | Does |
|------|----------|------|
| `dirs` | `create_dirs` | `~/Codes`, `~/Documents/Screenshots`, log directory |
| `xcode` | `install_xcode_tools` | Xcode Command Line Tools (prompt only with `--interactive`) |
| `brew` | `install_brew` | Install Homebrew if missing, `brew update`, `brew trust` each Brewfile `tap`, sudo keepalive, `brew bundle install`, `ensure_rust_toolchain`, second `brew bundle install` if `brew bundle check` fails (cargo and uv entries need the toolchains), `sudo -k`, final `brew bundle check --no-upgrade` |
| `stow` | `stow_dotfiles` | `prepare_stow_targets` (remove stale links, back up conflicts), then `stow --no-folding --restow` |
| `runtimes` | `install_runtimes` | `install_default_python` (uv, version from `uv/.config/uv/.python-version`), `MISE_YES=1 mise install`, `ensure_rust_toolchain` |
| `venv` | `create_virtualenvs` | `uv venv ~/.virtualenvs/neovim`, `uv pip install --upgrade pynvim` |
| `tmux` | `install_tmux_plugins` | `git_install` tpm, then `install_plugins` |
| `yazi` | `install_yazi_themes` | `git_install` yazi-rs/flavors into `~/.config/yazi/flavors` |
| `utils` | `setup_utils` | `git lfs install`, `install_gh_extensions` (`dlvhdr/gh-dash`), `az bicep install`, Herdr and Unsloth Studio via `run_remote_installer`, `touch ~/.rgrc`, `link_bin_scripts` |
| `macos` | `configure_macos` | `enable_touch_id_sudo` (`/etc/pam.d/sudo_local`, with `pam_reattach.so` if present), screenshot location |
| `cleanup` | `cleanup` | `brew cleanup --prune=all`, `brew autoremove`, warn about `brew bundle cleanup` output (removes nothing) |

Helpers in `install.sh`:

| Helper | Purpose |
|--------|---------|
| `git_install` | Clone, or `git pull --ff-only`, and track the version |
| `run_remote_installer` | Download an official installer to a temp file, run it without sudo. Skipped in `--dry-run` |
| `trust_brewfile_taps` | `brew trust` only the taps declared in the Brewfile |
| `start_sudo_keepalive` / `stop_sudo_keepalive` | Keep sudo during `brew bundle` only, then `sudo -k` |
| `prepare_stow_targets` | Remove stale links, move conflicts to `~/.dotfiles-backup/<timestamp>/` |
| `link_bin_scripts` | Symlink `bin/*.py` to `~/.local/bin/<name>` (without `.py`) |

## Package Manager Detection

`update <tool>` and `update --info <tool>` call `detect_tool_source`. The first match wins:

| Order | Test | Source | Update command |
|-------|------|--------|----------------|
| 1 | `brew list --formula <tool>` | `brew` | `brew upgrade <tool>` |
| 2 | `brew list --cask <tool>` | `cask` | `brew upgrade --cask <tool>` |
| 3 | `uv tool list` | `uv` | `uv tool upgrade <tool>` |
| 4 | `cargo install --list` | `cargo` | `cargo install --locked <tool>` |
| 5 | `mise which <tool>` (tool or command name, e.g. `pi`) | `mise` | `mise upgrade <plugin>` |
| 6 | tool is `herdr` and installed | `herdr` | `herdr update` |
| 7 | tool is `tpm` and `~/.tmux/plugins/tpm` exists | `git-tpm` | `git pull --ff-only` |
| 8 | tool is `yazi-flavors` and `~/.config/yazi/flavors` exists | `git-yazi` | `git pull --ff-only` |

## Version Groups

| Group | Contents |
|-------|----------|
| `brew` | Homebrew formulae |
| `cask` | Homebrew casks |
| `uv` | uv tools |
| `cargo` | cargo crates |
| `mise` | mise tools (`mise ls --global`) |
| `git` | tpm, yazi-flavors |
| `other` | herdr |

## Stow Packages

`STOW_PACKAGES` in `scripts/packages.sh`, sourced by `install.sh`, `scripts/doctor.sh` and the CI workflow. Stow runs with `--no-folding`, so it links files, not directories.

```
dotfiles/
├── aerospace/  →  ~/.config/aerospace/aerospace.toml
├── atuin/      →  ~/.config/atuin/config.toml
├── ghostty/    →  ~/.config/ghostty/config
├── git/        →  ~/.config/git/config, ~/.config/git/ignore
├── mise/       →  ~/.config/mise/config.toml
├── nvim/       →  ~/.config/nvim/...
├── sesh/       →  ~/.config/sesh/sesh.toml
├── starship/   →  ~/.config/starship.toml
├── tmux/       →  ~/.tmux.conf
├── yazi/       →  ~/.config/yazi/...
└── zsh/        →  ~/.zshenv, ~/.zprofile, ~/.zshrc, ~/.config/zsh/...
```

## Environment Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `DOTFILES_DIR` | `$HOME/dotfiles` | Repository location |
| `LOG_FILE` | `${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/install.log` | Log file. Overwritten at the start of each run |

## Adding a Tool

See "Adding Tools" in [SKILL.md](../SKILL.md). In short: declare it in the Brewfile (brew, cask, uv, cargo) or the mise config; add a `bin/tools.py` entry; use `install.sh` only for tools that cannot be declared.

## Troubleshooting

| Need | Command |
|------|---------|
| Read the log | `less ~/.local/state/dotfiles/install.log` |
| Preview a run | `update --dry-run -v` |
| Run one step | `update --only stow -v` |
| Show each command | `update -vv` |
| Check the setup | `update --doctor` |
| Find missing Brewfile entries | `brew bundle check --verbose --file=~/dotfiles/Brewfile` |
