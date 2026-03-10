---
layout: home

hero:
  name: "Fox's Dotfiles"
  text: "Modern macOS Dev Environment"
  tagline: A thoughtfully crafted terminal-first development setup with 100+ curated tools
  image:
    src: /fox.svg
    alt: Fox Dotfiles
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
    details: Run a single command to install everything. Idempotent and safe to re-run anytime.
    link: /guide/installation
    linkText: Learn more
  - icon:
      src: /icons/zap.svg
    title: Blazing Fast Terminal
    details: Ghostty + tmux + Starship prompt. GPU-accelerated with sub-millisecond latency.
    link: /guide/terminal
    linkText: Terminal setup
  - icon:
      src: /icons/palette.svg
    title: Beautiful by Default
    details: Catppuccin Mocha theme everywhere. Consistent colors across terminal, editor, and tools.
    link: /guide/shell
    linkText: Shell config
  - icon:
      src: /icons/wrench.svg
    title: Modern CLI Tools
    details: bat, eza, fd, ripgrep, zoxide, and more. Classic commands reimagined in Rust.
    link: /reference/tools
    linkText: Browse tools
  - icon:
      src: /icons/code.svg
    title: Neovim + LazyVim
    details: Full IDE experience with LSP, completions, debugging, and 23+ carefully configured plugins.
    link: /guide/neovim
    linkText: Neovim guide
  - icon:
      src: /icons/package.svg
    title: Python & Rust Ready
    details: UV for Python, Cargo for Rust. Fast package managers with virtual environment support.
    link: /reference/tools#languages--runtimes
    linkText: View languages
---

<style>
:root {
  --vp-home-hero-name-color: transparent;
  --vp-home-hero-name-background: -webkit-linear-gradient(120deg, #f97316 30%, #fbbf24);
}
</style>

## Quick Start

```bash
# Clone the repository
git clone https://github.com/Proteusiq/dotfiles.git ~/dotfiles

# Run the installer
cd ~/dotfiles && ./install.sh
```

## What's Included

<div class="tool-grid">

| Category | Tools |
|----------|-------|
| **Terminal** | Ghostty, tmux, Starship, sesh |
| **Editor** | Neovim + LazyVim |
| **Shell** | Zsh + Antigen |
| **Files** | Yazi, fzf, fd, ripgrep |
| **Git** | lazygit, gh CLI, git-delta |
| **Languages** | Python (uv), Rust, Go, Bun |

</div>

## The `update` Command

After installation, use the `update` command to manage your setup:

```bash
update                    # Full install (idempotent)
update --versions         # Show installed versions
update --outdated         # Check for updates
update --only brew        # Run specific function
update --skip "venv brew" # Skip functions
update -v                 # Verbose output
```
