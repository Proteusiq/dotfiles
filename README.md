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

The install script will also setup Python, Node and Bun versions/environments:

-   [rye](https://github.com/astral-sh/rye) sets the global Python version to latest stable version
-   [n](https://github.com/tj/n) sets the global Node version to LTS
-   [bun](https://bun.sh/)  all-in-one toolkit for JavaScript and TypeScript apps

<details><summary>Brewfile Tools Definitions</summary>

```sh
# Command Line Tools
# Utilities and tools to enhance the command line interface experience
"ack" # A tool like grep, optimized for programmers
"aldente" # Battery life 
"applesimutils" # Apple Simulator Utilities
"alttab" # Better preview app switcher 
"autoenv" # Automatically source environment variable
"azure-cli" # Microsoft Azure Command Line Interface
"bat" # A cat clone with syntax highlighting and Git integration
"bpytop" # Resource monitor that shows usage and stats
"binutils" # GNU binary tools for native development
"chruby" # Changes the current Ruby
"cleanshot" # Better screen capture
"coreutils" # GNU File, Shell, and Text utilities
"diffutils" # File comparison utilities
"direnv" # Environment switcher for the shell
"eza" # A better ls and tree
"fd" # A simple, fast and user-friendly alternative to 'find'
"ffmpeg" # A complete, cross-platform solution to record, convert and stream audio and video
"findutils" # GNU `find`, `locate`, `updatedb`, and `xargs` commands
"fzf" # Command-line fuzzy finder
"gawk" # GNU awk utility
"git" # Distributed revision control system
"git-lfs" # Git Large Files Storage
"gnu-sed" # GNU implementation of the famous stream editor
"gnu-tar" # GNU version of the tar archiving utility
"gnu-time" # GNU implementation of the time utility
"gnu-which" # GNU implementation of the 'which' utility to find path of executables
"gnupg" # GNU Pretty Good Privacy (PGP) package
"go" # The Go programming language
"grep" # GNU grep, egrep and fgrep
"gum" # Glamorous shell scripts
"gzip" # GNU compression utility
"hiddenbar" # Hides unpopular tab icons
"hyperfine" # A command-line benchmarking tool
"jq" # Lightweight and flexible command-line JSON processor
"lazygit" # The lazier way to manage everything git
"lazydocker" # The lazier way to manage everything docker
"llm" # Running LLM as CLI
"moreutils" # Collection of tools that nobody wrote when UNIX was young
"ncdu" # NCurses Disk Usage
"neovim" # Ambitious Vim-fork focused on extensibility and agility
"node" # Platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications
"ollama" # Running Large Language Models offline
"pixi" # Fast than mamba: Drop in replacer of Pyenv + Poetry for conda universe
"python" # Interpreted, interactive, object-oriented programming language
"raycast" # A better spotlight
"rename" # Perl-powered file rename script with many helpful built-ins
"ripgrep" # Recursively searches directories for a regex pattern while respecting your gitignore
"rsync" # Utility that provides fast incremental file transfer
"rust" # Safe, concurrent, practical language
"rye" # Python's Cargo
"screen" # GNU screen, terminal multiplexer
"starship" # Cross-shell prompt for astronauts
"stow" # Manage installation of multiple softwares in the same directory structure
"terraform" # Tool for building, changing, and versioning infrastructure safely and efficiently
"thefuck" # Autocorrection with f as alias
"tldr" # Too long I did nor read man
"tmux" # Terminal multiplexer
"uv" # Better drop in pip replacer alias pip='uv pip'
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

### Who You Gonna Call? 👻
[cheat.sh](https://cheat.sh/) - `curl https://cheat.sh/<cli_command>`

## Using Tools
<details><summary>Tips + Tricks</summary>

### Using [tmux](https://tmuxcheatsheet.com/)
```sh
# installl plugins
<leader> + I # prefix is <leader key> which is C-b

<leader> + c # create a new session
<leader> + n # previous session or instead of n, a <NUMBER> to switch to session
<leader> + "Shift + 2" (") or i to split horizontal
<leader> + "Shift + 5"  (%) o - to split vertical
<leader> + Arrows or hjkl # move across panes
<leader> + : # command mode (:rename-window <NAME> :rename-session <NAME> :kill-session -a #kill all session but this one :kill-session -t <NAME or NUM>, :kill-server # kills all session)
<leader> + d # dettach session
tmux ls # list sessions
<leader> + s # list sessions
<leader> + , # rename window
<leader> + & # close window

<leader> + z # min/maximize pane

# custom
<leader> + C-p (P) # => popup window
iexit # alias to kill-session
ikill # alias to kill-server
iswitch # alias to switch-session
ipop # alias for popup window
```

### Using fzf

```sh
# search
fzf # fzf -q .py$ -e
# open files/folders with nvim
nvim # Ctrl + t (C-t)
nvim ** # + TAB

# open files and folder
cd ** # + TAB

# commands things with fzf (kill, unalias, unset, export, ssh)
kill -9 ** # TAB (Next TAB will multiselect and Shift+Tab to deselect)

# looking throw the history
# C-r 
docker # + C-r filter search to 'docker' history
```

## Oh Vim

                                                     
Vim keybindings:

### Modes
| **Key**  | **Explanation**                          |
|----------|------------------------------------------|
| `Esc`    | Command mode                             |
| `i`      | Edit mode                                |
| `V`      | Visual mode                              |
| `a`      | Move cursor forward and enter edit mode  |
| `A`      | Move cursor to the end of the line, enter edit mode |
| `o`      | Add newline below and enter edit mode    |
| `O`      | Add newline above                        |

### Deleting and Changing Text
| **Key**  | **Explanation**                                 |
|----------|-------------------------------------------------|
| `x`      | Delete the character under the cursor           |
| `~`      | Swap the case of the character under the cursor |
| `dd`     | Cut the current line                            |
| `d}`     | Cut until the end of the block                  |
| `cw`     | Change word: delete the word in focus and enter edit mode |
| `dw`     | Delete word                                     |
| `D`      | Delete to the end of the line                   |
| `C`      | Delete to the end of the line and enter edit mode |
| `ct<char>` | Delete up to (but not including) the specified character |
| `.`      | Repeat the last action                          |
| `u`      | Undo                                            |
| `3u`     | Undo last 3 changes                             |
| `Ctrl-r` | Redo                                            |

### Navigation
| **Key**  | **Explanation**                                  |
|----------|--------------------------------------------------|
| `hjkl`   | Move cursor (left, down, up, right)              |
| `20j`    | Go down 20 lines                                 |
| `:20`    | Jump to line 20                                  |
| `w`      | Move to the next word                            |
| `b`      | Move backward one word                           |
| `4b`     | Move backward 4 words                            |
| `0`      | Move to the beginning of the line                |
| `^`      | Move to the first non-blank character of the line|
| `t<char>` | Move just before the specified character        |
| `f<char>` | Move to the specified character                 |
| `%`      | Move to the matching parenthesis, bracket, or brace |
| `gg`     | Go to the top of the file                        |
| `G`      | Go to the bottom of the file                     |
| `{`      | Jump backward by paragraph                       |
| `}`      | Jump forward by paragraph                        |
| `*`      | Jump to the next occurrence of the word under the cursor |
| `z`      | Center the line with the cursor in the middle of the screen |

### Copy and Paste
| **Key**  | **Explanation**                          |
|----------|------------------------------------------|
| `yy`     | Copy (yank) the current line             |
| `P`      | Paste before the cursor                  |
| `p`      | Paste after the cursor                   |

### Search and Help
| **Key**         | **Explanation**                  |
|-----------------|----------------------------------|
| `:h navigation` | Help on navigation               |
| `:h search`     | Help on search commands          |
| `*`             | Search for the word under the cursor |

### File and URL Handling
| **Key**  | **Explanation**                          |
|----------|------------------------------------------|
| `gf`     | Go to file path and open                 |
| `gx`     | Go to URL and open in browser            |

### Recording and Running Commands
| **Key**  | **Explanation**                          |
|----------|------------------------------------------|
| `qa ... q` | Record macro                           |
| `@a`     | Repeat recorded macro                    |
| `13@a`   | Repeat recorded macro 13 times           |
| `Shift+V Shift+G :` | Select to the end of the document |
| `:'<,'> norm A!` | Jump to the end and add `!`      |
| `:norm I` | Jump to the beginning and enter insert mode |

### Browsing in Edit Mode
| **Key**  | **Explanation**                          |
|----------|------------------------------------------|
| `Ctrl-p` / `Ctrl-n` | Browse written variables or names in edit mode |



## Using lazy(neo)vim

```sh
<leader> # Space
<C-w> # window actions
     # w # moves back to Neo-Tree
[b ]b  # option/alt 8 and 9 for [] to navigate buffers(tabs)  
```

</details>

See [RexYuan](https://github.com/RexYuan/Blemishine/tree/main/preferences)'s settings for inspiration and examples

## Acknowledgements

-   [Sara Pope's](https://github.com/gretzky/dotfiles) and all before her.
