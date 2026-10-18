# Installation

`install.sh` installs and maintains the whole setup. The shell alias `update` runs it:

```bash
alias update='"$DOTFILES_DIR/install.sh"'
```

If the alias is not available yet, run `~/dotfiles/install.sh` directly.

## Steps

A full run executes these steps in order. Use the names with `--only` and `--skip`.

| Step | What it does |
|------|--------------|
| `dirs` | Creates `~/Codes`, `~/Documents/Screenshots` and the log directory. |
| `xcode` | Installs the Xcode Command Line Tools if `xcode-select` finds none. |
| `brew` | Installs Homebrew if it is missing. Trusts only the taps declared with a `tap` line in the `Brewfile`. Runs `brew bundle`, sets the Rust toolchain (`rustup default stable`), runs a second pass for the `cargo` and `uv` entries, then checks with `brew bundle check --no-upgrade`. |
| `stow` | Links the stow packages into `$HOME` with `stow --no-folding --restow`. Removes stale links and backs up conflicting files first. |
| `runtimes` | Installs Python 3.14 with uv and links `python`/`python3` in `~/.local/bin` to it (version in `uv/.config/uv/.python-version`), runs `mise install` (Node LTS, Go, Bun, pnpm, usage, pi) and makes sure a Rust toolchain is set. |
| `venv` | Creates `~/.virtualenvs/neovim` with `pynvim`, the Python provider for Neovim. |
| `tmux` | Clones tpm into `~/.tmux/plugins/tpm` and installs the plugins. |
| `yazi` | Clones `yazi-rs/flavors` into `~/.config/yazi/flavors`. |
| `utils` | Runs `git lfs install`. Installs what is missing: the `dlvhdr/gh-dash` gh extension, Bicep (`az bicep install`), Herdr, and Unsloth Studio (into `~/unsloth_studio`). Creates `~/.rgrc`. Links each `bin/*.py` script to `~/.local/bin/<name>`, so `bin/aliases.py` becomes the `aliases` command. |
| `macos` | Enables Touch ID for `sudo` in `/etc/pam.d/sudo_local`, with `pam_reattach` so it also works inside tmux. Saves screenshots to `~/Documents/Screenshots`. |
| `cleanup` | Runs `brew cleanup` and `brew autoremove`. Warns about packages that are installed but not in the `Brewfile`. It never removes them. |

::: info Security
`sudo` stays active only while `brew bundle` runs. The installer then drops it with `sudo -k`. Remote installers (Herdr, Unsloth Studio) are downloaded to a temporary file and run without `sudo`.
:::

## Common Commands

```bash
update                     # Full run
update -v                  # Show command output with timestamps
update -vv                 # Also show each executed command
update --dry-run -v        # Show what would run; change nothing
update --only stow         # Run one step
update --skip "venv brew"  # Skip one or more steps
update --list              # List the steps
```

For every option, see the [CLI Reference](/reference/cli).

### Dry Run

`--dry-run` makes no changes. Remote installers are skipped. Add `-v` to see what would run: without it, the dry-run messages are hidden. CI runs `install.sh --dry-run -v` for pushes to `main` and for pull requests.

### Selecting Steps

- `--only <step>` runs exactly one step. An unknown name stops with an error and the list of steps.
- `--skip` takes one step name, or several names in one quoted argument: `--skip "venv brew"`.

## Failures and Logs

A failed step does not stop the run. The installer logs the error, continues with the next step, and at the end lists the failed steps and commands and exits with a non-zero code.

The log file is:

```
$XDG_STATE_HOME/dotfiles/install.log   # default: ~/.local/state/dotfiles/install.log
```

Each run starts a new log. In the default quiet mode, a spinner shows progress and the output of the installer's commands goes to the log. Set `LOG_FILE` to use another path.

## Backups

`stow` cannot replace a real file with a link. Before it links, the `stow` step:

1. Removes links in `$HOME` and `~/.config` that point into the repository but whose target no longer exists.
2. Moves each conflicting real file to `~/.dotfiles-backup/<timestamp>/`, with the same relative path.

Each move is logged as a warning. Compare the backup with the repository version and keep what you need.

## Health Check

```bash
update --doctor
```

The doctor (`scripts/doctor.sh`) checks:

| Area | Check |
|------|-------|
| Links | `stow` would link every package without conflicts; no stale links into the repository |
| Repository | No uncommitted changes. An installer may have edited a linked file. |
| PATH | `git`, `rsync`, `python3` and `node` do not resolve to the macOS copies in `/usr/bin` or `/bin` |
| Shell startup | An interactive zsh starts in less than 300 ms |
| Configs | `zsh -n` on each zsh file, `ghostty +validate-config`, tmux config parse, `yazi --version`, AeroSpace config at `~/.config/aerospace/aerospace.toml` |
| Brewfile | `brew bundle check` passes; lists packages not declared in the `Brewfile` |
| Git identity | `personal.gitconfig` and `work.gitconfig` exist; the repository has a commit email |
| Runtimes | `mise doctor` and `rustup default` succeed |

Problems make the doctor exit non-zero. Warnings do not.

## Updating Tools

```bash
update --outdated     # Formulae, casks, uv tools and mise runtimes with updates
update --all          # brew upgrade, uv tool upgrade --all, cargo crates, mise upgrade, tmux plugins, Yazi flavors
update <tool>         # One tool; finds it in brew, cask, uv, cargo or mise
update pi             # mise tools also match by command name
update tpm            # tpm, yazi-flavors and herdr are also supported
update --versions uv  # Installed versions: brew, cask, uv, cargo, mise, git, other
update --info bat     # Source, version, description and example
```

## Adding a Tool

1. Declare it in one place:
   - **System tools, apps, Python CLIs and Rust crates:** the `Brewfile`. Use `brew`, `cask`, `uv` or `cargo` lines. A new third-party tap also needs a `tap` line; the installer trusts only the taps listed there.
   - **Language runtimes and npm-based tools:** `mise/.config/mise/config.toml`.
2. Add a catalog entry to `bin/tools.py`, so `tools` and `update --info` know the tool. For a library or helper that needs no entry, add it to `NOT_CATALOGUED` in `scripts/check_catalog.py`.
3. Check the catalog. The `tool-catalog` Git hook runs the same check:
   ```bash
   python3 scripts/check_catalog.py
   ```
4. Install it:
   ```bash
   update --only brew      # Brewfile changes
   update --only runtimes  # mise changes
   ```
