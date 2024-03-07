# dotfiles

Dotfiles for 🦀(MLOps) and 🐲(Data Scientist): A Spin-Off [Sara Pope's](https://github.com/gretzky/dotfiles).

![zsh with starship prompt and colorls](https://user-images.githubusercontent.com/15176096/71632895-ff0d0980-2bde-11ea-966f-65e5d564361f.png)
![vim and tmux](https://user-images.githubusercontent.com/15176096/71633424-2f09dc00-2be2-11ea-9c15-a4f492b7ea68.png)

-   Terminal: [Alacritty](https://github.com/jwilm/alacritty) using zsh w/ [starship prompt](https://starship.rs/) and [eza](https://github.com/eza-community/eza)
-   Window management: [yabai](https://github.com/koekeishiya/yabai)
-   Hotkeys: [skhd](https://github.com/koekeishiya/skhd)
-   Vim: [neovim](https://neovim.io/) with [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins
-   Tools: [tmux](https://github.com/tmux/tmux), [zoxide](https://github.com/ajeetdsouza/zoxide), [fzf](https://github.com/junegunn/fzf)

## Installation

**Before you get started** make sure you give full disk access permission to your terminal (for writing macos defaults). `System Preferences -> Privacy -> Full Disk Access`.

Add [+] Utilities > Terminal


To install:

`curl -L https://bit.ly/42YwVdi | sh`

This expands to [run.sh](https://github.com/proteusiq/dotfiles/blob/master/run.sh) which will fetch this repo and run the install script.

## File overview

-   Configs for the following tools:
    -   git
    -   [Alacritty](./alacritty)
    -   [fzf](./fzf)
    -   [neovim](./nvim)
    -   [skhd](./skhd)
    -   [starship](./starship)
    -   [tmux](./tmux)
    -   [VSCode](./vscode)
    -   [yabai](./yabai)
-   Shell environment configs:
    -   [Antigen](https://github.com/zsh-users/antigen) for zsh plugin management
    -   [`.zshrc`](./zsh/.zshrc)
    -   [`.zlogin.sh`](./zsh/.zlogin.sh)
    -   [`.zshenv.sh`](./zsh/.zshenv.sh)
    -   [`.aliases`](./zsh/.aliases)
    -   [`.exports`](./zsh/.exports)
-   [`Brewfile`](./Brewfile) - contains all homebrew packages, casks, and mac appstore apps
-   [VSCode settings](./vscode/settings.json)

The install script will also setup Python and Node versions/environments:

-   [pyenv](https://github.com/pyenv/pyenv) sets the global Python version to 3.12
-   [n](https://github.com/tj/n) sets the global Node version to LTS

<details><summary>Tools Definitions</summary>
# Command Line Tools
# Utilities and tools to enhance the command line interface experience
brew "ack" # A tool like grep, optimized for programmers
brew "applesimutils" # Apple Simulator Utilities
brew "azure-cli" # Microsoft Azure Command Line Interface
brew "bat" # A cat clone with syntax highlighting and Git integration
brew "bpytop" # Resource monitor that shows usage and stats
brew "binutils" # GNU binary tools for native development
brew "chruby" # Changes the current Ruby
brew "coreutils" # GNU File, Shell, and Text utilities
brew "diffutils" # File comparison utilities
brew "direnv" # Environment switcher for the shell
brew "eza" # Command line utility (placeholder, as not a standard tool)
brew "ffmpeg" # A complete, cross-platform solution to record, convert and stream audio and video
brew "findutils" # GNU `find`, `locate`, `updatedb`, and `xargs` commands
brew "fzf" # Command-line fuzzy finder
brew "gawk" # GNU awk utility
brew "git" # Distributed revision control system
brew "gnu-sed" # GNU implementation of the famous stream editor
brew "gnu-tar" # GNU version of the tar archiving utility
brew "gnu-time" # GNU implementation of the time utility
brew "gnu-which" # GNU implementation of the 'which' utility to find path of executables
brew "gnupg" # GNU Pretty Good Privacy (PGP) package
brew "go" # The Go programming language
brew "grep" # GNU grep, egrep and fgrep
brew "gzip" # GNU compression utility
brew "hyperfine" # A command-line benchmarking tool
brew "jq" # Lightweight and flexible command-line JSON processor
brew "moreutils" # Collection of tools that nobody wrote when UNIX was young
brew "ncdu" # NCurses Disk Usage
brew "neovim" # Ambitious Vim-fork focused on extensibility and agility
brew "node" # Platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications
brew "ollama" # Running Large Language Models offline
brew "pixi" # Fast than mamba: Drop in replacer of Pyenv + Poetry
brew "poetry" # Python package management and dependency resolution
brew "python" # Interpreted, interactive, object-oriented programming language
brew "pyenv" # Python version management
brew "rename" # Perl-powered file rename script with many helpful built-ins
brew "rsync" # Utility that provides fast incremental file transfer
brew "rust" # Safe, concurrent, practical language
brew "screen" # GNU screen, terminal multiplexer
brew "starship" # Cross-shell prompt for astronauts
brew "stow" # Manage installation of multiple softwares in the same directory structure
brew "terraform" # Tool for building, changing, and versioning infrastructure safely and efficiently
brew "tmux" # Terminal multiplexer
brew "tree" # Display directories as trees (with optional color/HTML output)
brew "vim" # Highly configurable text editor built to enable efficient text editing
brew "watchman" # Watch files and take action when they change
brew "wget" # Internet file retriever
brew "yarn" # JavaScript package manager
brew "zlib" # General-purpose lossless data-compression library
brew "zplug" # A next-generation plugin manager for zsh
brew "zsh" # UNIX shell (command interpreter)
brew "zoxide" # A faster way to navigate your filesystem

# Custom Taps (Specialized tools)
brew "koekeishiya/formulae/skhd" # Simple hotkey daemon for macOS
brew "koekeishiya/formulae/yabai" # A tiling window manager for macOS

# GUI Applications (Casks)
# Various applications installed through Homebrew Cask
cask "1password" # Password manager
cask "airpass" # Defeat time-restricted WiFi networks
cask "alacritty" # GPU-accelerated terminal emulator
cask "alfred" # Productivity application for macOS
cask "docker" # Platform to develop, ship, and run applications
cask "dozer" # Hide status bar icons to give your
<details>

### Customization

####  Git
- Be sure to update the user name/email values in the global [gitconfig](./git/.gitconfig)
#### Color Schemes

- Alacritty color scheme is [Snazzy](https://github.com/sindresorhus/terminal-snazzy)
- VSCode/Vim color scheme is [Ayu](https://github.com/dempfi/ayu)

### After Connect and Sync
Configure SSH [Configure](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) + [Setup](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

Change dotfile remote url to use ssh: 
`git remote set-url origin git@github.com:Proteusiq/dotfiles.git`

# TODO
Add wirefuard

## Acknowledgements

-   [Sara Pope's](https://github.com/gretzky/dotfiles)
