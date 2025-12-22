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
- [Usage Tips](#usage-tips)
- [Troubleshooting](#troubleshooting)
- [Acknowledgements](#acknowledgements)

## Quick Start

> [!TIP]
> Preview the script before running: `curl -LsSf https://bit.ly/42YwVdi | less`

```bash
curl -L https://bit.ly/42YwVdi | sh
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
- **Python**: [uv](https://github.com/astral-sh/uv), [pixi](https://pixi.sh/) with Python 3.13
- **Rust**: Full toolchain with cargo
- **Go**: Latest stable version
- **Node.js**: Managed via [n](https://github.com/tj/n)
- **JavaScript/TypeScript**: [Bun](https://bun.sh/) toolkit

### Enhanced CLI Experience
- **Navigation**: [zoxide](https://github.com/ajeetdsouza/zoxide), [fzf](https://github.com/junegunn/fzf)
- **File Operations**: [eza](https://github.com/eza-community/eza), [fd](https://github.com/sharkdp/fd), [ripgrep](https://github.com/BurntSushi/ripgrep)
- **Git**: [lazygit](https://github.com/jesseduffield/lazygit), [serie](https://github.com/lusingander/serie) for rich git logs, [gitlogue](https://github.com/unhappychoice/gitlogue) for cinematic commit replay, enhanced aliases
- **AI**: [OpenCode](https://opencode.ai/), [LLM](https://llm.datasette.io/), local models via [Ollama](https://ollama.ai/)

## Prerequisites

> [!IMPORTANT]
> Grant **Full Disk Access** to your terminal before installation: `System Preferences → Privacy → Full Disk Access`

- macOS (tested on recent versions)
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
./install.sh --list              # List all available functions
./install.sh --only <function>   # Run only a specific function
```

**Run individual functions:**
```bash
./install.sh --list              # List available functions
./install.sh --only stow         # Only stow dotfiles
./install.sh --only cleanup      # Only run cleanup
./install.sh --only utils        # Only setup utilities
./install.sh --only brew         # Only install Homebrew packages
```

> [!TIP]
> After installation, you can use the `update` alias instead of `./install.sh`

> [!NOTE]
> Available functions: `dirs`, `xcode`, `brew`, `node`, `venv`, `tmux`, `yazi`, `utils`, `stow`, `cleanup`

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

> [!NOTE]
> After first installation, configure SSH for passwordless GitHub access.

```bash
# Generate SSH key (follow GitHub's guide)
ssh-keygen -t ed25519 -C "your.email@example.com"
gh auth login
gh ssh-key add ~/.ssh/id_ed25519.pub --type signing

# Switch to SSH remote
git remote set-url origin git@github.com:Proteusiq/dotfiles.git
```

### Color Scheme

> [!NOTE]
> All tools use the **Catppuccin Mocha** [theme](https://catppuccin.com/) for a consistent look.

Ghostty • Tmux • Neovim • fzf

## Managing Aliases

View and manage comprehensive aliases using the built-in CLI:

```bash
# Show all alias categories
aliases

# Show aliases in a specific category
aliases --show git
aliases -s modern

# Get details about a specific alias
aliases --describe ga
aliases -d gp

# Launch interactive TUI browser
aliases --tui
aliases -t
```

> [!TIP]
> Use `aliases --tui` for an interactive browser with search, category navigation, and keyboard shortcuts (`/` search, `j/k` navigate, `q` quit).

**Available categories:** git, coreutils, yarn, pnpm, shortcuts, editors, navigation, modern, tmux, macos, functions

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

> More extras? [tmux's cheatsheet](https://tmuxcheatsheet.com/) and [man wiki](https://github.com/tmux/tmux/wiki/Getting-Started)

</details>

<details><summary>⚡ Neovim/LazyVim - Complete Plugin Guide</summary>

This configuration includes 23 powerful plugins organized by category. Below is the complete reference guide with keybindings, purposes, and practical examples.

### LazyVim Extras

Extras are managed in `nvim/.config/nvim/lua/plugins/extras.lua`. To add/remove extras, edit this file:

```lua
-- nvim/.config/nvim/lua/plugins/extras.lua
return {
  { import = "lazyvim.plugins.extras.coding.yanky" },
  { import = "lazyvim.plugins.extras.dap.core" },
  -- ... add or remove lines here
}
```

**Currently enabled extras:**

| Extra | Purpose | Key Features |
|-------|---------|--------------|
| `coding.yanky` | Enhanced yank/paste | Yank history, paste cycling |
| `dap.core` | Debug Adapter Protocol | Breakpoints, stepping, REPL |
| `editor.leap` | Fast motion | `s`/`S` to jump anywhere |
| `editor.neo-tree` | File explorer | `<leader>e` sidebar |
| `lang.python` | Python support | LSP, formatting, debugging |
| `lang.rust` | Rust support | rust-analyzer, cargo integration |
| `test.core` | Test runner | `<leader>tt` run nearest test |
| `ui.mini-animate` | Smooth animations | Cursor, scroll, window animations |
| `util.dot` | Dotfile syntax | Highlighting for config files |
| `util.gh` | GitHub CLI | `gh` command integration |
| `util.gitui` | GitUI integration | Alternative git TUI |
| `util.octo` | GitHub in Neovim | Issues, PRs, code review |

**Test keymaps from `test.core`:**

| Keymap | Action |
|--------|--------|
| `<leader>tt` | Run nearest test |
| `<leader>tT` | Run current file tests |
| `<leader>tr` | Run last test |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Show test output |
| `<leader>tO` | Toggle output panel |
| `<leader>tS` | Stop tests |

**To add more extras**, browse available options with `:LazyExtras` in Neovim, then add the import line to `extras.lua`. After saving, restart Neovim and run `:Lazy sync`.

### File & Buffer Management

| Plugin | Purpose | Keymap | Notes |
|--------|---------|--------|-------|
| **Snacks** | Find files | `<leader><leader>` | Find files (like `<leader>ff`) |
| | Search & Replace | `<leader>sr` | **BROKEN** - needs fix |
| **Telescope** | Fuzzy file finder | `<leader>ff` | Find files project-wide |
| | Live grep search | `<leader>fg` | Search file contents |
| | Buffer list | `<leader>fb` | Quick buffer switcher |
| | Help tags | `<leader>fh` | Documentation search |
| **Harpoon** | Add bookmark | `<leader>a` | Mark current file for quick access |
| | View bookmarks | `<C-e>` | Toggle harpoon menu (Telescope) |
| | Jump to file 1-4 | `<C-h>/<C-t>/<C-n>/<C-s>` | Direct jump to bookmarked file |
| | Next/prev file | `<C-S-P>/<C-S-N>` | Cycle through bookmarks |
| **Yazi** | Open file manager | `<leader>-` | Browse files in current directory |
| | Open in cwd | `<leader>cw` | Browse from working directory |

### Code Navigation & Structure

| Plugin | Purpose | Keymap | Notes |
|--------|---------|--------|-------|
| **Navbuddy** | Open code navigator | `<leader>nv` | LSP-powered symbol tree browser |
| | Navigate structure | `k/i/j/l` | Previous/next/parent/children |
| **Atone** | Open undo history | `:Atone` | Visualize and navigate undo history |

### Editing & Text Manipulation

| Plugin | Purpose | Keymap | Notes |
|--------|---------|--------|-------|
| **Surround** | Add surrounding | `ys<motion><char>` | Example: `ysiw"` wraps word in quotes |
| | Change surrounding | `cs<old><new>` | Example: `cs"'` changes "text" to 'text' |
| | Delete surrounding | `ds<char>` | Example: `ds"` removes quotes |
| **Better Escape** | Fast escape | `jk` or `jj` | Alternative to `<Esc>` (customizable) |
| **Live Command** | Preview commands | `:s/foo/bar/` | Real-time preview while typing |

### Git & GitHub Integration

| Plugin | Purpose | Keymap | Notes |
|--------|---------|--------|-------|
| **Snacks** | Open Lazygit | `<leader>gg` | Full Git UI in Neovim |
| | File history | `<leader>gf` | Lazygit history for current file |
| | Git log | `<leader>gl` | Lazygit log for working directory |
| | Blame line | `<leader>gb` | Show who changed this line |
| | Browse on GitHub | `<leader>gB` | Open file on GitHub |
| **Octo** | List issues | `<space>il` | GitHub issues on current repo |
| | Close/reopen | `<space>ic`/`<space>io` | Issue state management |
| | Checkout PR | `<space>po` | Checkout a pull request |
| | Merge PR | `<space>pm` | Merge commit the PR |
| | PR diff | `<space>pd` | View PR changes |
| | Add reviewer | `<space>va` | Request PR review |
| | Start review | `<space>vs` | Start/submit code review |
| | Add comment | `<space>ca` | Comment on PR/issue |
| | Add label | `<space>la` | Label issue/PR |
| | Add assignee | `<space>aa` | Assign to user |
| | Open in browser | `<C-b>` | Open PR/issue on GitHub.com |
| | Reactions | `<space>r+` `<space>rh` | Add 👍 ❤️ 👎 reactions |
| **Git Conflict** | Resolve conflicts | Auto-triggered | Tools appear on merge conflicts |

### Debugging

| Plugin | Purpose | Keymap | Notes |
|--------|---------|--------|-------|
| **DAP Python** | Debug test method | `<leader>dm` | Step through test methods |
| | Debug test class | `<leader>dc` | Debug entire test class |
| | Debug file | `<leader>df` | Debug current Python file |
| | Debug function | `<leader>du` | Debug function under cursor |
| | Debug class | `<leader>dk` | Debug class under cursor |
| **Rustaceanvim** | Code action | `<leader>cR` | Rust LSP code actions |
| | Debuggables | `<leader>dr` | List Rust debug targets |

### AI & Development Assistance

| Plugin | Purpose | Keymap | Notes |
|--------|---------|--------|-------|
| **OpenCode** | Ask about code | `<leader>oa` | Ask with `@this` context |
| | Select prompt | `<leader>os` | Choose predefined prompt |
| | Add context | `<leader>o+` | Add `@this` to context |
| | Toggle panel | `<leader>ot` | Show/hide OpenCode panel |
| | Select command | `<leader>oc` | Pick from available commands |
| | New session | `<leader>on` | Start fresh AI session |
| | Interrupt | `<leader>oi` | Stop current operation |
| | Cycle agent | `<leader>oA` | Switch between agents |
| | Scroll messages | `<S-C-u>/<S-C-d>` | Half-page scroll in messages |

### Buffers & Windows

| Plugin | Purpose | Keymap | Notes |
|--------|---------|--------|-------|
| **Snacks** | Scratch buffer | `<leader>.` | Quick temporary buffer |
| | Delete buffer | `<leader>bd` | Close current buffer |
| | Rename file | `<leader>cR` | Rename with preview |
| | Floating terminal | `<C-/>` | Toggle terminal overlay |

### UI & Display Toggles

| Feature | Keymap | Purpose |
|---------|--------|---------|
| Spelling | `<leader>us` | Toggle spell check |
| Wrapping | `<leader>uw` | Toggle line wrapping |
| Relative numbers | `<leader>uL` | Toggle relative line numbers |
| Diagnostics | `<leader>ud` | Show/hide LSP diagnostics |
| Line numbers | `<leader>ul` | Toggle line number display |
| Treesitter | `<leader>uT` | Toggle syntax highlighting |
| Background | `<leader>ub` | Toggle dark/light mode |
| Inlay hints | `<leader>uh` | Toggle LSP inlay hints |

### Navigation & References

| Plugin | Purpose | Keymap | Notes |
|--------|---------|--------|-------|
| **Snacks** | Next reference | `]]` | Jump to next symbol reference |
| | Prev reference | `[[` | Jump to previous reference |
| | Notification history | `<leader>n` | Show notification history |
| | Neovim news | `<leader>N` | View Neovim news & updates |

### Command Mode Operations

| Command | Purpose | Example |
|---------|---------|---------|
| `:!<command>` | Execute shell | `:!ls -al` |
| `:'<,'>!sort` | Sort selection | Select lines, then run |
| `:'<,'>!jq` | Format JSON | Pretty-print JSON selection |
| `:r !<command>` | Insert output | `:r !date` inserts current date |
| `:Telescope keymap` | Show keymaps | Searchable keymap reference |
| `:Telescope live_grep` | Search project | Live grep across files |
| `:Telescope git_branches` | Git branches | Interactive branch switcher |

### Quick Reference by Leader Key Prefix

| Prefix | Purpose | Examples |
|--------|---------|----------|
| `<leader>f` | **Find/Fuzzy** | `ff` files, `fg` grep, `fb` buffers |
| `<leader>g` | **Git** | `gg` lazygit, `gb` blame, `gf` history |
| `<leader>o` | **OpenCode (AI)** | `oa` ask, `os` select, `on` session |
| `<space>` | **Octo (GitHub)** | `il` issues, `po` checkout PR, `pm` merge |
| `<leader>u` | **UI Toggles** | `us` spell, `uw` wrap, `ud` diagnostics |
| `<leader>d` | **Debug** | `dm` method, `dc` class, `df` file |
| `<leader>.` | **Scratch** | `.` toggle, `bd` delete, `S` select |
| `<leader>n` | **Navigate** | `nv` navbuddy, `n` notifications |
| `<leader>-` | **Files** | `-` current, `cw` working directory |

### Essential Core Bindings

```bash
<Space>          # Leader key
<Ctrl-w>w        # Switch to file tree
[b ]b            # Navigate buffers (Alt+8/9)
<Ctrl-h/j/k/l>   # Navigate windows
```

### Pro Tips

- **@this context**: Use `<leader>oa` with `@this` to ask OpenCode about your current code
- **Fuzzy matching**: Telescope uses fuzzy search - type partial names and it finds matches
- **Git workflow**: `<leader>gg` opens Lazygit for complex operations, `<space>il` for issues
- **File history**: If you're disciplined with commits, `<leader>Gh` (`:Telescope git_file_history`) is your best friend for tracking how a file evolved over time
- **Quick edits**: Surround plugin (`ys`, `cs`, `ds`) makes text transformation fast and repeatable
- **Markdown**: `.nvim/README.md` and other markdown files render beautifully inline

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

<details><summary>💡 Pragmatic Goodies & Guides</summary>

#### 🔍 Explore File History Over Time
___
One of the most powerful features in this setup is the ability to see how a file has changed throughout your git history. This is incredibly useful for:
- Understanding the evolution of code changes
- Tracking when bugs were introduced
- Learning from your own past edits
- Reviewing refactoring decisions

**Keymap:** `<leader>Gh` or `:Telescope git_file_history`

**How to Use:**
1. Open any file in your project
2. Press `<leader>Gh` (or run `:Telescope git_file_history`) to open the git file history picker
3. Browse through all commits that touched this file
4. Select a commit to view how the file looked at that point in time
5. Use Telescope's navigation keys to explore previous versions side-by-side with diffs

**Example Workflow:**
```vim
<leader>Gh                   " Open history for current file
" Browse commits with j/k, preview with ?
" Press <CR> to view the selected commit version
" Use Telescope's diff view to see what changed
```

This integration combines Telescope's powerful fuzzy finding with git-file-history extension to give you instant access to temporal navigation of your codebase.

#### 🎨 Quickly Switch Between Color Themes
___
Change editor's appearance instantly without leaving Neovim. Perfect for:
- Finding the right theme for different times of day (dark mode at night, light mode during day)
- Testing how code looks in different color schemes
- Matching your editor theme to your mood or lighting conditions
- Discovering new themes and comparing them instantly

**Keymap:** `<leader>uC`

**How to Use:**
1. Press `<leader>uC` to open the colorscheme picker
2. Type to filter available themes (supports fuzzy search)
3. Use `j/k` or arrow keys to navigate through themes
4. Press `<CR>` to apply the selected theme immediately
5. Press `?` in the picker to see all available actions

**Example Workflow:**
```vim
<leader>uC         " Open colorscheme picker
tokyonight         " Type to filter (fuzzy search)
<CR>               " Apply selected theme instantly
```

All installed colorschemes are available with live preview as you browse!

#### 🎯 Multi-Cursor Editing with multicursor.nvim
___
Efficient multi-cursor editing directly in Neovim. Perfect for:
- Simultaneous editing across multiple locations
- Fast refactoring and bulk text operations
- Reducing repetitive edits on similar patterns
- Maintaining productivity without leaving the editor

**Keymaps:** Arrow keys to add cursors, `<leader>n/N` to match word/selection

**How to Use:**
1. Position cursor on target word/selection
2. Press `<up>/<down>` to add cursor above/below current line
3. Or press `<leader>n` to add cursor at next match of word under cursor
4. Edit normally - changes apply to all cursor locations simultaneously
5. Press `<Esc>` to clear all cursors

**Example Workflow:**
```vim
<down>             " Add cursor below current line
<down>             " Add another cursor below
i                  " Enter insert mode
new_text           " Type - applies to all cursor positions
<Esc>              " Exit and clear cursors

" Or match-based:
<leader>n          " Add cursor at next match of word
<leader>n          " Add another cursor at next match
```

**Pro Tips:**
- All cursors are **bufwin-local** - they persist when switching between windows with the same buffer
- Use `<leader><up>/<down>` to skip a line when adding cursors
- Use `<leader>N` to match previous occurrence (backwards)
- Use `<C-q>` to toggle (disable/enable) cursors
- Use `<left>/<right>` to select different cursor as main (when multiple cursors active)
- Use `<leader>x` to delete the main cursor

**Use cases:** Variable renaming across file, bulk find-and-replace, consistent formatting updates, batch code modifications

#### 🛠️ Essential CLI Tools
___
Command-line tools for various tasks. Here are quick how-tos for the essential ones:

##### 📋 **lnav** - Log Viewer & Analyzer
View and analyze log files with an interactive terminal UI. Perfect for debugging and monitoring logs from multiple sources.

```bash
lnav /var/log/system.log           # View a specific log file
lnav                               # Interactive log file picker
# Inside lnav: Use j/k to navigate, / to search, q to quit
```

**Use cases:** Debug application errors, monitor system logs, analyze multiple log files side-by-side

---

##### 🐙 **lazygit** - Git Management UI
Interact with Git repositories through an intuitive terminal UI. Also accessible in Neovim via `<leader>gg`.

```bash
lazygit                            # Open Git UI in current repo
# Inside: Stage files, commit, branch management with vim-like keybinds
```

**Use cases:** Visual staging, interactive rebasing, branch management, blame view

---

##### 📚 **serie** - Rich Git Commit Graph
View a beautiful, rich git commit graph in your terminal with image rendering support.

```bash
serie                              # Open git commit graph in current repo
serie --order topo                 # View commits topologically sorted
serie --order chrono               # View commits chronologically (default)
serie --preload                    # Preload all graph images for smoother scrolling
# Inside: j/k navigate, Enter to show details, ? for help, / to search
```

**Use cases:** Visualizing commit history, understanding branch structure, exploring complex git workflows

---

##### 🎬 **gitlogue** - Cinematic Git Replay
A cinematic Git commit replay tool that turns your Git history into a living, animated story with realistic typing animations and syntax highlighting.

```bash
gitlogue                           # Start cinematic screensaver mode
gitlogue --commit HEAD~5..HEAD     # Replay a range of commits
gitlogue --commit abc123 --loop    # Loop a specific commit
gitlogue --author "john"           # Filter commits by author
gitlogue --theme dracula           # Use a different theme
gitlogue --speed 20                # Adjust typing speed (ms per char)
gitlogue theme list                # List available themes
```

**Use cases:** Screensaver, presentations, content creation, education, visualizing code evolution

---

##### 📊 **gh-dash** - GitHub Dashboard
Interactive GitHub CLI dashboard for viewing pull requests, issues, and more directly from your terminal.

```bash
gh-dash                                # Open GitHub dashboard
# Inside: View PRs, issues, repos with vim-like navigation
```

**Use cases:** Quick PR review, issue tracking, repository status overview, GitHub activity monitoring

---

##### 🐳 **lazydocker** - Docker Management UI
Manage Docker containers, images, and networks with an interactive TUI.

```bash
lazydocker                         # Open Docker UI
# Inside: View containers, logs, exec commands with vim-like navigation
```

**Use cases:** Container debugging, quick logs viewing, resource monitoring, container lifecycle management

---

##### 💾 **harlequin** - SQL IDE
Run and test SQL queries interactively with connection management and results formatting.

```bash
harlequin                          # Open SQL IDE
harlequin --dialect duckdb         # Specify SQL dialect (duckdb, sqlite, postgres, etc.)
# Inside: Write queries, view results, explore databases
```

**Use cases:** SQL development, database exploration, query testing, data analysis

---

##### 📊 **tabiew** - Tabular Data Viewer
View and query CSV, Parquet, JSON, Arrow, and Excel files with SQL support and vim-style keybindings.

```bash
tw data.csv                        # Open CSV file
tw data.parquet                    # Open Parquet file
tw *.csv                           # Open multiple files as tabs
curl -s "url/data.csv" | tw        # Pipe data from curl
# Inside: Use SQL with :Q SELECT * FROM df WHERE col > 100
```

**Use cases:** Data exploration, quick CSV/Parquet viewing, SQL queries on files, data analysis

---

##### 📝 **glow & dawn** - Markdown Tools
**glow** renders markdown beautifully in the terminal. **dawn** is a distraction-free markdown editor with live preview.

```bash
# glow - Read/view markdown
glow README.md                     # Render markdown with styling
glow -p README.md                  # Pager mode (scrollable)
glow -w 80 README.md               # Set width
glow .                             # Browse markdown files in directory

# dawn - Write markdown
dawn                               # Open editor
dawn notes.md                      # Edit specific file
# Inside: Split-pane with editor on left, live preview on right
```

**Use cases:** Reading docs in terminal, writing notes, distraction-free writing, markdown preview

---

##### ⚡ **hyperfine** - Benchmarking Tool
Measure and compare command execution time with statistical analysis.

```bash
hyperfine 'command1' 'command2'    # Compare two commands
hyperfine --runs 10 'your_command' # Run benchmark 10 times
hyperfine --show-output 'cmd'      # Show command output while benchmarking
```

**Use cases:** Performance comparison, optimization validation, CI/CD benchmarking

---

##### 👁️ **watchexec** - File Watcher
Execute commands when files change. Auto-run tests, rebuild projects, restart servers.

```bash
watchexec -e py -- pytest              # Run tests on .py changes
watchexec -e rs -- cargo build         # Rebuild on Rust file changes
watchexec --restart -- python server.py # Restart server on changes
watchexec -w src -w tests -- make      # Watch multiple directories
watchexec -c -e js,ts -- npm test      # Clear screen, watch js/ts
```

**Use cases:** Auto-testing, live reload, build automation, development workflow

---

##### 🌐 **httpie** - Better HTTP Client
Human-friendly HTTP CLI client (better than curl).

```bash
http GET example.com               # Simple GET request
http --auth user:pass POST httpbin.org/post name=value  # POST with auth
http --headers GET github.com      # Show only headers
http < request.json POST httpbin.org/post  # Send from file
```

**Use cases:** API testing, REST debugging, quick HTTP requests, webhook testing

---

##### 🐧 **lima** - Linux VMs on macOS
Run Linux virtual machines natively on macOS. Lighter than Docker Desktop, uses Apple's Virtualization.framework.

```bash
limactl start                      # Start default Ubuntu VM
limactl start --name=arch archlinux # Start Arch Linux VM
lima                               # Open shell in default VM
lima nerdctl run -it alpine        # Run containers (like docker)
lima nerdctl compose up            # Docker Compose equivalent
limactl list                       # List VMs
limactl stop default               # Stop VM
```

**Why lima over Docker Desktop:**
- Native Apple virtualization (fast, low overhead)
- Automatic file sharing and port forwarding
- No Docker Desktop license needed
- `nerdctl` is Docker-compatible CLI

**Use cases:** Running Linux tools, container development, testing Linux-specific code, Docker alternative

---

##### 🔄 **scooter** - Interactive Find-and-Replace
Interactive terminal UI for find-and-replace operations with preview, regex support, and editor integration.

```bash
scooter                            # Open scooter in current directory
scooter ../path/to/dir             # Search in specific directory
echo "text" | scooter              # Process stdin
scooter --search-text "old" --replace-text "new" --immediate-search  # Pre-populate fields
```

**Key features:**
- **Interactive toggling**: Select which instances to replace using spacebar
- **Regex & fixed strings**: Switch between regex patterns and literal string matching
- **Capture groups**: Use `(\d)` in search and `$1` in replacement
- **Editor integration**: Press `e` to open selected file at the correct line in your `$EDITOR`
- **Respects .gitignore**: Automatically ignores files per your `.gitignore` and `.ignore`
- **Glob filtering**: Include/exclude files using glob patterns (e.g., `*.rs,*.py`)
- **Performance**: Built on ripgrep's file walker for blazing-fast searches

**Workflow example:**
```vim
scooter                           " Open scooter
# Type search pattern, replacement, and toggle desired instances with space
# Press Enter to execute replacements
# Press e to open any file in your editor at that line
```

**Use cases:** Refactoring code, bulk renaming, updating imports, batch text replacements

</details>

<details><summary>🐱 Shortcat - Keyboard-Driven UI Navigation</summary>

Navigate macOS applications entirely with your keyboard using Shortcat. Perfect for:
- Clicking buttons, links, and UI elements without a mouse
- Speeding up repetitive GUI tasks
- Accessibility and RSI prevention
- Vim-like navigation in any application

**Key Binding:**

| Shortcut | Description |
|----------|-------------|
| `Cmd + S` | Activate Shortcat search mode |

**How to Use:**
1. Press `Cmd + S` to activate Shortcat
2. Type to filter visible UI elements (buttons, links, menus)
3. Press `Enter` to click the highlighted element
4. Use arrow keys to navigate between matches

</details>

<details><summary>🔍 CLI Commands Reference</summary>

A curated collection of useful CLI commands for macOS, organized by *when* you need them.

### Debugging Port Conflicts

> Can't start your server? Something's already using the port.

```bash
lsof -i tcp:3000                 # Find what's hogging the port
kill -9 <pid>                    # Kill it

# Or one-liner: find and kill
lsof -ti tcp:3000 | xargs kill -9
```

### Investigating Processes

> What is this process doing? Where is it running from?

```bash
lsof -p <pid> | grep cwd         # Working directory of a process
lsof -i -nP                      # All network connections (debug connectivity)
ps aux | grep <name>             # Find process by name
```

### Command History Tricks

> Just typed a long command and forgot sudo? Use `sudo !!`

```bash
sudo !!                          # Run last command with sudo
!!                               # Repeat last command
!$                               # Reuse last argument: mv file.txt !$
^typo^fixed                      # Fix typo in last command
cd !$:h                          # cd to directory of last file argument
until !!; do :; done             # Retry flaky command until it works
```

### FZF Fuzzy Finding

> Can't remember the exact filename? Fuzzy find it.

```bash
nvim **<TAB>                     # Fuzzy find files to edit
cd **<TAB>                       # Fuzzy find directories to jump to
kill -9 **<TAB>                  # Fuzzy find process to kill
ssh **<TAB>                      # Fuzzy find SSH hosts
<Ctrl-r>                         # Search command history
```

### Keyboard Shortcuts

| Key | When to Use |
|-----|-------------|
| `Ctrl+C` | Stop runaway process |
| `Ctrl+Z` | Pause to do something else, resume with `fg` |
| `Ctrl+L` | Clear clutter, keep scrollback |
| `Ctrl+R` | "What was that command I ran last week?" |
| `Ctrl+A/E` | Jump to fix start/end of long command |
| `Ctrl+U` | Clear line and start over |
| `Ctrl+W` | Delete last word (fix typo faster) |
| `Ctrl+X Ctrl+E` | Command too complex? Edit in your editor |

### Scheduling & Automation

> Schedule tasks or set reminders without leaving the terminal.

```bash
echo "backup.sh" | at midnight   # Schedule one-time task
leave +15                        # Terminal reminder in 15 min
timeout 30s ./slow-script        # Kill if takes too long
watch -n 5 "kubectl get pods"    # Monitor every 5 seconds
```

### Piping & Process Substitution

> The power of Unix: chain commands together. Use `<()` to treat command output as a file.

```bash
# Classic pipes: output -> input
cat file | grep error | wc -l

# Process substitution: treat command output as a file
diff <(ls dir1) <(ls dir2)                    # Compare directory contents
comm -13 <(sort file1) <(sort file2)          # Lines only in file2
vimdiff <(curl -s url1) <(curl -s url2)       # Diff two URLs
paste <(cut -f1 data.tsv) <(cut -f3 data.tsv) # Combine columns

# Here-string: pass string as stdin (no echo pipe needed)
bc <<< "2^10"                    # Quick math: 1024
grep "error" <<< "$log_output"   # Search in variable
```

### File Search & Cleanup

> Find large files, remove empty directories, clean up the mess.

```bash
# Find files
grep -lir "TODO" .               # Which files contain "TODO"?
find . -size +100M               # Files over 100MB
find . -mtime +30 -delete        # Delete files older than 30 days
find . -type d -empty -delete    # Remove empty directories

# Quick operations
cp file{,.bak}                   # Backup: file -> file.bak
chmod $(stat -f%A src) dest      # Copy permissions from another file
touch ./-i                       # Create "-i" file: blocks accidental rm -rf *
```

### Batch Renaming

> Rename 100 files from `IMG_001.JPG` to `vacation_001.jpg` in one command.

```bash
# Pure bash: lowercase + spaces to underscores
for f in *; do
  mv "$f" "$(echo "$f" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')"
done

# Perl rename (brew install rename) - more powerful
rename 's/IMG_/vacation_/' *.JPG       # Prefix replacement
rename 'y/A-Z/a-z/' *                  # Lowercase all
rename 's/\.jpeg$/.jpg/i' *            # Normalize extensions
```

### Text Processing

> Parse logs, format data, count occurrences.

```bash
less +F app.log                  # Follow log (better than tail -f, can scroll)
tac file.txt                     # Reverse lines (last first)
column -s, -t data.csv           # Pretty-print CSV as table
sort file | uniq -c | sort -rn   # Count occurrences, most frequent first
curl -s "$url" | jq .            # Pretty-print JSON (or python3 -m json.tool)
```

### Log Monitoring

> Watch logs with timestamps and color-coded severity levels.

```bash
# Add timestamps to any output
tail -f app.log | while read line; do echo "$(date +%T) $line"; done

# Color-coded by severity (ERROR=red, WARN=yellow, rest=green)
tail -f app.log | awk '{
  ts = strftime("%T")
  if ($0 ~ /ERROR/) color="\033[31m"
  else if ($0 ~ /WARN/) color="\033[33m"
  else color="\033[32m"
  printf "\033[90m%s\033[0m %s%s\033[0m\n", ts, color, $0
}'
```

### Archives & Encryption

> Create encrypted backups. Will prompt for password.

```bash
# Create encrypted archive (will prompt for password)
tar czf - secret_folder | openssl enc -e -aes256 -pbkdf2 -out backup.enc

# Decrypt and extract
openssl enc -d -aes256 -pbkdf2 -in backup.enc | tar xzf -
```

### Git Essentials

> Stage smartly, clean up deleted files, find contributors.

```bash
git add -u                       # Stage only modified/deleted (not new files)
git rm $(git ls-files --deleted) # Remove all deleted files from git
git log --format='%aN' | sort -u # Who contributed to this repo?
git diff --name-only main        # What files changed vs main?
```

### Network Debugging

> Is it your network or the server? Test connectivity and ports.

```bash
curl ifconfig.me                 # What's my public IP?
curl 'wttr.in/copenhagen'        # Quick weather check
nc -zv host 443                  # Test if port is open
ssh-copy-id user@host            # Setup passwordless SSH

# Download stuff
wget -mkEpnp example.com         # Mirror entire website
wget --accept pdf -rl1 url       # Download only PDFs from page
```

### Session & Process Management

> Keep jobs running after you disconnect from SSH.

```bash
disown -a && exit                # Exit shell, keep background jobs running
nohup ./long-job.sh &            # Run immune to hangups
sudo -K                          # Clear sudo password (security habit)
```

### Bypassing & Shortcuts

> Alias getting in the way? Bypass it with `\` or `command`.

```bash
\ls                              # Run real ls, ignore alias
command ls                       # Same thing, more explicit
type ls                          # See what ls actually runs
some_command | :                 # Discard output (faster than >/dev/null)
```

### Debugging Scripts

> Script not working? Debug with `-x` or analyze with `shellcheck`.

```bash
bash -x script.sh                # Print each command as it runs
set -euo pipefail                # Strict mode: fail on errors
shellcheck script.sh             # Static analysis for bugs
```

### Quick Math & Conversions

```bash
bc <<< 'scale=2; 100/3'          # Division with decimals: 33.33
bc <<< 'obase=16; 255'           # Decimal to hex: FF
bc <<< 'obase=2; 42'             # Decimal to binary: 101010
printf '%d\n' 0xFF               # Hex to decimal: 255
```

### Vim Quick Commands

> Run shell commands and insert output without leaving vim.

```vim
:r !date                         " Insert current date
:r !curl -s api.example.com      " Insert API response
:%!jq .                          " Format entire buffer as JSON
:x                               " Save and quit (shorter than :wq)
```

### Security Hygiene

> Running sensitive commands? Disable history for this session.

```bash
unset HISTFILE                   # Don't save commands this session
read -s p; echo $p | md5 | base64 | cut -c-16  # Generate password from phrase
```

### Getting Help

> Multiple ways to get help, from official docs to community cheatsheets.

```bash
man <command>                    # Official manual
tldr <command>                   # Community examples (brew install tlrc)
curl cheat.sh/tar                # Cheatsheet from web
apropos "search term"            # Search all man pages
```

### Homebrew Maintenance

> Keep macOS tools updated and clean up old versions.

```bash
brew update && brew upgrade      # Update everything
brew cleanup --prune=all         # Remove old versions, free space
brew doctor                      # Diagnose issues
```

### Fun Stuff

> Impress coworkers or pretend to be hacking in a movie.

**ASCII Clock** - Looks cool on a spare monitor
```bash
while true; do clear; date +%T | figlet; sleep 1; done
```

**Matrix Effect** - The classic
```bash
printf '\033[32m'; while :; do
  for i in {1..16}; do
    (( RANDOM % 5 == 1 )) && printf '%d ' $((RANDOM%2)) || printf '  '
  done; echo
done
```

**Pretend to be busy** - When the boss walks by
```bash
cat /dev/urandom | hexdump -C | grep "ca fe"
```

> Some commands require Homebrew packages: `figlet`, `rename`, `wget`, `jq`

</details>

## Troubleshooting

> [!WARNING]
> Running into issues? Check these common problems first.

| Problem | Solution |
|---------|----------|
| Homebrew installation fails | Ensure Xcode Command Line Tools are installed first |
| Stow conflicts | Remove existing dotfiles before running stow |
| Permission errors | Grant Full Disk Access to your terminal |
| Python/Node issues | Check that uv and n are properly installed |
| Terminal theme issues | Restart terminal after font installation |

> [!TIP]
> Run `./install.sh --verbose` for detailed debugging output, or check `~/macos-setup.log` for error details.

**Useful resources:**
- [cheat.sh](https://cheat.sh/) - `curl https://cheat.sh/<command>`
- Command reference: `tldr <command>` (install with `brew install tlrc`)
- Vim help: `:help <topic>` or `:Telescope help_tags`

## Acknowledgements

Inspired by [Sara Pope's dotfiles](https://github.com/gretzky/dotfiles) and the broader dotfiles community.

---

*A fork focused on modern development workflows with Rust, Python, and AI tooling.*
