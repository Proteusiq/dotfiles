---
name: dotfiles
description: Repository knowledge for this dotfiles setup. Use when adding tools, editing shell configs, understanding the architecture, or working with GNU Stow.
---

# Dotfiles Repository Knowledge

Repository-specific knowledge for this dotfiles setup. Principles are in `MANIFESTO.md`. Development conventions are in `AGENTS.md`.

**This repo is public.** Never commit secrets, credentials or personal identifiers.

## Adding Tools

**Important:** Never install a tool directly (`brew install`, `cargo install`, `npm i -g`). Declare it in the repository first, then run `update`.

### Flow

1. **Find the source.** `brew search`, taps, PyPI, crates.io, npm.
2. **Declare it in one place**, in this order of preference:

   | Tool type | File | Entry |
   |-----------|------|-------|
   | Homebrew formula | `Brewfile` | `brew "tool"` |
   | GUI app | `Brewfile` | `cask "app"` |
   | Formula from a third-party tap | `Brewfile` | `tap "user/repo"` and `brew "user/repo/tool"` |
   | Python CLI | `Brewfile` | `uv "tool"` (extras allowed: `uv "harlequin[duckdb]"`) |
   | Rust CLI | `Brewfile` | `cargo "crate"` |
   | Language runtime | `mise/.config/mise/config.toml` | `node = "lts"` |
   | npm-based CLI | `mise/.config/mise/config.toml` | `"npm:@scope/pkg" = "latest"` |
   | Cannot be declared (remote installer, gh extension) | `install.sh` | see below |

   `install.sh` trusts only taps declared with a `tap` line. A new tap is a reviewed change.

3. **Add a catalog entry** in `bin/tools.py`: a `(name, description, example)` tuple in the matching `*_TOOLS` list. The prek hook `tool-catalog` runs `scripts/check_catalog.py` and fails if a Brewfile or mise tool has no entry. Libraries and helpers go in `NOT_CATALOGUED` in that script. Package names that differ from the catalog name go in `CATALOG_NAMES`.
4. **Add long-form docs** to `Tools.md` if the tool needs more than one line.
5. **Install:** `update --only brew`, `update --only runtimes`, or `update <tool>`.

### install.sh (only when a tool cannot be declared)

| Need | Where | Helper |
|------|-------|--------|
| Official remote installer (Herdr, Unsloth Studio) | `setup_utils()` | `run_remote_installer "Name" "https://url/install.sh" [workdir]` with a `has_cmd` or directory guard |
| gh extension | `GH_EXTENSIONS` array | `install_gh_extensions` |
| Git clone (tpm, Yazi flavors) | own step function | `git_install "tool" "url" "folder" "friendly name"` |

`run_remote_installer` downloads to a temp file, runs it without sudo, and does nothing in `--dry-run`.

### Version tracking

The Brewfile and mise tools need no tracking. `get_version` in `scripts/versions.sh` covers only tools installed outside them: `herdr`, `tpm`, `yazi-flavors`. `track_version` records changes, and `print_version_summary` shows them at the end of a run. Add a `case` branch to `get_version` only for a new non-declarative install.

---

## CLI Commands

```bash
update                    # All steps (idempotent, quiet)
update -v                 # Detailed output with timestamps
update -vv                # Also show each executed command
update --dry-run          # Preview, change nothing

update --doctor           # Health check (scripts/doctor.sh)
update <tool>             # Upgrade one tool (brew, cask, uv, cargo, mise, herdr, tpm, yazi-flavors)
update --all              # Upgrade brew, uv, cargo crates from the Brewfile, mise, tpm plugins, Yazi flavors
update --outdated         # Show available updates (brew, cask, uv, mise)

update --only <step>      # Run one step
update --skip "<step...>" # Skip steps
update --list             # List steps
update --info <tool>      # Source, version, description, example
update --versions [group] # brew | cask | uv | cargo | mise | git | other
update --interactive      # Allow prompts (Xcode install)
```

`update` is an alias for `"$DOTFILES_DIR/install.sh"`. Log: `$XDG_STATE_HOME/dotfiles/install.log`.

`update <tool>` also finds mise tools by command name (for example `update pi`).

### Doctor checks

`update --doctor` runs `scripts/doctor.sh`:

- Stow conflicts and stale links into the repository
- Uncommitted changes in the repository
- PATH order: `git`, `rsync`, `python3`, `node` must not resolve to `/usr/bin` or `/bin`
- Interactive zsh startup time (target below 300 ms)
- Configs: `zsh -n`, `ghostty +validate-config`, `tmux source-file -n`, `yazi --version`, `~/.config/aerospace/aerospace.toml` exists
- `brew bundle check` and packages installed but not in the Brewfile
- Git identity files and the identity of this repository
- `mise doctor` and `rustup default`

---

## Architecture

```
dotfiles/
├── Brewfile                 # System tools: brew, cask, uv, cargo
├── install.sh               # Installer: CLI, steps, orchestration
├── run.sh                   # Bootstrap: clone or pull, then install.sh
├── .pre-commit-config.yaml  # Git hooks (prek)
├── scripts/
│   ├── logging.sh           # Colors, log_*, spinner, run_quiet, execute, has_cmd
│   ├── ui.sh                # draw_table, print_section
│   ├── versions.sh          # --versions, --info, --outdated, --all, update <tool>
│   ├── doctor.sh            # --doctor
│   └── check_catalog.py     # Brewfile + mise vs bin/tools.py
├── bin/
│   ├── aliases.py           # `aliases`: parses aliases.zsh and functions.zsh
│   └── tools.py             # `tools`: tool catalog, used by update --info
├── docs/                    # VitePress site (GitHub Pages)
├── .github/workflows/       # lint.yml (hooks, dry run, stow, zsh), docs.yml
└── <stow packages>/         # aerospace atuin ghostty git mise nvim sesh starship tmux yazi zsh
```

### Installation Pipeline

```
📋 Checking prerequisites           ← macOS, Brewfile present
📁 Creating directories             dirs
🔨 Installing Xcode CLI             xcode
🍺 Installing Homebrew packages     brew      ← Brewfile (bundle, rustup, second pass, check)
🔗 Linking dotfiles                 stow      ← GNU Stow
📦 Installing runtimes              runtimes  ← mise install, rustup default stable
🐍 Creating Python virtual envs     venv      ← ~/.virtualenvs/neovim (pynvim)
💻 Installing tmux plugins          tmux      ← tpm (git)
🎨 Installing Yazi themes           yazi      ← yazi-rs/flavors (git)
🔧 Installing CLI utilities         utils     ← git lfs, gh-dash, Bicep, Herdr, Unsloth, bin/*.py
🍎 Configuring macOS                macos     ← Touch ID sudo, screenshot folder
🧹 Cleaning up                      cleanup   ← brew cleanup/autoremove, undeclared list
```

A failed step or command does not stop the run. `run_step` records failed steps in `FAILED_STEPS`, `run_quiet` records failed commands in `FAILED_COMMANDS`, and `report_failures` prints both and exits non-zero.

The `brew` step keeps sudo alive only during `brew bundle`, then runs `sudo -k`.

### Steps

| Flag | Function | Description |
|------|----------|-------------|
| `dirs` | `create_dirs` | Create `~/Codes`, `~/Documents/Screenshots`, log directory |
| `xcode` | `install_xcode_tools` | Install Xcode Command Line Tools |
| `brew` | `install_brew` | Install Homebrew, trust Brewfile taps, `brew bundle`, Rust toolchain |
| `stow` | `stow_dotfiles` | Link configs with GNU Stow, back up conflicts, prune stale links |
| `runtimes` | `install_runtimes` | `mise install`, `rustup default stable` |
| `venv` | `create_virtualenvs` | `~/.virtualenvs/neovim` with pynvim (`python3_host_prog`) |
| `tmux` | `install_tmux_plugins` | tpm clone and `install_plugins` |
| `yazi` | `install_yazi_themes` | Clone Yazi flavors to `~/.config/yazi/flavors` |
| `utils` | `setup_utils` | `git lfs install`, gh extensions, `az bicep install`, Herdr, Unsloth Studio, `~/.rgrc`, link `bin/*.py` to `~/.local/bin/<name>` |
| `macos` | `configure_macos` | Touch ID for sudo via `/etc/pam.d/sudo_local` (with pam_reattach), screenshot location |
| `cleanup` | `cleanup` | `brew cleanup`, `brew autoremove`, warn about packages not in the Brewfile |

---

## Dotfile Configuration (GNU Stow)

Packages: `aerospace atuin ghostty git mise nvim sesh starship tmux yazi zsh`.

```bash
stow --no-folding --restow -d "$DOTFILES_DIR" -t "$HOME" <packages>
```

- `--no-folding` links files, not directories. So `~/.config/git/` is a real directory and can hold untracked files next to the linked ones.
- Before stowing, `prepare_stow_targets` removes symlinks into the repository whose target no longer exists, and moves conflicting real files to `~/.dotfiles-backup/<timestamp>/`.

### Add a package

1. Create the directory with the target layout: `mkdir -p toolname/.config/toolname`.
2. Add the config files.
3. Add the package name to `STOW_PACKAGES` in `scripts/packages.sh` (the one list used by `install.sh`, `scripts/doctor.sh` and CI).
4. Run `update --only stow`, then `update --doctor`.

---

## Sensitive Data

### Git identity

The tracked `git/.config/git/config` has no identity. `user.useConfigOnly = true`, so git refuses to commit without one.

`includeIf "hasconfig:remote.*.url:..."` selects the identity by remote:

| Remote | File |
|--------|------|
| `git@github.com:`, `git@github-personal:`, `https://github.com/` + `[Pp]roteusiq/**` | `~/.config/git/personal.gitconfig` |
| `git@github.com:`, `git@github-work:`, `https://github.com/` + `[Nn]orlys-[Aa]-[Ss]/**` | `~/.config/git/work.gitconfig` |
| always, last | `~/.config/git/local.gitconfig` |

These files are not tracked. Example:

```ini
[user]
    name = Your Name
    email = you@example.com
    signingkey = ~/.ssh/id_ed25519_personal_signing.pub
```

Signing: `gpg.format = ssh`, `commit.gpgSign = true`, `tag.gpgSign = true`, `gpg.ssh.allowedSignersFile = ~/.ssh/allowed_signers`.

### Machine-local shell files

- `~/.zshrc.local`: sourced last by `~/.zshrc`
- `~/.zprofile.local`: sourced by `~/.zprofile`

### Secrets in the shell

- Prefer `envrun <command>`: runs `op run --env-file=.env -- <command>`, so 1Password resolves `op://` references for that command only.
- `setenv` exports `.env` into the current shell (`--key` resolves `op://` with `op read`). It skips invalid names and protected names (`PATH`, `HOME`, `SHELL`, ...). `unsetenv` reverses it.

### Secret scanning

- prek hook `gitleaks` scans staged changes. `detect-private-key` also runs.
- CI runs `gitleaks git` on the full history.
- The global git ignore (`git/.config/git/ignore`) excludes `.env`, `.env.*` (except `.env.example`, `.env.sample`), `.envrc.local` and `*.pem`.

### What NOT to commit

- `.env` files, API keys, tokens, passwords
- Cloud or Snowflake account identifiers
- Private SSH or GPG keys
- Connection strings with credentials

---

## Conventions and gotchas

- **PATH is built in `zsh/.zshenv`** by `dotfiles_path` and rebuilt in `zsh/.zprofile` after macOS `path_helper`. Do not prepend PATH in `.zshrc`. The only exception is the GNU `gnubin` directories.
- **GNU tools shadow BSD tools in interactive shells only.** Scripts and `zsh -c` keep the BSD versions.
- **Installers that append to `~/.zshrc` change the tracked file.** Move those lines to `~/.zshrc.local`. `update --doctor` warns about uncommitted changes in the repository.
- **tmux autostart** happens only in Ghostty, outside tmux, outside SSH, not for `zsh -c`. Set `DOTFILES_NO_TMUX=1` to disable it.
- **zsh plugins** are listed in `zsh/.config/zsh/plugins.txt`. antidote builds a static bundle in `$XDG_CACHE_HOME/zsh`.
- **Neovim extras** are listed only in `nvim/.config/nvim/lazyvim.json`. Python LSP is `ty` with `ruff`, both from Homebrew (`mason = false`).
- **Hooks run with prek.** Install once per clone with `prek install`. Run all with `prek run --all-files`. Shell scripts are formatted with `shfmt -i 4`.
- **After any change, run `update --doctor`.**

---

## Key Files by Purpose

| Purpose | File(s) |
|---------|---------|
| Add a system tool (brew, cask, uv, cargo) | `Brewfile` |
| Add a runtime or npm-based CLI | `mise/.config/mise/config.toml` |
| Add a tool that cannot be declared | `install.sh` (`setup_utils`, `GH_EXTENSIONS`) |
| Tool catalog (`tools`, `update --info`) | `bin/tools.py` |
| Catalog check | `scripts/check_catalog.py` |
| Version change summary | `scripts/versions.sh` (`get_version`) |
| Health check | `scripts/doctor.sh` |
| Environment variables and PATH | `zsh/.zshenv` |
| Login shell PATH fix | `zsh/.zprofile` |
| Interactive shell | `zsh/.zshrc` |
| Shell aliases | `zsh/.config/zsh/aliases.zsh` |
| Shell functions | `zsh/.config/zsh/functions.zsh` |
| zsh plugins | `zsh/.config/zsh/plugins.txt` |
| fzf setup | `zsh/.config/zsh/fzf.zsh` |
| Git config and global ignore | `git/.config/git/config`, `git/.config/git/ignore` |
| tmux | `tmux/.tmux.conf` |
| Neovim | `nvim/.config/nvim/` (extras in `lazyvim.json`, plugins in `lua/plugins/`) |
| Git hooks | `.pre-commit-config.yaml` |
| CI | `.github/workflows/lint.yml`, `.github/workflows/docs.yml` |
