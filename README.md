![dotfiles banner](https://github.com/Proteusiq/dotfiles/assets/14926709/9e3c4c60-43cd-4e47-9711-49eeb1078ae4)

# dotfiles

macOS dotfiles for Python, Rust and data work: one Brewfile, one installer, configs linked with GNU Stow.

- Documentation: <https://proteusiq.github.io/dotfiles/>
- Principles: [MANIFESTO.md](./MANIFESTO.md)
- Development conventions: [AGENTS.md](./AGENTS.md)
- Repository knowledge for agents: [SKILL.md](./SKILL.md)

![Terminal Screenshot](https://github.com/Proteusiq/dotfiles/assets/14926709/b5374cdb-753c-4559-ad8e-920d9653de34)

## Quick start

Read [run.sh](./run.sh) first. It is short. Then run:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Proteusiq/dotfiles/main/run.sh)"
```

`run.sh` clones the repository to `~/dotfiles` (or pulls it if it exists), then runs `install.sh`.

Manual alternative:

```bash
git clone https://github.com/Proteusiq/dotfiles ~/dotfiles && ~/dotfiles/install.sh
```

The installer is idempotent. Run it again at any time. Before it links the configs, it moves conflicting files to `~/.dotfiles-backup/<timestamp>/`. If a step fails, the run continues, prints a summary of the failures and exits non-zero. The log is in `~/.local/state/dotfiles/install.log` (`$XDG_STATE_HOME/dotfiles/install.log`).

## After install

These files are machine-local. They are not in the repository.

1. **Git identity.** The tracked git config has no name or email (`user.useConfigOnly = true`). Git selects an identity from the remote URL of the repository. Create one file per identity in `~/.config/git/`:

   ```ini
   # ~/.config/git/personal.gitconfig  (remotes under github.com/Proteusiq)
   [user]
       name = Your Name
       email = you@example.com
       signingkey = ~/.ssh/id_ed25519_personal_signing.pub
   ```

   Create `~/.config/git/work.gitconfig` with the same shape for remotes under `github.com/Norlys-A-S`. Put machine overrides in `~/.config/git/local.gitconfig`; git includes it last. Commits and tags are signed with SSH keys. See [Git guide](https://proteusiq.github.io/dotfiles/guide/git) for key setup.

2. **Shell lines for this machine only.** Put them in `~/.zshrc.local` (interactive) or `~/.zprofile.local` (login). Some installers append lines to `~/.zshrc`. That file is tracked, so move those lines to `~/.zshrc.local`.

3. **Git hooks.** In the repository clone, run once:

   ```bash
   prek install
   ```

## Daily commands

`update` is an alias for `$DOTFILES_DIR/install.sh`. If the alias is not available, run `~/dotfiles/install.sh`.

| Command | What it does |
|---------|--------------|
| `update` | Run all install steps (quiet) |
| `update --doctor` | Check links, PATH order, configs, Brewfile, git identity, runtimes |
| `update --outdated` | Show packages with available updates |
| `update --all` | Upgrade everything: brew, uv, cargo, mise, tmux plugins, Yazi flavors |
| `update <tool>` | Upgrade one tool. The package manager is detected (brew, cask, uv, cargo, mise, herdr, tpm, yazi-flavors) |
| `update --info <tool>` | Show source, version, description and example of a tool |
| `update --versions [group]` | Show installed versions. Groups: `brew`, `cask`, `uv`, `cargo`, `mise`, `git`, `other` |
| `update --only <step>` | Run one step |
| `update --skip "<step> <step>"` | Skip one or more steps |
| `update --list` | List the steps |
| `update --dry-run` | Show what would run, change nothing |
| `update -v` / `update -vv` | Detailed output / also show each command |
| `aliases` | Browse shell aliases and functions (`aliases -s git`, `aliases -d gcl`, `aliases --tui`) |
| `tools` | Browse the tool catalog (`tools -s vc`, `tools -d lazygit`, `tools --tui`) |

Steps, in order: `dirs`, `xcode`, `brew`, `stow`, `runtimes`, `venv`, `tmux`, `yazi`, `utils`, `macos`, `cleanup`.

| Step | What it does |
|------|--------------|
| `dirs` | Creates `~/Codes`, `~/Documents/Screenshots` and the log directory |
| `xcode` | Installs the Xcode Command Line Tools |
| `brew` | Installs Homebrew if missing, trusts only the taps in the Brewfile, runs `brew bundle` (formulae, casks, uv tools, cargo crates) |
| `stow` | Links the configs into `$HOME`, backs up conflicts, removes stale links |
| `runtimes` | Python 3.14 via uv (default `python`/`python3`), `mise install`, `rustup default stable` |
| `venv` | Creates `~/.virtualenvs/neovim` with `pynvim` |
| `tmux` | Installs tpm and the tmux plugins |
| `yazi` | Clones the Yazi flavors into `~/.config/yazi/flavors` |
| `utils` | `git lfs install`, gh extension `dlvhdr/gh-dash`, `az bicep install`, Herdr, Unsloth Studio, links `bin/*.py` to `~/.local/bin` |
| `macos` | Touch ID for sudo (also in tmux), screenshots to `~/Documents/Screenshots` |
| `cleanup` | `brew cleanup` and `brew autoremove`, then lists packages installed but not in the Brewfile (removes nothing) |

## What's inside

Ghostty, tmux, Neovim, fzf, delta and Yazi use the Catppuccin theme.

| Area | Main tools |
|------|------------|
| Shell | zsh, antidote, starship, atuin, zoxide, fzf, pay-respects (`f`), GNU coreutils/findutils/sed/tar/grep/awk |
| Terminal | Ghostty, tmux + tpm, sesh, Yazi, broot, AeroSpace |
| Editor | Neovim with LazyVim, glow, dawn |
| Git | git, gh + gh-dash, delta, difftastic, lazygit, serie, git-lfs, git-filter-repo |
| Languages and runtimes | uv (Python 3.14), pixi, mise (Node LTS, Go, Bun, pnpm), rustup (Rust) |
| Containers and cloud | OrbStack, colima, docker CLI + compose + buildx, lazydocker, OpenTofu (`tofu`), Azure CLI + Bicep, azd, Temporal CLI |
| Data | DuckDB, harlequin, tabiew, dbt Cloud CLI, Snowflake CLI (`snow`), sqlfluff, jq, yq, mongosh |
| AI | OpenCode, pi, Ollama, llama.cpp, hf, Unsloth Studio |
| Quality | prek, gitleaks, shellcheck, shfmt, stylua, actionlint, ruff, ty, biome, bacon |

The full list with descriptions is in the [Brewfile](./Brewfile), in `tools`, and in [Tools.md](./Tools.md).

## Repository layout

Each top-level directory with a config is a Stow package. Stow links its contents into `$HOME` with `--no-folding`, so it links files, not directories.

```
dotfiles/
├── aerospace/    → ~/.config/aerospace/aerospace.toml
├── atuin/        → ~/.config/atuin/config.toml
├── ghostty/      → ~/.config/ghostty/config
├── git/          → ~/.config/git/config, ~/.config/git/ignore
├── mise/         → ~/.config/mise/config.toml
├── nvim/         → ~/.config/nvim/
├── sesh/         → ~/.config/sesh/sesh.toml
├── starship/     → ~/.config/starship.toml
├── tmux/         → ~/.tmux.conf
├── uv/           → ~/.config/uv/.python-version (default Python: 3.14)
├── yazi/         → ~/.config/yazi/
├── zsh/          → ~/.zshenv, ~/.zprofile, ~/.zshrc, ~/.config/zsh/
├── bin/          aliases.py, tools.py (linked to ~/.local/bin/aliases and ~/.local/bin/tools)
├── scripts/      installer modules, doctor.sh, check_catalog.py (see scripts/README.md)
├── docs/         documentation site (VitePress)
├── Brewfile      system tools: formulae, casks, uv tools, cargo crates
├── install.sh    the installer (the update command)
├── run.sh        bootstrap: clone, then run install.sh
└── .pre-commit-config.yaml   git hooks, run by prek
```

Shell startup order:

| File | Read by | Contents |
|------|---------|----------|
| `~/.zshenv` | every zsh | XDG variables, `DOTFILES_DIR`, editor and pager, PATH |
| `~/.zprofile` | login shells | Rebuilds PATH after macOS `path_helper`, sources `~/.zprofile.local` |
| `~/.zshrc` | interactive shells | tmux autostart in Ghostty, GNU tools, history, plugins, completions, aliases, functions, sources `~/.zshrc.local` |

## Single sources of truth

| Knowledge | File |
|-----------|------|
| System tools (Homebrew formulae, casks, uv tools, cargo crates) | [Brewfile](./Brewfile) |
| Default Python version | [uv/.config/uv/.python-version](./uv/.config/uv/.python-version) |
| Language runtimes and npm-based CLIs | [mise/.config/mise/config.toml](./mise/.config/mise/config.toml) |
| Shell aliases | [zsh/.config/zsh/aliases.zsh](./zsh/.config/zsh/aliases.zsh) |
| Shell functions | [zsh/.config/zsh/functions.zsh](./zsh/.config/zsh/functions.zsh) |
| zsh plugins | [zsh/.config/zsh/plugins.txt](./zsh/.config/zsh/plugins.txt) |
| PATH | [zsh/.zshenv](./zsh/.zshenv) (`dotfiles_path`) |
| Neovim LazyVim extras | [nvim/.config/nvim/lazyvim.json](./nvim/.config/nvim/lazyvim.json) |
| Tool catalog (`tools`, `update --info`) | [bin/tools.py](./bin/tools.py), checked against the Brewfile and mise config by [scripts/check_catalog.py](./scripts/check_catalog.py) |

The `aliases` command reads `aliases.zsh` and `functions.zsh` directly, so it always matches the shell.

## Quality checks

The git hooks in [.pre-commit-config.yaml](./.pre-commit-config.yaml) run with prek: whitespace and file checks, gitleaks, shellcheck, shfmt, `zsh -n`, stylua, actionlint, Brewfile parse, tool catalog, ruff. Run all of them with `prek run --all-files`.

CI ([.github/workflows/lint.yml](./.github/workflows/lint.yml)) runs the same hooks, scans the full history with gitleaks, runs `install.sh --dry-run -v`, links every package into an empty home, and starts zsh in an empty home.

## More documentation

- [Installation](https://proteusiq.github.io/dotfiles/guide/installation)
- [Shell](https://proteusiq.github.io/dotfiles/guide/shell)
- [Git](https://proteusiq.github.io/dotfiles/guide/git)
- [Neovim](https://proteusiq.github.io/dotfiles/guide/neovim)
- [Terminal](https://proteusiq.github.io/dotfiles/guide/terminal)
- [Keybindings](https://proteusiq.github.io/dotfiles/reference/keybindings)
- [CLI commands](https://proteusiq.github.io/dotfiles/reference/cli)
- [Tools.md](./Tools.md): long-form notes on each tool
- [scripts/README.md](./scripts/README.md): installer internals
- [prompts.md](./prompts.md): prompting guide

## License

MIT. See [LICENSE](./LICENSE).

Inspired by [Sara Pope's dotfiles](https://github.com/gretzky/dotfiles).
