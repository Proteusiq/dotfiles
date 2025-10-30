![image](https://github.com/Proteusiq/dotfiles/assets/14926709/9e3c4c60-43cd-4e47-9711-49eeb1078ae4)

# dotfiles

Dotfiles for 🦀(MLOps) and 🐲(Data Scientist): A [Sara Pope's](https://github.com/gretzky/dotfiles) Spin-Off.

![CleanShot 2024-06-22 at 19 34 12@2x](https://github.com/Proteusiq/dotfiles/assets/14926709/b5374cdb-753c-4559-ad8e-920d9653de34)



-   Terminal: [Ghostty](https://github.com/ghostty-org/ghostty) using zsh w/ [starship prompt](https://starship.rs/)
-   Window management: [aerospace](https://github.com/nikitabobko/AeroSpace)
-   File management: [yazi](https://github.com/sxyazi/yazi)
-   Hotkeys: [skhd](https://github.com/koekeishiya/skhd)
-   Vim: [neovim](https://neovim.io/) with [lazyvim](https://github.com/LazyVim/LazyVim) destro
-   Tools: [tmux](https://github.com/tmux/tmux), [zoxide](https://github.com/ajeetdsouza/zoxide), [fzf](https://github.com/junegunn/fzf), [eza](https://github.com/eza-community/eza), [aider](https://github.com/paul-gauthier/aider)
-   Languages: Python, Rust, Go, JavaScript, Lua

## Managing Aliases

The dotfiles include a comprehensive set of aliases to streamline your workflow. You can view and manage these aliases using the CLI tool. To see a list of available alias categories and examples, run:

```bash
aliases
```

To show all aliases in a specific category, use:

```bash
aliases --show git
aliases -s shortcuts
```

To see detailed information about a specific alias, use:

```bash
aliases --describe ga
aliases -d gp
```

Available categories: git, coreutils, yarn, pnpm, shortcuts, special, functions

**Before you get started** make sure you give full disk access permission to your terminal (for writing macos defaults). `System Preferences -> Privacy -> Full Disk Access`.

Add [+] Utilities > Terminal


To install:

`curl -L https://bit.ly/42YwVdi | sh`

This expands to [run.sh](https://github.com/proteusiq/dotfiles/blob/master/run.sh) which will fetch this repo and run the install script. Use less to peak in the script before running it.

```sh
curl -LsSf https://bit.ly/42YwVdi | less
```
## File overview

-   Configs for the following tools:
    -   git
    -   [ghostty](./ghosttytty)
    -   [fzf](./fzf)
    -   [neovim](./nvim)
    -   [skhd](./skhd)
    -   [starship](./starship)
    -   [tmux](./tmux)
    -   [yazi](./yazi/)
    -   [aerospace](./aerospace/)
-   Shell environment configs:
    -   [Antigen](https://github.com/zsh-users/antigen) for zsh plugin management
    -   [`.zshrc`](./zsh/.zshrc)
    -   [`.zlogin.sh`](./zsh/.zlogin.sh)
    -   [`.zshenv.sh`](./zsh/.zshenv.sh)
    -   [`.aliases`](./zsh/.aliases)
    -   [`.exports`](./zsh/.exports)
-   [`Brewfile`](./Brewfile) - contains all homebrew packages, casks, and mac appstore apps

The install script will also setup Python, Node and Bun versions/environments:

-   [uv](https://github.com/astral-sh/uv) manages Python version to latest stable version and installs additional tools like `aider`
-   [n](https://github.com/tj/n) sets the global Node version to LTS
-   [bun](https://bun.sh/)  all-in-one toolkit for JavaScript and TypeScript apps

<details><summary>Brewfile Tools Definitions</summary>

```sh
# GUI & Command Line Tools
# Utilities and tools to enhance the command line interface experience
"ack" # A tool like grep, optimized for programmers
"act" # Run Github actions locally
"aider" # LLM code agent on terminal 
"aldente" # Battery life 
"applesimutils" # Apple Simulator Utilities
"arc" # Browser for the future - 1Password, Vimium C extentions
"alttab" # Better preview app switcher 
"azure-cli" # Microsoft Azure Command Line Interface
"bat" # A cat clone with syntax highlighting and Git integration
"broot" # A better tree
"btop" # Resource monitor that shows usage and stats
"binutils" # GNU binary tools for native development
"chruby" # Changes the current Ruby
"cleanshot" # Better screen capture
"coreutils" # GNU File, Shell, and Text utilities
"diffutils" # File comparison utilities
"direnv" # Environment switcher for the shell
"espanso" # Expands text shortcuts to full template
"eza" # A better ls and tree
"fd" # A simple, fast and user-friendly alternative to 'find'
"ffmpeg" # A complete, cross-platform solution to record, convert and stream audio and video
"figlet" # ascii fonts similar to toilet but with better fonts
"findutils" # GNU `find`, `locate`, `updatedb`, and `xargs` commands
"fzf" # Command-line fuzzy finder
"gawk" # GNU awk utility
"gh" # GitHub cli used by plenary
"git" # Distributed revision control system
"git-lfs" # Git Large Files Storage
"git-filter-repo" # When we mess up and want to clean
"gnu-sed" # GNU implementation of the famous stream editor
"gnu-tar" # GNU version of the tar archiving utility
"gnu-time" # GNU implementation of the time utility
"gnu-which" # GNU implementation of the 'which' utility to find path of executables
"gnupg" # GNU Pretty Good Privacy (PGP) package
"go" # The Go programming language
"goose" # Goose AI Agent on the loose
"graphviz" # Visualizing graphs
"grep" # GNU grep, egrep and fgrep
"gum" # Glamorous shell scripts
"gzip" # GNU compression utility
"harlequin" # CLI access to DB. Much better than my custom"peak" cli
"httpie" # Colorful curl. Instead of curl,  just httpx 
"hiddenbar" # Hides unpopular tab icons
"hyperfine" # A command-line benchmarking tool
"jq" # Lightweight and flexible command-line JSON processor
"lazygit" # The lazier way to manage everything git
"lazydocker" # The lazier way to manage everything docker
"lm-studio" # A better LM Studio => Ollama + Open-Webui as Application
"llama.cpp" # Serves LLM models # used for rernaking models
"mongosh" # Mongo DB shell
"moreutils" # Collection of tools that nobody wrote when UNIX was young
"ncdu" # NCurses Disk Usage
"neovim" # Ambitious Vim-fork focused on extensibility and agility
"node" # Platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications
"ollama" # Running Large Language Models offline
"opencode" # AI coding agent, built for the terminal.
"pixi" # Fast than mamba: Drop in replacer of Pyenv + Poetry for conda universe
"python" # Interpreted, interactive, object-oriented programming language
"ra-aid" # Large Code Base LLM Agent => works with aider
"raycast" # A better spotlight - CleanShotX, Ollama, OpenAI, Alacritty, Brew extensitions
"rename" # Perl-powered file rename script with many helpful built-ins
"repgrep" # rgr interactive rust ripgrep extention
"ripgrep" # Recursively searches directories for a regex pattern while respecting your gitignore
"rsync" # Utility that provides fast incremental file transfer
"ruby" # A beautiful language
"rust" # Safe, concurrent, practical language
"screen" # GNU screen, terminal multiplexer
"slides" # Presentation on terminal
"shotcat" # Vimium C for Apps: Path to Mouseless World
"starship" # Cross-shell prompt for astronauts
"stow" # Manage installation of multiple softwares in the same directory structure
"terraform" # Tool for building, changing, and versioning infrastructure safely and efficiently
"thefuck" # Autocorrection with f as alias
"tldr" # Too long I did nor read man
"toilet" # ascii art fonting similar to figlet but with filter and boarder e.g. toilet -F border -f future Welcome Prayson
"tmux" # Terminal multiplexer
"universal-ctags" # Creates a compressed version of a code bases used by Aider
"uv" # Python's Cargo. Better drop in pip replacer alias pip='uv pip'
"vim" # Highly configurable text editor built to enable efficient text editing
"watchman" # Watch files and take action when they change
"wget" # Internet file retriever
"yarn" # JavaScript package manager
"yazi" # Terminal file management
"zlib" # General-purpose lossless data-compression library
"zplug" # A next-generation plugin manager for zsh
"zsh" # UNIX shell (command interpreter)
"zoxide" # A faster way to navigate your filesystem


# GUI Applications (Casks)
# Various applications installed through Homebrew Cask
"1password" # Password manager
"1password-cli" # Using op vault cli
"ghostty" # GPU-accelerated terminal emulator
````

</details>

### Customization

####  Git
- Be sure to update the user name/email values in the global [gitconfig](./git/.gitconfig)
#### Color Schemes

- ghostty, Tmux, Nvim, fzf := color scheme == [Catppuccin-Mocha](https://github.com/catppuccin/catppuccin)

### After First Installation, Sync dotfile with GitHub
Configure GitHub to usee SSH [Configure](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) + [Setup](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

Change dotfile remote url to use ssh: 
`git remote set-url origin git@github.com:Proteusiq/dotfiles.git`

## MacOS settings
<details><summary>Steps of updating or changing  `macos/.macos` to fit your preferences</summary>

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
See [RexYuan](https://github.com/RexYuan/Blemishine/tree/main/preferences)'s settings for inspiration and examples

</details>

## Oh Vim
<details><summary>🧘🏾‍♂️ Vim Grammar: Verb + Noun</summary>

In Vim, editing operations follow a grammar-like structure: **Verb + Noun**. The verb represents an action, while the noun represents the text or movement the action operates on. This allows for flexible and powerful editing.
See: [Learn Vim the Smarter Way](https://learnvim.irian.to). Note: Visual mode **Noun<selected> + Verb***.

## Verbs

| Verb | Action                                      |
|------|---------------------------------------------|
| `d`  | delete                                      |
| `c`  | change (delete + enter insert mode)         |
| `y`  | yank (copy)                                 |

## Nouns (Motions)

| Noun   | Description                        |
|--------|------------------------------------|
| `w`    | word (forward by word)             |
| `b`    | back (backward by word)            |
| `3j`   | down 3 lines                       |
| `G`    | down to bottom                     |
| `gg`   | up to top                          |
| `s`    | sentence                           |
| `p`    | paragraph                          |

## Nouns (Text Objects)

| Noun  | Description                        |
|-------|------------------------------------|
| `iw`  | inner word                         |
| `ib`  | inner bracket (i{ or i() )         |
| `i"`  | inner quotes                       |
| `is`  | inner sentence                     |
| `as`  | a sentence                         |

## Nouns (Parameterizers)

| Noun   | Description                               |
|--------|-------------------------------------------|
| `f`, `F` | find the next character                  |
| `t`, `T` | find until next character                |
| `/`      | next match (word/pattern)                |

## Examples: Verb + Noun 
>Preferably Text Objects for repeatability with dot `.`

| Command   | Action                                   |
|-----------|------------------------------------------|
| `diw`     | delete inner word                        |
| `da"`     | delete contents a(rround) and include `"`|
| `yib`     | yank (copy) inner bracket                |
| `cfK`     | change to next occurrence of character K |

Why Text Objects over Motions:
 
`cw` change executes from the current cursor position, while `ciw` execute whole object regardless of the cursor position.
Allowing dot `.` <repeatability> of action.


## Prefix: g (Super Prefix to Extend Commands)

| Command   | Action                                   |
|-----------|------------------------------------------|
| `gUaw`    | uppercase a word                         |
| `:g/^\s*$/d` | search and remove all empty lines.    |

---

This structure allows you to combine commands fluidly, increasing efficiency in text editing. By mastering verbs, nouns, and their combinations, you can perform powerful editing operations with minimal keystrokes.
                                                     
More Vim keybindings:

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

Better grammar `diw` or `daw` - delete inside/arround word

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

---

### Extra: Comment Visual Block
```sh
ggVG
<ctrl> + v
<shift> + i
#<space>
<ESC>
```

</details>

### Who You Gonna Call? 👻
[cheat.sh](https://cheat.sh/) - `curl https://cheat.sh/<cli_command>`

## Using Tools
<details><summary>Tips + Tricks</summary>

  ### Short🐈
  Ctrl + f
---

  ### Sesh Tmux
  raycast plugins sesh + sesh connect on terminal rocks
  <leader> + K
  
 ### Increasing and Decreasing Pane
  <leader> + [hjkl] 
    

---
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
<leader> + p (P menu) # => popup terminal (leader + p to close)
<leader> + O  # => popup sessions (esc to close)

# custom
iexit # alias to kill-session
ikill # alias to kill-server
iswitch # alias to switch-session
ipop # alias for popup window
```
---
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
---

## Using lazyVim

```sh
<leader> # Space
<C-w> # window actions
     # w # moves back to Neo-Tree
[b ]b  # option/alt 8 and 9 for [] to navigate buffers(tabs)  

# command mode
: # run sh commands: use case sort data, select and execute : <','>!sort or structure JSON <','> !jq
# Visual mode select: 
#   '<,'>s/^./# &/ -> replace anything with '#' to all non-blank lines"
#   '<,'>s/^\([^#]\)/# &/ -> replace anything but lines  starting with '#' with # "
: + !(Shift + 1) # filter mode: echo "OPENAI_API_KEY=sk-****** >> .env"

# direct command output to buffer
`:r !ls -al`

# fold and unfold text
`:set foldmethod=manual` select an area > `zf` to fold, `zo`to unfold under cursor

# Telescope:
:Telescope keymap
:Telescope lsp_definition `gd`
:Telescope live_grep
:Telescope lsp_reference `gr`
:Telescope git_branches
:Telescopes buffers

# More

Switch words
:s/\(hello\)\s\(there\)/\2 \1/

= => indent =G indent all to bottom
:help or :h v_d(help of visual mode d) (ctrl + wc) window close

# Debugging
## Key Mappings

| Shortcut      | Description                  |
|---------------|------------------------------|
| `<leader>dm`  | Debug Test Method             |
| `<leader>dc`  | Debug Test Class              |
| `<leader>df`  | Debug Python File             |
| `<leader>du`  | Debug Function Under Cursor   |
| `<leader>dk`  | Debug Class Under Cursor      |

```
# Cool CLI Commands Reference

A curated collection of powerful command-line tools and shortcuts for macOS.

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
| `!!addtext` | Append text to previous command |
| `^string1^string2` | Substitute string1 with string2 in previous command |
| `!!:s/foo/bar/` | Same as above (alternative syntax) |
| `!*` or `!&` | All arguments from last command |
| `!$` | Last argument from previous command |
| `!:1-3` | Arguments 1-3 from previous command |
| `cd !$:h` | cd to parent directory of last executed file |
| `until !!; do :; done` | Retry last command until it succeeds |
| `sudo !!` | Run last command with sudo |
| `echo "!!" > foo.sh` | Save last command to script |

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

## Google Search Function

```bash
function google {
  Q="$@"
  GOOG_URL='https://www.google.de/search?tbs=li:1&q='
  AGENT="Mozilla/4.0"
  stream=$(curl -A "$AGENT" -skLm 10 "${GOOG_URL}${Q//\ /+}" | grep -oP '\/url\?q=.+?&amp' | sed 's|/url?q=||; s|&amp||')
  echo -e "${stream//\%/\x}"
}
```

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

**Created for macOS users | Share freely**

</details>



## Acknowledgements

-   [Sara Pope's](https://github.com/gretzky/dotfiles) and all before her.
