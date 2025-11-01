![dotfiles banner](https://github.com/Proteusiq/dotfiles/assets/14926709/9e3c4c60-43cd-4e47-9711-49eeb1078ae4)

# dotfiles

Modern macOS dotfiles for developers focused on Rust 🦀, Python 🐍, and data workflows. Optimized for MLOps and Data Science work.

![Terminal Screenshot](https://github.com/Proteusiq/dotfiles/assets/14926709/b5374cdb-753c-4559-ad8e-920d9653de34)

## Table of Contents

- [Quick Start](#quick-start)
- [What's Included](#whats-included)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Managing Aliases](#managing-aliases)
- [File Structure](#file-structure)
- [Customization](#customization)
- [Usage Tips](#usage-tips)
- [Troubleshooting](#troubleshooting)
- [Acknowledgements](#acknowledgements)

## Quick Start

**One-line install:**
```bash
curl -L https://bit.ly/42YwVdi | sh
```

**Preview before running:**
```bash
curl -LsSf https://bit.ly/42YwVdi | less
```

## What's Included

### Core Tools
- **Terminal**: [Ghostty](https://github.com/ghostty-org/ghostty) with zsh & [Starship prompt](https://starship.rs/)
- **Window Management**: [AeroSpace](https://github.com/nikitabobko/AeroSpace)
- **File Manager**: [Yazi](https://github.com/sxyazi/yazi)
- **Hotkeys**: [skhd](https://github.com/koekeishiya/skhd)
- **Editor**: [Neovim](https://neovim.io/) with [LazyVim](https://github.com/LazyVim/LazyVim)
- **Terminal Multiplexer**: [tmux](https://github.com/tmux/tmux)
- **Session Management**: [sesh](https://github.com/joshmedeski/sesh)

### Development Languages & Tools
- **Python**: [uv](https://github.com/astral-sh/uv), [pixi](https://pixi.sh/), [aider](https://github.com/paul-gauthier/aider)
- **Rust**: Full toolchain with cargo
- **Go**: Latest stable version
- **Node.js**: Managed via [n](https://github.com/tj/n)
- **JavaScript/TypeScript**: [Bun](https://bun.sh/) toolkit

### Enhanced CLI Experience
- **Navigation**: [zoxide](https://github.com/ajeetdsouza/zoxide), [fzf](https://github.com/junegunn/fzf)
- **File Operations**: [eza](https://github.com/eza-community/eza), [fd](https://github.com/sharkdp/fd), [ripgrep](https://github.com/BurntSushi/ripgrep)
- **Git**: [lazygit](https://github.com/jesseduffield/lazygit), enhanced aliases
- **AI**: [OpenCode](https://opencode.ai/), [LLM](https://llm.datasette.io/), local models via [Ollama](https://ollama.ai/)

## Prerequisites

**Required:**
- macOS (tested on recent versions)
- Full Disk Access for Terminal (`System Preferences → Privacy → Full Disk Access`)

**Recommended:**
- Stable internet connection for initial setup

## Installation

### Automatic Installation

The install script will:
1. Install Xcode Command Line Tools
2. Install Homebrew and all packages from [Brewfile](./Brewfile)
3. Set up Python, Node, and Bun environments
4. Configure shell environment and dotfiles via GNU Stow
5. Install additional tools and configurations

```bash
# Full installation
curl -L https://bit.ly/42YwVdi | sh

# Manual installation
git clone https://github.com/proteusiq/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

### Installation Options

The install script supports several flags:
```bash
./install.sh --help              # Show all options
./install.sh --dry-run           # Preview changes without executing
./install.sh --verbose           # Show detailed output
./install.sh --skip-interactive  # Non-interactive mode (default)
```

## Configuration

### Git Setup
Update your Git configuration:
```bash
# Edit the global gitconfig
nvim ~/dotfiles/git/.gitconfig

# Or set directly
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### SSH for GitHub
After first installation, configure SSH for GitHub:
```bash
# Generate SSH key (follow GitHub's guide)
ssh-keygen -t ed25519 -C "your.email@example.com"
gh auth login
gh ssh-key add ~/.ssh/id_ed25519.pub --type signing

# Switch to SSH remote
git remote set-url origin git@github.com:Proteusiq/dotfiles.git
```

### Color Scheme
All tools use **Catppuccin Mocha** [theme](https://catppuccin.com/):
- Ghostty
- Tmux  
- Neovim
- fzf

## Managing Aliases

View and manage comprehensive aliases using the built-in CLI:

```bash
# Show all alias categories
aliases

# Show aliases in a specific category
aliases --show git
aliases -s shortcuts

# Get details about a specific alias
aliases --describe ga
aliases -d gp
```

**Available categories:** git, coreutils, yarn, pnpm, shortcuts, special, functions
## File Structure

```
dotfiles/
├── aerospace/       # Window management config
├── bin/             # Custom scripts (aliases, peak)
├── fzf/             # Fuzzy finder config
├── ghostty/         # Terminal emulator config
├── git/             # Git configuration
├── nvim/            # Neovim configuration
├── sesh/            # Session manager config
├── starship/        # Shell prompt config
├── tmux/            # Terminal multiplexer config
├── vim/             # Basic vim config
├── yazi/            # File manager config
├── zsh/             # Shell configuration
│   ├── .aliases     # Command aliases
│   ├── .exports     # Environment variables
│   ├── .zlogin.sh   # Login shell config
│   ├── .zshenv.sh   # Environment setup
│   └── .zshrc       # Main zsh config
├── Brewfile         # Homebrew packages
└── install.sh       # Setup script
```

### Key Configuration Files
- **Shell Environment**: [Antigen](https://github.com/zsh-users/antigen) for zsh plugin management
- **Package Management**: [Brewfile](./Brewfile) contains all Homebrew packages, casks, and Mac App Store apps
- **Language Setup**: [uv](https://github.com/astral-sh/uv) for Python, [n](https://github.com/tj/n) for Node.js, [Bun](https://bun.sh/) for TypeScript/JavaScript

## Customization

## Usage Tips

<details><summary>🖥️ Tmux Session Management</summary>

**Key Bindings** (leader = `Ctrl-b`):
```bash
<leader> + I     # Install plugins
<leader> + c     # New session
<leader> + n     # Next session  
<leader> + "     # Horizontal split
<leader> + %     # Vertical split
<leader> + hjkl  # Navigate panes
<leader> + z     # Zoom/unzoom pane
<leader> + p     # Popup terminal
<leader> + O     # Popup session switcher

# Aliases
iexit    # Kill current session
ikill    # Kill all sessions
iswitch  # Interactive session switcher
```

More extras? [tmux's cheatsheet](https://tmuxcheatsheet.com/)

</details>

<details><summary>🔍 Commands "Here, There and Everywhere"</summary>

# Cool CLI Commands Reference

A collection of most common CLI commands.

---

## Process & Port Management

| Command | Description |
|---------|-------------|
| `lsof -i tcp:80` | Check which process is running on port 80 |
| `lsof -i -nP` | List all network connections with ports (no DNS resolution) |
| `pwdx <pid>` | Get the working directory of a process |

---

## Command History & Execution

| Command | Description |
|---------|-------------|
| `history 15` | List your last 15 commands with numbers |
| `!!` | Repeat last command |
| `!23` | Repeat command number 23 |
| `!f90` | Repeat last command starting with 'f90' |
| `!!moretext` | Append text to previous command |
| `^foo^bar` | Substitute foo with bar in previous command |
| `!!:s/foo/bar/` | Same as above (alternative syntax) |
| `!*` or `!&` | All arguments from last command |
| `!$` | Last argument from previous command |
| `!:1-3` | Arguments 1-3 from previous command |
| `cd !$:h` | cd to parent directory of last executed file |
| `until !!; do :; done` | Retry last command until it succeeds |
| `sudo !!` | Run last command with sudo |
| `echo "!!" > foo.sh` | Save last command to script |

---

## FZF Interactive Search

| Command | Description |
|---------|-------------|
| `nvim **<TAB>` | Open files with fzf |
| `cd **<TAB>` | Navigate with fzf |
| `kill -9 **<TAB>` | Process selection with fzf |
| `<Ctrl-r>` | Search command history |
| `docker <Ctrl-r>` | Filter history by 'docker' |

---

## Keyboard Shortcuts

| Shortcut | Description |
|----------|-------------|
| `Ctrl+C` | Interrupt current process |
| `Ctrl+Z` | Send foreground process to background |
| `Ctrl+S` | Suspend terminal output |
| `Ctrl+Q` | Resume terminal output |
| `Ctrl+L` | Clear screen |
| `Ctrl+U` | Clear entire line |
| `Ctrl+W` | Delete last word |
| `Ctrl+R` | Search command history interactively |
| `Ctrl+A` | Move to beginning of line |
| `Ctrl+E` | Move to end of line |
| `Ctrl+X Ctrl+E` | Open editor for complex commands |
| `bind -P` | List all bash shortcuts |

---

## Custom Key Bindings

| Command | Description |
|---------|-------------|
| `bind -x '"\C-l":ls -l'` | Bind Ctrl+L to 'ls -l' |
| `bind '"<ctrl+v><functionKey>":"command\n"'` | Bind function key to command |

---

## Scheduling & Timing

| Command | Description |
|---------|-------------|
| `echo "ls -l" \| at midnight` | Execute command at specific time |
| `leave +15` | System notification in 15 minutes (1555→3:55pm) |
| `timeout 5s <COMMAND>` | Kill command after 5 seconds |
| `watch -n 1 "do foo"` | Run command every 1 second |
| `while x=0; do foo; sleep 1; done` | Alternative to watch command |

---

## File Operations & Search

| Command | Description |
|---------|-------------|
| `find . -exec grep -l -e 'myregex' {} \; >> outfile.txt` | Find files matching regex, output to file |
| `grep -lir "some text" *` | Search text recursively (case-insensitive, filenames only) |
| `find . -type d -empty -delete` | Delete empty directories |
| `find . -iname '*.jpg' -exec echo '<img src="{}">' \; > gallery.html` | Create HTML gallery from JPGs |
| `cp file.txt{,.bak}` | Quick backup (creates file.txt.bak) |
| `chmod --reference file1 file2` | Copy permissions from file1 to file2 |
| `ls -Q` | List files with quotes around names |
| `touch ./-i` | Create file that blocks 'rm -rf *' |

---

## File Renaming

| Command | Description |
|---------|-------------|
| `for f in *; do mv "$f" "$(echo "$f" \| tr '[:upper:]' '[:lower:]' \| tr ' ' '_')"; done` | Lowercase and replace spaces with underscores |
| `rename 'y/ /_/' *` | Replace spaces with underscores (Perl rename) |
| `rename 'y/A-Z/a-z/' *` | Convert to lowercase |
| `rename 'y/A-Z /a-z_/' *` | Both operations at once |
| `rename --version` | Check which version of rename you have |

---

## Text Processing & Viewing

| Command | Description |
|---------|-------------|
| `less +F production.log` | View log with follow mode (better than tail -f) |
| `cat file.txt` | Display file contents |
| `tac file.txt` | Display file contents in reverse |
| `column -s, -t <file.csv>` | Format CSV as aligned table |
| `curl -s "url/json" \| python -m json.tool \| less -R` | Pretty print JSON |

---

## Log File Monitoring with Timestamps

| Command | Description |
|---------|-------------|
| `tail -f file \| while read; do echo "$(date +%T.%N) $REPLY"; done` | Add timestamps to log output |
| `tail -f file \| awk '{ printf "\033[1;90m%s\033[0m  \033[1;32m%s\033[0m\n", strftime("%T"), $0 }'` | Add colored timestamps |
| `tail -f file \| awk '{ts = strftime("%T"); if ($0 ~ /ERROR/) color="\033[1;31m"; else if ($0 ~ /WARN/) color="\033[1;33m"; else color="\033[1;32m"; printf "\033[1;90m%s\033[0m  %s%s\033[0m\n", ts, color, $0}'` | Color-coded log levels (ERROR=red, WARN=yellow) |
| `cat /var/log/secure.log \| awk '{print substr($0,0,12)}' \| uniq -c \| sort -nr \| awk '{printf("\n%s ",$0); for (i = 0; i<$1; i++) {printf("*")};}'` | Generate ASCII histogram from logs |

---

## Archives & Compression

| Command | Description |
|---------|-------------|
| `tar -cf - . \| pv -s $(du -sb . \| awk '{print $1}') \| gzip > out.tgz` | Create tar with progress bar |
| `tar --create --file - --posix --gzip -- <dir> \| openssl enc -e -aes256 -out <file>` | Create encrypted archive |
| `openssl enc -d -aes256 -in <file> \| tar --extract --file - --gzip` | Decrypt and extract archive |

---

## Git Commands

| Command | Description |
|---------|-------------|
| `git add -u` | Stage all modified and deleted files |
| `git rm $(git ls-files --deleted)` | Remove deleted files from git |
| `git log --format='%aN' \| sort -u` | List all contributors |
| `git commit -m "$(curl -s http://whatthecommit.com/index.txt)"` | Random commit message (fun!) |

---

## Network & Web

| Command | Description |
|---------|-------------|
| `curl ifconfig.me` | Get your public IP address |
| `curl wttr.in/copenhagen` | Check weather for Copenhagen |
| `nc -v -l 80 < file.ext` | Send file over network (simple server) |
| `ssh-copy-id username@hostname` | Copy SSH public key to remote host |
| `wget --reject html,htm --accept pdf,zip -rl1 --no-check-certificate https://url` | Download all PDFs and ZIPs (HTTPS) |
| `wget --reject html,htm --accept pdf,zip -rl1 url` | Download all PDFs and ZIPs (HTTP) |
| `wget --random-wait -r -p -e robots=off -U mozilla http://example.com` | Download entire website |
| `wget -mkEpnp example.com` | Mirror website (shorter syntax) |
| `lynx -dump http://domain.com \| awk '/http/{print $2}'` | Extract all URLs from webpage |

---

## System Administration

| Command | Description |
|---------|-------------|
| `sudo -K` | Forget sudo credentials immediately |
| `disown -a && exit` | Close shell but keep running tasks |
| `wall <<< "Hello, World"` | Broadcast message to all logged-in users |
| `echo "message" \| wall` | Alternative broadcast syntax |
| `kill -9 -1` | Kill all your processes |

---

## Aliases & Bypassing

| Command | Description |
|---------|-------------|
| `alias 'ps?'='ps ax \| grep '` | Create alias for process search |
| `\ls -hog` | Run ls without alias |
| `\foo` | Run foo without alias |
| `<COMMAND> \|:` | Discard output (faster than >> /dev/null) |

---

## Advanced Operations

| Command | Description |
|---------|-------------|
| `bash -x ./script.sh` | Run script in debug mode |
| `bc <<< 'obase=60;299'` | Convert seconds to minutes (base 60) |
| `command \| figlet` | Display command output in large ASCII text |
| `history \| awk '{print $2}' \| sort \| uniq -c \| sort -rn \| head` | Most frequently used commands |
| `mkdir -p data/{validation/,train/{examples/,tests/}}` | Create nested directory structure |
| `command <<< word` | Pass single word to stdin (instead of echo word \| command) |
| `rm !(*.foo\|*.bar\|*.baz)` | Remove everything except specified patterns |
| `rm -f !(survivor.txt)` | Remove everything except one file |
| `svn log -q \| grep "\|" \| awk "{print \$3}" \| sort \| uniq -c \| sort -nr` | Find frequent SVN committers |

---

## Vim Integration

| Command | Description |
|---------|-------------|
| `:r !command` | Execute command and insert output into vim |
| `:x` | Save and quit (same as :wq, shorter) |

---

## Security & Privacy

| Command | Description |
|---------|-------------|
| `unset HISTFILE` | Don't save commands in history (current session) |
| `read -s pass; echo $pass \| md5sum \| base64 \| cut -c -16` | Generate password from passphrase |

---

## Multimedia

| Command | Description |
|---------|-------------|
| `ffmpeg -f x11grab -r 25 -s 800x600 -i :0.0 /tmp/output.mpg` | Record screen |
| `read && ffmpeg -y -r 1 -t 3 -f video4linux2 -vframes 1 -s sxga -i /dev/video ~/webcam-$(date +%m_%d_%Y_%H_%M).jpeg` | Take webcam snapshot |
| `for n in E2 A2 D3 G3 B3 E4; do play -n synth 4 pluck $n repeat 2; done` | Guitar tuner (requires sox) |

---

## Fun & Visualization

| Command | Description |
|---------|-------------|
| `watch -t -n1 "date +%T\|figlet"` | Display ASCII clock |
| `cat /dev/urandom \| hexdump -C \| grep "ca fe"` | Pretend to be busy |
| `alias busy='my_file=$(find /usr/include -type f \| sort -R \| head -n 1); my_len=$(wc -l $my_file \| awk "{print $1}"); let "r = $RANDOM % $my_len" 2>/dev/null; vim +$r $my_file'` | More elaborate "busy" effect |
| `tr -c "[:digit:]" " " < /dev/urandom \| dd cbs=$COLUMNS conv=unblock \| GREP_COLOR="1;32" grep --color "[^ ]"` | Matrix effect (simple) |
| `echo -e "\e[32m"; while :; do for i in {1..16}; do r="$(($RANDOM % 2))"; if [[ $(($RANDOM % 5)) == 1 ]]; then if [[ $(($RANDOM % 4)) == 1 ]]; then v+="\e[1m $r "; else v+="\e[2m $r "; fi; else v+=" "; fi; done; echo -e "$v"; v=""; done` | Matrix effect (advanced) |

---

## Homebrew (macOS Package Manager)

| Command | Description |
|---------|-------------|
| `brew update && brew upgrade \`brew outdated\`` | Update all Homebrew packages |

---

## Helpful Search & Documentation

| Command | Description |
|---------|-------------|
| `apropos network \| more` | Search command manual pages |
| `man <command>` | View manual for command |

---

## Notes

- Commands tested on macOS with standard Unix utilities
- Some require Homebrew packages: `pv`, `figlet`, `sox`, `rename`, `wget`
- Always test destructive commands (`rm`, `kill`) carefully
- Check `rename --version` - behavior differs between Perl and util-linux versions
- For `wget` parameters: `-m` (mirror), `-k` (convert links), `-E` (adjust extensions), `-p` (page requisites), `-n` (no clobber)

---

</details>

<details><summary>⚡ Neovim/LazyVim</summary>

**Essential bindings:**
```bash
<Space>          # Leader key
<Ctrl-w>w        # Switch to file tree
[b ]b            # Navigate buffers (Alt+8/9)

# Command mode operations
:!<command>      # Execute shell command
:'<,'>!sort      # Sort selected lines
:'<,'>!jq        # Format JSON selection
:r !ls -al       # Insert command output

# Telescope
:Telescope keymap         # Show all keymaps
:Telescope live_grep      # Live grep search
:Telescope git_branches   # Git branch switcher
```

**Debugging shortcuts:**
- `<leader>dm` - Debug test method
- `<leader>dc` - Debug test class  
- `<leader>df` - Debug Python file
- `<leader>du` - Debug function under cursor

</details>

<details><summary>🧘 Vim Grammar Reference</summary>

Vim follows **Verb + Noun** grammar for powerful text editing:

**Verbs (Actions):**
- `d` - delete
- `c` - change (delete + insert mode)
- `y` - yank (copy)

**Nouns (Motions):**
- `w/b` - word forward/backward
- `gg/G` - top/bottom of file
- `{/}` - paragraph navigation

**Text Objects (preferred for repeatability):**
- `iw/aw` - inner/around word
- `i"/a"` - inner/around quotes
- `i(/a(` - inner/around parentheses

**Examples:**
- `diw` - delete inner word
- `ci"` - change inside quotes
- `yap` - yank around paragraph

**Pro tip:** Text objects work regardless of cursor position and support the `.` repeat command.

</details>

## Troubleshooting

**Common issues:**

1. **Homebrew installation fails**: Ensure Xcode Command Line Tools are installed first
2. **Stow conflicts**: Remove existing dotfiles before running stow
3. **Permission errors**: Grant Full Disk Access to your terminal
4. **Python/Node issues**: Check that uv and n are properly installed
5. **Terminal theme issues**: Restart terminal after font installation

**Need help?**
- Check the [install log](~/macos-setup.log) for detailed error information
- Run install script with `--verbose` flag for debugging
- Ensure all prerequisites are met before installation

**Useful resources:**
- [cheat.sh](https://cheat.sh/) - `curl https://cheat.sh/<command>`
- Command reference: `tlrc <command>`
- Vim help: `:help <topic>` or `:Telescope help_tags`



## Acknowledgements

Inspired by [Sara Pope's dotfiles](https://github.com/gretzky/dotfiles) and the broader dotfiles community.

---

*A fork focused on modern development workflows with Rust, Python, and AI tooling.*
