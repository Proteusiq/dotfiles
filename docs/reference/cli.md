# CLI Reference

Commands provided by this repository:

| Command | What it is |
|---------|------------|
| `update` | Alias for `"$DOTFILES_DIR/install.sh"`: install, update and check the setup |
| `aliases` | `bin/aliases.py`: browse shell aliases and functions |
| `tools` | `bin/tools.py`: browse the tool catalog |
| `prek` | Git hooks runner for this repository (`.pre-commit-config.yaml`) |

`aliases` and `tools` are uv scripts (`#!/usr/bin/env -S uv run --script`). The `utils` step links every `bin/*.py` to `~/.local/bin/<name>` as a symlink.

If the `update` alias is not available (first install, or a non-zsh shell), run `~/dotfiles/install.sh` directly.

## `update`

```bash
update [OPTIONS] [TOOL]
```

### Options

| Option | Description |
|--------|-------------|
| `-h`, `--help` | Show help |
| `-v`, `--verbose` | Detailed output with timestamps |
| `-vv` | Debug mode: show executed commands |
| `--dry-run` | Preview changes without executing |
| `--only <fn>` | Run only one step |
| `--skip "<fn> [fn...]"` | Skip steps. Several names go in **one quoted argument**: `--skip "venv brew"` |
| `--list` | List step names and the functions they run |
| `--versions [group]` | Show installed versions; optional group (see below) |
| `--info <tool>` | Show source, version, description, example and category of a tool |
| `--outdated` | Show packages with available updates |
| `--all` | Update all packages |
| `--doctor` | Health check (see [below](#update-doctor)) |
| `--interactive` | Enable interactive prompts (only the Xcode step prompts) |
| `--skip-interactive` | Disable interactive prompts (the default) |

`--list`, `--versions`, `--info`, `--outdated`, `--all`, `--doctor`, `--help` and `update <tool>` do their job and exit; they do not run the install steps.

### Steps

A full `update` runs these steps in order. Use the name with `--only` or `--skip`.

| Name | Function | What it does |
|------|----------|--------------|
| `dirs` | `create_dirs` | Create `~/Codes`, `~/Documents/Screenshots` and the log directory |
| `xcode` | `install_xcode_tools` | Install Xcode Command Line Tools |
| `brew` | `install_brew` | Install Homebrew if missing, trust the taps declared in the Brewfile, run `brew bundle` (formulae, casks, uv tools, cargo crates), ensure the stable Rust toolchain, run a second bundle pass for uv/cargo entries, then `brew bundle check --no-upgrade`. sudo is kept alive only during `brew bundle`, then dropped (`sudo -k`) |
| `stow` | `stow_dotfiles` | Link packages `aerospace atuin ghostty git mise nvim sesh starship tmux uv yazi zsh` with `stow --no-folding --restow`. First removes stale links into the repository and moves conflicting real files to `~/.dotfiles-backup/<timestamp>/` |
| `runtimes` | `install_runtimes` | Python 3.14 via `uv python install --upgrade --default`, `mise install` (node, go, bun, pnpm, usage, pi) and `rustup default stable` |
| `venv` | `create_virtualenvs` | Create `~/.virtualenvs/neovim` with pynvim (Neovim's Python provider) |
| `tmux` | `install_tmux_plugins` | Clone or update tpm, install tmux plugins |
| `yazi` | `install_yazi_themes` | Clone or update `yazi-rs/flavors` into `~/.config/yazi/flavors` |
| `utils` | `setup_utils` | `git lfs install`, gh extension `dlvhdr/gh-dash`, `az bicep install`, Herdr and Unsloth Studio installers, create `~/.rgrc`, link `bin/*.py` into `~/.local/bin` |
| `macos` | `configure_macos` | Touch ID for sudo via `/etc/pam.d/sudo_local` (with pam_reattach, so it works in tmux) when the Mac has a sensor; screenshots to `~/Documents/Screenshots` |
| `cleanup` | `cleanup` | `brew cleanup` and `brew autoremove`; warn about installed packages missing from the Brewfile (lists only, never removes) |

Remote installers (Herdr, Unsloth Studio) are downloaded to a temporary file and run without sudo; `--dry-run` skips them.

A failed step does not stop the run. The installer records every failed step and command, continues, prints a summary at the end and exits non-zero.

### Updating one tool

```bash
update <tool>
```

The source is detected in this order: Homebrew formula, Homebrew cask, uv tool, cargo crate, mise tool (by tool name or by the command it provides, e.g. `pi`), then `herdr`, `tpm` and `yazi-flavors`. One tool per call. The old and new versions are printed.

| Source | Update command used |
|--------|---------------------|
| brew | `brew upgrade <tool>` |
| cask | `brew upgrade --cask <tool>` |
| uv | `uv tool upgrade <tool>` |
| cargo | `cargo install --locked <tool>` |
| mise | `mise upgrade <plugin>` |
| herdr | `herdr update` |
| tpm, yazi-flavors | `git pull --ff-only` |

### Version groups

```bash
update --versions [brew|cask|uv|cargo|mise|git|other]
```

| Group | Contents |
|-------|----------|
| `brew` | Homebrew formulae |
| `cask` | Homebrew casks |
| `uv` | uv tools |
| `cargo` | cargo crates |
| `mise` | global mise runtimes |
| `git` | git-cloned repositories: `tpm`, `yazi-flavors` |
| `other` | `herdr` |

Without a group, all groups are shown. The output goes through `less -RFX`.

### `--outdated` and `--all`

`--outdated` checks Homebrew formulae, Homebrew casks, uv tools (against PyPI) and mise runtimes.

`--all` runs, in order: `brew update`; `sudo -v` once, then `brew upgrade` and `brew upgrade --cask`; `uv tool upgrade --all`; `cargo install --locked` for each `cargo` entry in the Brewfile; `mise upgrade`; tpm plugin update; `git pull` of the yazi flavors; `brew cleanup` and `brew autoremove`.

Some casks need admin rights, so `--all` asks for your password once at the start. The sudo timestamp is refreshed only while brew runs and dropped with `sudo -k` afterwards. Nothing is stored: a fresh machine has no 1Password and possibly no Touch ID, so the prompt is plain sudo. `update --only macos` turns later prompts into a fingerprint where the Mac has a sensor.

### `update --doctor`

Runs `scripts/doctor.sh`. Exits non-zero if any check fails; warnings do not fail.

| Section | Checks |
|---------|--------|
| Links | All stow packages link without conflicts (fix: `update --only stow`); no stale symlinks into the repository in `~` or `~/.config` |
| Repository | Working tree is clean (warning: an installer may have edited a linked file) |
| PATH | In a fresh interactive zsh, `git`, `rsync`, `python3` and `node` do not resolve to `/usr/bin` or `/bin`; Homebrew's `bin` is on `PATH` |
| Python | In a fresh interactive zsh, `python3` reports the version pinned in `uv/.config/uv/.python-version` (fix: `update --only runtimes`) |
| Shell startup | Interactive zsh starts in under 300 ms (warning otherwise) |
| Configs | `zsh -n` on `~/.zshenv`, `~/.zprofile`, `~/.zshrc`, `~/.config/zsh/*.zsh`; `ghostty +validate-config`; tmux config parses; `yazi --version`; `~/.config/aerospace/aerospace.toml` exists |
| Brewfile | `brew bundle check --no-upgrade` passes; warns about packages installed but not declared |
| Git identity | `~/.config/git/personal.gitconfig` and `work.gitconfig` exist (warnings); the dotfiles repository resolves a `user.email` |
| Runtimes | `mise doctor` passes; `rustup default` is set |

### Examples

```bash
update                     # full install (quiet)
update -v                  # full install with detailed output
update --dry-run -v        # preview everything
update --only brew         # only Homebrew packages
update --only stow         # re-link dotfiles after adding a file
update --skip venv         # everything except the Neovim venv
update --skip "venv brew"  # skip several steps
update --list              # step names

update bat                 # update bat (brew)
update harlequin           # update harlequin (uv)
update pay-respects        # update a cargo crate
update pi                  # update a mise tool by its command name
update tpm                 # update tpm

update --outdated          # what can be updated
update --all               # update everything
update --versions uv       # uv tool versions
update --info bat          # info about bat
update --doctor            # health check
```

### Environment

| Variable | Default | Description |
|----------|---------|-------------|
| `DOTFILES_DIR` | `$HOME/dotfiles` | Repository location |
| `LOG_FILE` | `$XDG_STATE_HOME/dotfiles/install.log` (`~/.local/state/dotfiles/install.log` when `XDG_STATE_HOME` is unset) | Log of the last install run |

The log is overwritten at the start of every install run.

### Exit codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| non-zero | A step or command failed (summary printed, details in `$LOG_FILE`), an unknown option or step, a failed `update <tool>`, or a failed doctor check |

## `aliases`

Browse the aliases and functions defined in `zsh/.config/zsh/aliases.zsh` and `functions.zsh`. The script parses those files on every run. See the [Aliases reference](./aliases.md).

| Option | Description |
|--------|-------------|
| *(none)* | Usage and categories with counts |
| `-s`, `--show <category>` | Show one category |
| `-d`, `--describe <name>` | Show one alias or function |
| `-t`, `--tui` | Interactive browser (`/` search, `Esc` clear, `j`/`k` move, `q` quit) |

Categories: `git`, `files`, `nav`, `term`, `pkg`, `sys`, `gnu`, `fn`.

```bash
aliases
aliases -s git
aliases -d gcl
aliases --tui
```

## `tools`

Browse the tool catalog in `bin/tools.py`. See the [Tools reference](./tools.md).

| Option | Description |
|--------|-------------|
| *(none)* | Usage and categories with counts |
| `-s`, `--show <category>` | Show one category |
| `-d`, `--describe <name>` | Show one tool |
| `-j`, `--json <name>` | One tool as JSON; exits 1 if unknown (used by `update --info`) |
| `-t`, `--tui` | Interactive browser (`/` search, `Esc` clear, `j`/`k` move, `q` quit) |

Categories: `shell`, `edit`, `cli`, `files`, `vc`, `quality`, `data`, `dev`, `infra`, `lang`, `ai`, `gnu`, `media`, `apps`, `wm`, `sys`.

```bash
tools
tools -s vc
tools -d lazygit
tools -j lazygit
tools --tui
```

## `prek` (git hooks)

The repository's hooks are defined in `.pre-commit-config.yaml` and run by [prek](https://prek.j178.dev), a pre-commit compatible runner. Hook tools come from the Brewfile (`language: system`).

```bash
prek install               # once per clone: install the git hook shims
prek run --all-files       # run every hook on all tracked files
prek run shellcheck        # run one hook (by id)
```

| Hook | Checks |
|------|--------|
| builtin | trailing whitespace (not `*.md`), end of file, merge conflict markers, YAML, TOML, JSON (not `lazy-lock.json`), private keys |
| `gitleaks` | Secrets in staged changes |
| `shellcheck`, `shfmt` | `install.sh`, `run.sh`, `scripts/*.sh` (`shfmt -i 4`) |
| `zsh-syntax` | `zsh -n` on the zsh files |
| `stylua` | Lua formatting |
| `actionlint` | `.github/workflows/` |
| `brewfile` | The Brewfile parses |
| `tool-catalog` | Every Brewfile and mise tool has an entry in `bin/tools.py` |
| `ruff`, `ruff-format` | Python lint and format check |
