---
layout: home

hero:
  name: "Fox's Dotfiles"
  text: "Modern macOS Dev Environment"
  tagline: A terminal-first macOS setup, installed and maintained with one command
  actions:
    - theme: brand
      text: Get Started
      link: /guide/getting-started
    - theme: alt
      text: View on GitHub
      link: https://github.com/Proteusiq/dotfiles

features:
  - icon:
      src: /icons/terminal.svg
    title: One Command Setup
    details: One installer for packages, runtimes and links. Run it again at any time to update the setup. Check the result with update --doctor.
    link: /guide/installation
    linkText: Learn more
  - icon:
      src: /icons/zap.svg
    title: Terminal Stack
    details: Ghostty, tmux, sesh and Starship. Ghostty starts tmux automatically. sesh switches between projects.
    link: /guide/terminal
    linkText: Terminal setup
  - icon:
      src: /icons/palette.svg
    title: One Theme
    details: Catppuccin Mocha in Ghostty, tmux, fzf, delta, Yazi and Neovim.
    link: /guide/shell
    linkText: Shell config
  - icon:
      src: /icons/wrench.svg
    title: Modern CLI Tools
    details: bat, eza, fd, ripgrep, zoxide, fzf, atuin and more. All declared in one Brewfile.
    link: /reference/tools
    linkText: Browse tools
  - icon:
      src: /icons/code.svg
    title: Neovim + LazyVim
    details: LazyVim with language extras for Python, Go, Rust, TypeScript, SQL, Terraform and more, plus a small set of custom plugins.
    link: /guide/neovim
    linkText: Neovim guide
  - icon:
      src: /icons/package.svg
    title: Languages
    details: uv for Python, mise for Node, Go and Bun, rustup for Rust.
    link: /reference/tools
    linkText: View tools
---

<style>
:root {
  --vp-home-hero-name-color: transparent;
  --vp-home-hero-name-background: -webkit-linear-gradient(120deg, #f97316 30%, #fbbf24);
}
</style>

## Quick Start

Bootstrap a new Mac with one command:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Proteusiq/dotfiles/main/run.sh)"
```

Or clone the repository and run the installer yourself:

```bash
git clone https://github.com/Proteusiq/dotfiles ~/dotfiles && ~/dotfiles/install.sh
```

::: tip
`run.sh` is short. Read it before you run it.
:::

## What's Included

<div class="tool-grid">

| Category | Tools |
|----------|-------|
| **Terminal** | Ghostty, tmux, sesh, Starship |
| **Editor** | Neovim + LazyVim |
| **Shell** | Zsh + antidote, fzf, zoxide, atuin |
| **Files** | Yazi, fzf, fd, ripgrep |
| **Git** | lazygit, gh, delta, difftastic |
| **Languages** | Python (uv), Node/Go/Bun (mise), Rust (rustup) |
| **Containers** | OrbStack or colima, Docker CLI |

</div>

See the [Tools Reference](/reference/tools) for the full list.

## The `update` Command

After installation, the `update` alias runs the installer:

```bash
update                    # Full install; safe to run again
update --dry-run -v       # Show what would run, change nothing
update --doctor           # Check links, PATH, configs and the Brewfile
update --outdated         # Show packages with updates available
update --all              # Update brew, uv, cargo, mise and git-cloned tools
update bat                # Update one tool
update --only brew        # Run one step
update --skip "venv brew" # Skip steps
update --versions         # Show installed versions
```

See [Installation](/guide/installation) and the [CLI Reference](/reference/cli).
