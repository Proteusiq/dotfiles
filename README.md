# dotfiles

Dotfiles for 🦀(MLOps) and 🐲(Data Scientist): A Spin-Off [Sara Pope's](https://github.com/gretzky/dotfiles).

<img width="1333" alt="image" src="https://github.com/Proteusiq/dotfiles/assets/14926709/9046ac0a-33d1-4d03-948f-dc6e293e06b8">


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

-   [pyenv](https://github.com/pyenv/pyenv) sets the global Python version to latest stable version
-   [n](https://github.com/tj/n) sets the global Node version to LTS

<details><summary>Brewfile Tools Definitions</summary>

```sh
# Command Line Tools
# Utilities and tools to enhance the command line interface experience
"ack" # A tool like grep, optimized for programmers
"applesimutils" # Apple Simulator Utilities
"autoenv" # Automatically source environment variable
"azure-cli" # Microsoft Azure Command Line Interface
"bat" # A cat clone with syntax highlighting and Git integration
"bpytop" # Resource monitor that shows usage and stats
"binutils" # GNU binary tools for native development
"chruby" # Changes the current Ruby
"coreutils" # GNU File, Shell, and Text utilities
"diffutils" # File comparison utilities
"direnv" # Environment switcher for the shell
"eza" # A better ls and tree
"ffmpeg" # A complete, cross-platform solution to record, convert and stream audio and video
"findutils" # GNU `find`, `locate`, `updatedb`, and `xargs` commands
"fzf" # Command-line fuzzy finder
"gawk" # GNU awk utility
"git" # Distributed revision control system
"gnu-sed" # GNU implementation of the famous stream editor
"gnu-tar" # GNU version of the tar archiving utility
"gnu-time" # GNU implementation of the time utility
"gnu-which" # GNU implementation of the 'which' utility to find path of executables
"gnupg" # GNU Pretty Good Privacy (PGP) package
"go" # The Go programming language
"grep" # GNU grep, egrep and fgrep
"gzip" # GNU compression utility
"hyperfine" # A command-line benchmarking tool
"jq" # Lightweight and flexible command-line JSON processor
"moreutils" # Collection of tools that nobody wrote when UNIX was young
"ncdu" # NCurses Disk Usage
"neovim" # Ambitious Vim-fork focused on extensibility and agility
"node" # Platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications
"ollama" # Running Large Language Models offline
"pixi" # Fast than mamba: Drop in replacer of Pyenv + Poetry
"poetry" # Python package management and dependency resolution
"python" # Interpreted, interactive, object-oriented programming language
"pyenv" # Python version management
"rename" # Perl-powered file rename script with many helpful built-ins
"rsync" # Utility that provides fast incremental file transfer
"rust" # Safe, concurrent, practical language
"screen" # GNU screen, terminal multiplexer
"starship" # Cross-shell prompt for astronauts
"stow" # Manage installation of multiple softwares in the same directory structure
"terraform" # Tool for building, changing, and versioning infrastructure safely and efficiently
"tmux" # Terminal multiplexer
"vim" # Highly configurable text editor built to enable efficient text editing
"watchman" # Watch files and take action when they change
"wget" # Internet file retriever
"yarn" # JavaScript package manager
"zlib" # General-purpose lossless data-compression library
"zplug" # A next-generation plugin manager for zsh
"zsh" # UNIX shell (command interpreter)
"zoxide" # A faster way to navigate your filesystem

# Custom Taps (Specialized tools)
"koekeishiya/formulae/skhd" # Simple hotkey daemon for macOS
"koekeishiya/formulae/yabai" # A tiling window manager for macOS

# GUI Applications (Casks)
# Various applications installed through Homebrew Cask
"1password" # Password manager
"alacritty" # GPU-accelerated terminal emulator
"docker" # Platform to develop, ship, and run applications
````

</details>

### Customization

####  Git
- Be sure to update the user name/email values in the global [gitconfig](./git/.gitconfig)
#### Color Schemes

- Alacritty color scheme is [Snazzy](https://github.com/sindresorhus/terminal-snazzy)
- VSCode/Vim color scheme is [Ayu](https://github.com/dempfi/ayu)

### After First Installation, Sync dotfile with GitHub
Configure GitHub to usee SSH [Configure](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) + [Setup](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

Change dotfile remote url to use ssh: 
`git remote set-url origin git@github.com:Proteusiq/dotfiles.git`

## MacOS settings
> Steps of updating or changing  `macos/.macos` to fit your preferences
Example changing Clock to Analog:
```sh
# step 1: generate before change default settings
defaults read > before
# step 2: make changes on the UI. For example change clock appearance settings and go back to terminal
defaults read > after
# step 3: used `diff before after` or VSCode to change the difference. On VSCode right click `before` > Select for Compare, right click `after`> Compare with Selected
# find the changes that highlights the UI chnages
```
![diff](https://github.com/Proteusiq/dotfiles/assets/14926709/e897e34a-5d7a-4865-8782-7bef847e4e0b)


Translate the changes to .macos
```python
# Prayson's Clock Preferences Dock
defaults write com.apple.menuextra.clock IsAnalog -int 0
defaults write com.apple.menuextra.clock ShowAMPM  -int 1
defaults write com.apple.menuextra.clock ShowDate -int 0
defaults write com.apple.menuextra.clock ShowDayOfWeek  -int 0
defaults write com.apple.menuextra.clock ShowSeconds  -int 0
```


## Acknowledgements

-   [Sara Pope's](https://github.com/gretzky/dotfiles) and all before her.
