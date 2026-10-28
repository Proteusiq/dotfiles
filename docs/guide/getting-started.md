# Getting Started

This guide sets up a new Mac with these dotfiles and lists what to do after the first run.

## Prerequisites

- macOS on Apple Silicon or Intel. The installer stops on other systems.
- An administrator account. Some casks and the Touch ID setup use `sudo`.
- An internet connection.

You do not need Git or Homebrew first. The bootstrap handles both.

## Install

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Proteusiq/dotfiles/main/run.sh)"
```

`run.sh` does one of three things, then runs `install.sh`:

| Situation | Action |
|-----------|--------|
| `~/dotfiles` is a git clone | `git pull --ff-only` |
| `~/dotfiles` exists but is not a clone | Uses it as it is |
| `~/dotfiles` does not exist | Clones the repository, or downloads a zip of `main` if Git is not available yet |

::: tip
Without the Xcode Command Line Tools, `/usr/bin/git` is only a stub, so `run.sh` downloads a zip. That copy is not a git repository. To get one later, clone the repository manually.
:::

To clone manually:

```bash
git clone https://github.com/Proteusiq/dotfiles ~/dotfiles && ~/dotfiles/install.sh
```

## What Happens

The installer runs these steps in order. A failed step does not stop the run.

1. **dirs** creates `~/Codes`, `~/Documents/Screenshots` and the log directory.
2. **xcode** installs the Xcode Command Line Tools if they are missing.
3. **brew** installs Homebrew if it is missing, then everything in the `Brewfile`.
4. **stow** links the configuration files into your home directory.
5. **runtimes** installs Node, Go, Bun and other tools with mise, and the stable Rust toolchain with rustup.
6. **venv** creates the Python environment that Neovim uses (`~/.virtualenvs/neovim`).
7. **tmux** installs the tmux plugin manager (tpm) and the plugins.
8. **yazi** installs the Yazi flavors (themes).
9. **utils** installs extras: Git LFS, gh-dash, Bicep, Herdr and the `aliases` and `tools` commands.
10. **macos** enables Touch ID for `sudo` when the Mac has a sensor, and saves screenshots to `~/Documents/Screenshots`.
11. **cleanup** runs Homebrew cleanup and lists packages that are installed but not in the `Brewfile`.

See [Installation](/guide/installation) for details on each step.

## First-Run Checklist

Open a new Ghostty window. The shell starts tmux for you.

1. **Create your Git identity files.** No identity is tracked in the repository, and Git does not guess one. Create `~/.config/git/personal.gitconfig` and, if you need it, `~/.config/git/work.gitconfig`. See [Git](/guide/git#identity-by-remote).
2. **Sign in to GitHub.** HTTPS access to GitHub uses `gh` as the credential helper:
   ```bash
   gh auth login
   ```
3. **Put machine-local shell settings in `~/.zshrc.local`.** This file is not tracked. When a third-party installer wants to append lines to `~/.zshrc`, move them here.
4. **Enable the Git hooks** if you plan to change the repository:
   ```bash
   cd ~/dotfiles && prek install
   ```
5. **Run the health check:**
   ```bash
   update --doctor
   ```
6. **Open OrbStack once** so that it can finish its setup and start the Docker engine. If you prefer colima, run `colima start` instead.

## Next Steps

- [Installation](/guide/installation): the `update` command, steps, logs and backups
- [Architecture](/guide/architecture): repository layout and load order
- [Shell](/guide/shell): Zsh, plugins, aliases and integrations
- [Tools Reference](/reference/tools): everything that is installed
