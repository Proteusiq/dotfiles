```
████████████████████████████████████████████████████████████████████████████████
████                                                                        ████
████   ┌──────────────────────────────────────────────────────────────┐     ████
████   │  prayson@_42 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │     ████
████   │  $ nvim Tools.md                                             │     ████
████   │   ▶ tools                                                    │     ████
████   │     • uv run                                                 │     ████
████   │     • gh issue list                                          │     ████
████   │                                                              │     ████
████   │   $ ▋                                                        │     ████
████   └──────────────────────────────────────────────────────────────┘     ████
████                                                                        ████
████               /\_/\                                                    ████
████              ( o.o )      fox@cli                                      ████
████               > ^ <                                                    ████
████              /  _  \                                                   ████
████             /__/ \__\                                                  ████
████                                                                        ████
████████████████████████████████████████████████████████████████████████████████

```
# Tools Reference

A comprehensive guide to all tools, utilities, and applications included in this dotfiles setup. Each tool is documented with its purpose, common usage patterns, and practical examples.

## Table of Contents

- [Development Tools](#development-tools)
  - [Version Control](#version-control)
  - [Infrastructure & Cloud](#infrastructure--cloud)
  - [Database Tools](#database-tools)
- [Command Line Utilities](#command-line-utilities)
  - [File Navigation & Search](#file-navigation--search)
  - [File Viewing & Processing](#file-viewing--processing)
  - [System Monitoring](#system-monitoring)
  - [Text Processing](#text-processing)
- [Terminal & Editors](#terminal--editors)
- [Neovim](#neovim)
- [Programming Languages](#programming-languages)
  - [Python](#python)
  - [Node.js & JavaScript](#nodejs--javascript)
  - [Go](#go)
  - [Rust](#rust)
- [AI & LLM Tools](#ai--llm-tools)
- [Productivity Applications](#productivity-applications)
- [Window Management](#window-management)
- [System Utilities](#system-utilities)

---

## Development Tools

### Version Control

#### git
The distributed version control system. Foundation for all source code management.

```bash
git status                    # Check working tree status
git add -p                    # Interactive staging
git commit -am "message"      # Stage and commit
git log --oneline -10         # Recent commits
```

#### gh (GitHub CLI)
Official GitHub CLI for managing repositories, issues, PRs, and more directly from the terminal.

```bash
gh repo clone owner/repo      # Clone a repository
gh pr create                  # Create a pull request
gh pr list                    # List open PRs
gh issue list                 # List issues
gh run list                   # View workflow runs
gh api repos/:owner/:repo     # Direct API access
```

**Use cases:** PR workflows, issue management, GitHub Actions monitoring, API scripting

#### gh-dash
Interactive GitHub dashboard TUI. View PRs, issues, and repository activity. Installed as gh extension.

```bash
gh dash                       # Open dashboard
```

| Key | Action |
|-----|--------|
| `j/k` | Navigate |
| `Enter` | View details |
| `/` | Search |
| `?` | Help |
| `q` | Quit |

**Use cases:** PR review, issue tracking, repository monitoring, GitHub activity overview

#### lazygit
A simple terminal UI for git commands. Makes complex git operations visual and intuitive.

```bash
lazygit                       # Open in current repo
```

| Key | Action |
|-----|--------|
| `space` | Stage/unstage file |
| `c` | Commit |
| `p` | Pull |
| `P` | Push |
| `b` | Branch operations |
| `s` | Stash |
| `?` | Help |

**Use cases:** Visual staging, interactive rebasing, conflict resolution, branch management

#### serie
Rich git commit graph visualization in the terminal with image rendering support.

```bash
serie                         # Open commit graph
serie --order topo            # Topological order
serie --order chrono          # Chronological order
serie --preload               # Preload images for smooth scrolling
```

| Key | Action |
|-----|--------|
| `j/k` | Navigate |
| `Enter` | Show commit details |
| `/` | Search |
| `?` | Help |

**Use cases:** Visualizing commit history, understanding branch structure, exploring complex git workflows

#### gitlogue
Cinematic git commit replay tool that turns your git history into an animated story with realistic typing animations and syntax highlighting.

```bash
gitlogue                      # Start screensaver mode
gitlogue --commit HEAD~5..HEAD # Replay commit range
gitlogue --commit abc123 --loop # Loop specific commit
gitlogue --author "john"      # Filter by author
gitlogue --theme dracula      # Use specific theme
gitlogue --speed 20           # Typing speed (ms/char)
gitlogue theme list           # List themes
```

**Use cases:** Screensaver, presentations, content creation, education, visualizing code evolution

#### git-lfs
Git Large File Storage. Handles large files (binaries, datasets, media) efficiently.

```bash
git lfs install               # Initialize in repo
git lfs track "*.psd"         # Track file pattern
git lfs ls-files              # List tracked files
```

#### git-filter-repo
Powerful tool for rewriting git history. Faster and safer than git-filter-branch.

```bash
git filter-repo --path src/   # Keep only src/ directory
git filter-repo --invert-paths --path secret.txt  # Remove file from history
```

**Use cases:** Removing sensitive data, splitting repositories, cleaning history

#### difftastic
Structural diff tool that understands syntax. Shows meaningful diffs, not just line changes.

```bash
difft file1.py file2.py       # Compare files
git diff --external-diff=difft # Use with git
```

**Use cases:** Code review, understanding changes in context, syntax-aware diffs

### Infrastructure & Cloud

#### terraform
Infrastructure as Code tool for provisioning cloud resources declaratively.

```bash
terraform init                # Initialize working directory
terraform plan                # Preview changes
terraform apply               # Apply changes
terraform destroy             # Tear down infrastructure
```

#### azure-cli
Microsoft Azure command-line interface for managing Azure resources.

```bash
az login                      # Authenticate
az account list               # List subscriptions
az vm list                    # List virtual machines
az group create -n mygroup -l eastus  # Create resource group
```

#### act
Run GitHub Actions locally. Test workflows without pushing to GitHub.

```bash
act                           # Run default event
act -l                        # List available jobs
act -j build                  # Run specific job
act pull_request              # Simulate PR event
```

**Use cases:** Testing workflows locally, debugging Actions, faster iteration

#### lima
Linux virtual machines on macOS. Uses Apple's Virtualization.framework for native performance.

```bash
limactl start                 # Start default Ubuntu VM
limactl start --name=dev debian  # Start named Debian VM
lima                          # Open shell in default VM
lima uname -a                 # Run command in VM
lima nerdctl run -d nginx     # Run containers (Docker-compatible)
lima nerdctl compose up       # Docker Compose equivalent
limactl list                  # List all VMs
limactl stop default          # Stop VM
limactl delete default        # Delete VM
```

| Command | Description |
|---------|-------------|
| `limactl start` | Start/create VM |
| `lima` | Shell into VM |
| `lima nerdctl` | containerd CLI (Docker-like) |
| `limactl stop` | Stop VM |
| `limactl delete` | Remove VM |

**Available templates:**
- `default` - Ubuntu with containerd
- `debian`, `archlinux`, `fedora`, `alpine`
- `docker` - Docker CE instead of containerd

**Why lima over Docker Desktop:**
- Native Apple virtualization (fast, low memory)
- No licensing restrictions
- Automatic file sharing (`~` mounted in VM)
- Automatic port forwarding

**Use cases:** Container development, Linux testing, Docker alternative, running Linux tools

### Database Tools

#### mongosh
MongoDB Shell. Interactive JavaScript interface for MongoDB.

```bash
mongosh                       # Connect to local MongoDB
mongosh "mongodb://host:port" # Connect to remote
```

```javascript
// Inside mongosh
show dbs                      // List databases
use mydb                      // Switch database
db.collection.find()          // Query documents
db.collection.insertOne({})   // Insert document
```

#### harlequin
Terminal-based SQL IDE with connection management and results formatting.

```bash
harlequin                     # Open SQL IDE
harlequin "duckdb://./data.db" # Connect to DuckDB
harlequin "sqlite:///path.db" # Connect to SQLite
harlequin "postgres://..."    # Connect to PostgreSQL
```

| Key | Action |
|-----|--------|
| `Ctrl+j` | Run query |
| `Ctrl+n` | New buffer (editor tab) |
| `Ctrl+w` | Close buffer (editor tab) |
| `Ctrl+k` | Next buffer (editor tab) |
| `Ctrl+e` | Export results to CSV/Parquet/JSON |
| `Ctrl+s` | Save query to file |
| `Ctrl+o` | Open file in editor |
| `F2` | Focus Query Editor |
| `F5` | Focus Results Viewer |
| `F6` | Focus Data Catalog |
| `F9` | Toggle sidebar |
| `F10` | Toggle fullscreen |
| `j/k` | Switch tabs (in Results Viewer) |

See [harlequin.sh/docs/bindings](https://harlequin.sh/docs/bindings) for full keybindings reference. Might need `Shift+Ctrl`

**Use cases:** SQL development, database exploration, query testing, data analysis

#### tabiew
Lightweight TUI for viewing and querying tabular data files (CSV, Parquet, JSON, Arrow, Excel) with SQL support and vim-style keybindings.

```bash
tw data.csv                   # Open CSV file
tw data.parquet               # Open Parquet file
tw *.csv                      # Open multiple files as tabs
tw data.csv --separator '|'   # Custom delimiter
tw data.csv --no-header       # No header row
curl -s "url/data.csv" | tw   # Pipe from curl
```

| Key | Action |
|-----|--------|
| `h/j/k/l` | Navigate |
| `b/w` | Previous/next column |
| `g/G` | First/last row |
| `Ctrl+u/d` | Half page up/down |
| `e` | Toggle auto-fit |
| `/` | Fuzzy search |
| `:` | Command palette |
| `q` | Close tab |
| `Q` | Quit |

**Commands:**
```
:Q SELECT * FROM df WHERE price > 100    # SQL query
:S column1, column2                       # Select columns
:F price < 1000 AND qty > 5              # Filter rows
:O column DESC                            # Order by column
:schema                                   # Show loaded tables
:reset                                    # Reset to original data
```

**Use cases:** Data exploration, quick CSV/Parquet viewing, SQL queries on files, data analysis

---

## Command Line Utilities

### File Navigation & Search

#### fzf
Command-line fuzzy finder. Enables interactive filtering for any list.

```bash
# Basic usage
fzf                           # Interactive file finder
cat file | fzf                # Filter any input

# Integration with other commands
vim $(fzf)                    # Open selected file in vim
cd $(find . -type d | fzf)    # cd to selected directory

# Shortcuts (with shell integration)
Ctrl+r                        # Search command history
Ctrl+t                        # Paste selected file path
Alt+c                         # cd to selected directory
```

**Use cases:** File selection, history search, process killing, git operations

#### fd
A simple, fast alternative to find. User-friendly syntax and smart defaults.

```bash
fd                            # List all files
fd pattern                    # Find files matching pattern
fd -e py                      # Find by extension
fd -t d                       # Find directories only
fd -H                         # Include hidden files
fd pattern -x rm              # Execute command on results
```

**Use cases:** File searching, scripting, finding files by pattern

#### ripgrep (rg)
Extremely fast grep alternative. Respects .gitignore by default.

```bash
rg pattern                    # Search in current directory
rg pattern -t py              # Search only Python files
rg -i pattern                 # Case insensitive
rg -l pattern                 # List files only
rg -C 3 pattern               # Show 3 lines context
rg --json pattern             # JSON output
```

**Use cases:** Code search, log analysis, finding usages across codebase

#### eza
Modern replacement for ls with icons, git integration, and tree view.

```bash
eza                           # List files
eza -l                        # Long format
eza -la                       # Include hidden
eza --tree                    # Tree view
eza --icons                   # With icons
eza --git                     # Show git status
```

Aliases configured:
```bash
ls    # eza
ll    # eza -l
la    # eza -la
tree  # eza --tree
```

#### zoxide
Smarter cd command that learns your habits. Jump to frequently used directories.

```bash
z foo                         # Jump to best match for "foo"
z foo bar                     # Jump to best match for "foo bar"
zi                            # Interactive selection with fzf
zoxide query foo              # Show match without jumping
```

**Use cases:** Quick directory navigation, reducing cd path typing

#### yazi
Blazing fast terminal file manager with image preview support.

```bash
yazi                          # Open file manager
yazi /path/to/dir             # Open specific directory
```

| Key | Action |
|-----|--------|
| `j/k` | Navigate up/down |
| `h/l` | Parent/enter directory |
| `Enter` | Open file |
| `y` | Yank (copy) |
| `p` | Paste |
| `d` | Delete |
| `a` | Create file |
| `r` | Rename |
| `space` | Select |
| `/` | Search |
| `q` | Quit |

**Use cases:** File browsing, bulk operations, preview files without opening

#### broot
Interactive tree view with search. Navigate and operate on directory structures.

```bash
broot                         # Open in current directory
br                            # Shortcut (if configured)
```

| Key | Action |
|-----|--------|
| Type | Filter/search |
| `Enter` | cd to directory |
| `alt+Enter` | Open in $EDITOR |
| `ctrl+q` | Quit |

### File Viewing & Processing

#### bat
A cat clone with syntax highlighting, line numbers, and git integration.

```bash
bat file.py                   # View with highlighting
bat -l json data              # Force language
bat -p file                   # Plain output (no decorations)
bat -A file                   # Show non-printable characters
bat --diff file               # Show git diff
```

Alias configured: `cat` -> `bat`

#### jq
Lightweight command-line JSON processor.

```bash
jq '.' file.json              # Pretty print
jq '.key' file.json           # Extract key
jq '.items[]' file.json       # Iterate array
jq -r '.name' file.json       # Raw output (no quotes)
jq 'keys' file.json           # List keys
curl api | jq '.data'         # Process API response
```

**Use cases:** API responses, JSON configuration, data transformation

#### ncdu
NCurses disk usage analyzer. Interactive exploration of disk space.

```bash
ncdu                          # Analyze current directory
ncdu /path                    # Analyze specific path
ncdu -x /                     # Exclude other filesystems
```

| Key | Action |
|-----|--------|
| `j/k` | Navigate |
| `Enter` | Enter directory |
| `d` | Delete |
| `g` | Show percentage/graph |
| `q` | Quit |

Alias configured: `du` -> `ncdu`

#### lnav
Log file navigator. View and analyze log files with filtering and highlighting.

```bash
lnav /var/log/system.log      # View specific log
lnav                          # Interactive picker
lnav -r                       # Recursive directory
```

| Key | Action |
|-----|--------|
| `j/k` | Navigate |
| `/` | Search |
| `:` | Command mode |
| `i` | Toggle histogram |
| `q` | Quit |

**Use cases:** Debug application errors, monitor system logs, analyze multiple logs

### System Monitoring

#### btop
Resource monitor with CPU, memory, disks, network, and processes.

```bash
btop                          # Open monitor
```

| Key | Action |
|-----|--------|
| `h` | Help |
| `m` | Toggle memory display |
| `n` | Toggle network display |
| `d` | Toggle disk display |
| `e` | Tree view |
| `f` | Filter processes |
| `k` | Kill process |
| `q` | Quit |

Alias configured: `top` -> `btop`

#### hyperfine
Command-line benchmarking tool with statistical analysis.

```bash
hyperfine 'command'           # Benchmark single command
hyperfine 'cmd1' 'cmd2'       # Compare commands
hyperfine --runs 10 'cmd'     # Specify run count
hyperfine --warmup 3 'cmd'    # Warmup runs
hyperfine --export-json r.json 'cmd'  # Export results
```

**Use cases:** Performance comparison, optimization validation, CI benchmarking

#### watchexec
File watcher that executes commands on changes. Respects `.gitignore`, supports debouncing, handles process restarts.

```bash
watchexec -e py -- pytest             # Run tests on .py changes
watchexec -e rs -- cargo build        # Rebuild on Rust changes
watchexec --restart -- python app.py  # Restart long-running process
watchexec -w src -w tests -- make     # Watch multiple directories
watchexec -c -e js,ts -- npm test     # Clear screen between runs
watchexec -f '*.md' -- glow README.md # Watch specific pattern
watchexec --ignore dist -- npm build  # Ignore directory
```

| Flag | Description |
|------|-------------|
| `-e ext` | Filter by extension |
| `-w path` | Watch specific path |
| `-f pattern` | Filter by glob pattern |
| `--ignore` | Ignore paths |
| `-c` | Clear screen before each run |
| `--restart` | Restart process on change |
| `--debounce ms` | Debounce time (default 50ms) |
| `-n` | No default ignores |

**Use cases:** Auto-testing, live reload, build automation, development workflow

### Text Processing

#### GNU coreutils
GNU versions of standard Unix utilities. More features than macOS defaults.

Configured aliases include:
```bash
cp      # gcp -v
mv      # gmv -v
rm      # grm -v
mkdir   # gmkdir -v
chmod   # gchmod -v
chown   # gchown -v
```

#### vhs
Record terminal sessions as GIFs. Write a simple script to automate your recording.

```bash
vhs record                    # Interactive recording
vhs demo.tape                 # Run tape file and generate GIF
vhs new demo.tape             # Create new tape file template
vhs validate demo.tape        # Validate tape syntax
vhs publish demo.gif          # Share recording via vhs.charm.sh
```

**Tape file example:**
```
Output demo.gif
Set FontSize 14
Set Width 1200
Set Height 600

Type "echo 'Hello, World!'"
Enter
Sleep 2s
```

**Use cases:** Documentation, tutorials, bug reports, showcasing CLI tools, README demos

#### scooter
Interactive find-and-replace in the terminal with preview.

```bash
scooter                       # Open in current directory
scooter /path/to/dir          # Search specific directory
scooter --search-text "old" --replace-text "new"  # Pre-populate
```

| Key | Action |
|-----|--------|
| Type | Filter matches |
| `space` | Toggle instance |
| `Enter` | Execute replacements |
| `e` | Open in editor |

**Use cases:** Refactoring, bulk renaming, batch text replacements

#### rename
Perl-based rename with regex support.

```bash
rename 's/\.txt$/.md/' *.txt  # Change extensions
rename 'y/A-Z/a-z/' *         # Lowercase filenames
rename 's/ /_/g' *            # Replace spaces with underscores
```

---

## Terminal & Editors

### dawn
Distraction-free writing environment with live markdown rendering. Renders markdown as you type: headers scale up, math becomes Unicode art, images appear inline. Pairs with [glow](#glow) for reading.

```bash
dawn                          # Start new writing session
dawn document.md              # Open existing file
dawn -p document.md           # Preview mode (read-only)
dawn -P document.md           # Print rendered output to stdout
```

| Key | Action |
|-----|--------|
| `Ctrl+F` | Toggle focus mode |
| `Ctrl+R` | Toggle raw markdown |
| `Ctrl+L` | Table of contents |
| `Ctrl+S` | Search |
| `Ctrl+N` | Jump to/create footnote |
| `Ctrl+Z` | Undo |
| `Ctrl+Y` | Redo |
| `Ctrl+H` | Show all shortcuts |
| `Esc` | Close panel/modal |

**Features:**
- Live markdown rendering (headers, bold, italic, code, blockquotes, lists)
- LaTeX math expressions as Unicode art
- Syntax highlighting for 35+ languages
- Tables with Unicode box-drawing
- Writing timer for flow sessions
- Light and dark themes

**Use cases:** Distraction-free writing, drafting documents, markdown editing, focused writing sessions

### glow
Terminal markdown viewer. Renders markdown beautifully in the terminal - the reader complement to dawn's writer.

```bash
glow README.md                # Render markdown with styling
glow -p README.md             # Pager mode (scrollable like less)
glow -w 80 README.md          # Set max width
glow .                        # Browse and select markdown files
glow -s dark README.md        # Use dark style
glow -s light README.md       # Use light style
```

| Key | Action |
|-----|--------|
| `j/k` or `↓/↑` | Scroll down/up |
| `d/u` | Half page down/up |
| `g/G` | Go to top/bottom |
| `/` | Search |
| `q` | Quit |

**glow vs dawn:**
- **glow** = Read markdown (viewer, like `less` for markdown)
- **dawn** = Write markdown (editor with live preview)

**Use cases:** Reading READMEs in terminal, browsing documentation, quick markdown preview

### ghostty
GPU-accelerated terminal emulator. Fast, feature-rich, and highly configurable.

Configuration: `~/.config/ghostty/config`

**Use cases:** Primary terminal emulator, tmux integration

### tmux
Terminal multiplexer. Manage multiple terminal sessions in one window.

```bash
tmux                          # Start new session
tmux new -s name              # Named session
tmux ls                       # List sessions
tmux attach -t name           # Attach to session
tmux kill-session -t name     # Kill session
```

Leader key: `Ctrl+b`

| Binding | Action |
|---------|--------|
| `leader + c` | New window |
| `leader + n` | Next window |
| `leader + p` | Previous window |
| `leader + "` | Horizontal split |
| `leader + %` | Vertical split |
| `leader + hjkl` | Navigate panes |
| `leader + z` | Zoom pane |
| `leader + d` | Detach |
| `leader + I` | Install plugins |

Aliases:
```bash
iexit   # Kill current session
ikill   # Kill all sessions
iswitch # Interactive session switcher
```

### sesh
Smart session manager for tmux. Quick switching between projects.

```bash
sesh connect project          # Connect to or create session
sesh list                     # List sessions
```

Configuration: `~/.config/sesh/sesh.toml`

### starship
Minimal, fast, customizable prompt for any shell.

Configuration: `~/.config/starship/starship.toml`

---

## Neovim

Hyperextensible text editor built on Vim. Configured with [LazyVim](https://www.lazyvim.org/) as the base distribution.

```bash
nvim file                     # Open file
nvim +42 file                 # Open at line 42
nvim -d file1 file2           # Diff mode
```

Configuration: `~/.config/nvim/`

Alias: `n` -> `nvim`

### Vim Grammar: Speaking the Language

The key to mastering Vim is understanding its grammar. Vim commands follow a simple rule:

```
verb + noun
```

Or more specifically:

```
[count] + operator + [count] + motion/text-object
```

Once you learn this pattern, you stop memorizing commands and start *composing* them.

**Verbs (Operators)** - What you want to do:

| Operator | Action |
|----------|--------|
| `d` | Delete |
| `c` | Change (delete + insert mode) |
| `y` | Yank (copy) |
| `v` | Visual select |
| `gu` | Lowercase |
| `gU` | Uppercase |
| `>` | Indent right |
| `<` | Indent left |
| `=` | Auto-indent |

**Nouns (Motions)** - Where to apply the action:

| Motion | Meaning |
|--------|---------|
| `w` | Word forward |
| `b` | Word backward |
| `e` | End of word |
| `0` | Start of line |
| `$` | End of line |
| `^` | First non-blank |
| `gg` | Start of file |
| `G` | End of file |
| `}` | Next paragraph |
| `{` | Previous paragraph |
| `f{char}` | Find character forward |
| `t{char}` | Till character forward |
| `/pattern` | Search forward |

**Text Objects** - Structured nouns:

| Object | Meaning |
|--------|---------|
| `iw` | Inner word |
| `aw` | Around word |
| `i"` | Inner quotes |
| `a"` | Around quotess |
| `i(` | Inner parentheses |
| `a(` | Around parentheses |
| `i{` | Inner braces |
| `it` | Inner tag (HTML/XML) |
| `ip` | Inner paragraph |
| `is` | Inner sentence |

> also i" == iq 

**Examples - Composing Commands:**

```
dw      = delete word
d$      = delete to end of line
d3w     = delete 3 words
diw     = delete inner word (word under cursor)
di"     = delete inside quotes
da(     = delete around parentheses (including parens)
ci{     = change inside braces
yap     = yank a paragraph
gUiw    = uppercase inner word
>ip     = indent paragraph
```

**The Power of Composition:**

If you know 5 operators and 10 motions, you have 50 commands. Learn one new motion, gain 5 more commands. This is why Vim scales - knowledge multiplies.

```
Operators (5) x Motions (10) = Commands (50)
```

**Double Operator = Line Operation:**

| Command | Action |
|---------|--------|
| `dd` | Delete line |
| `yy` | Yank line |
| `cc` | Change line |
| `>>` | Indent line |
| `gUU` | Uppercase line |

**The Dot Command (`.`):**

Repeats your last change. This is why Vim users prefer `ciw` over `bcw` - it creates a repeatable atomic action.

```
ciw     + new text + Esc    -> .  repeats "change word to new text"
```

### Motions & Navigation

| Key | Action |
|-----|--------|
| `h/j/k/l` | Left/Down/Up/Right |
| `w/W` | Next word/WORD |
| `b/B` | Previous word/WORD |
| `e/E` | End of word/WORD |
| `0/$` | Start/End of line |
| `^` | First non-blank character |
| `gg/G` | Start/End of file |
| `{number}G` | Go to line number |
| `Ctrl+d/u` | Half page down/up |
| `Ctrl+f/b` | Full page down/up |
| `%` | Jump to matching bracket |
| `f{char}` | Find character (inclusive) |
| `t{char}` | Till character (exclusive) |
| `F{char}` | Find backward |
| `T{char}` | Till backward |
| `;/,` | Repeat f/t forward/backward |
| `/{pattern}` | Search forward |
| `?{pattern}` | Search backward |
| `n/N` | Next/Previous search result |
| `*/#` | Search word under cursor |

### File & Buffer Management

| Key | Action |
|-----|--------|
| `<leader><leader>` | Find files |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep search |
| `<leader>fb` | Buffer list |
| `<leader>fh` | Help tags |
| `<leader>e` | File explorer (neo-tree) |
| `<leader>-` | Yazi file manager |
| `<leader>bd` | Delete buffer |
| `<leader>.` | Scratch buffer |

### Harpoon (Quick File Access)

| Key | Action |
|-----|--------|
| `<leader>a` | Add file to harpoon |
| `<leader>1-5` | Jump to harpoon file 1-5 |

### Git Integration

| Key | Action |
|-----|--------|
| `<leader>gg` | Open Lazygit |
| `<leader>gf` | File history (Lazygit) |
| `<leader>Gh` | File history (Telescope) |
| `<leader>gl` | Git log |
| `<leader>gb` | Blame line |
| `<leader>gB` | Browse on GitHub |

### Code Navigation (LSP)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>ca` | Code actions |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format code |
| `<leader>cd` | Line diagnostics |
| `<leader>nv` | Navbuddy symbol tree |
| `]d/[d` | Next/Previous diagnostic |

### Testing

| Key | Action |
|-----|--------|
| `<leader>tt` | Run nearest test |
| `<leader>tT` | Run file tests |
| `<leader>tr` | Run last test |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Show test output |
| `<leader>tS` | Stop tests |

### Debugging (DAP)

| Key | Action |
|-----|--------|
| `<leader>dm` | Debug test method |
| `<leader>dc` | Debug test class |
| `<leader>df` | Debug file |
| `<leader>du` | Debug function |
| `<leader>dk` | Debug class |

### AI Integration (OpenCode)

| Key | Action |
|-----|--------|
| `<leader>oa` | Ask about code |
| `<leader>os` | Select prompt |
| `<leader>o+` | Add context |
| `<leader>ot` | Toggle panel |
| `<leader>oc` | Select command |
| `<leader>on` | New session |
| `<leader>oi` | Interrupt |
| `<leader>oA` | Cycle agent |

### UI Toggles

| Key | Action |
|-----|--------|
| `<leader>us` | Toggle spelling |
| `<leader>uw` | Toggle word wrap |
| `<leader>uL` | Toggle relative numbers |
| `<leader>ud` | Toggle diagnostics |
| `<leader>ul` | Toggle line numbers |
| `<leader>uT` | Toggle treesitter |
| `<leader>ub` | Toggle dark/light mode |
| `<leader>uh` | Toggle inlay hints |
| `<leader>n` | Notification history |
| `<leader>N` | Neovim news |

### Text Manipulation

| Key | Action |
|-----|--------|
| `ys{motion}{char}` | Add surround |
| `cs{old}{new}` | Change surround |
| `ds{char}` | Delete surround |
| `gc{motion}` | Toggle comment |
| `gcc` | Comment line |
| `>>/<<` | Indent/Unindent |
| `J` | Join lines |
| `.` | Repeat last action |

### Multi-cursor

| Key | Action |
|-----|--------|
| `Ctrl+n` | Select word, add cursor |
| `Ctrl+Up/Down` | Add cursor above/below |
| `<leader>x` | Delete cursor |

### Splits & Windows

| Key | Action |
|-----|--------|
| `<leader>\|` | Vertical split |
| `<leader>-` | Horizontal split |
| `Ctrl+h/j/k/l` | Navigate splits |
| `<leader>wd` | Delete window |

### Installed Plugins

Key plugins in this configuration:

| Plugin | Purpose |
|--------|---------|
| **LazyVim** | Base distribution |
| **Telescope** | Fuzzy finder |
| **neo-tree** | File explorer |
| **Harpoon** | Quick file marks |
| **Yazi** | Terminal file manager |
| **Lazygit** | Git UI |
| **nvim-dap** | Debugger |
| **nvim-cmp** | Autocompletion |
| **Treesitter** | Syntax highlighting |
| **Mason** | LSP installer |
| **Snacks** | UI utilities |
| **Catppuccin** | Color scheme |

---

## Programming Languages

### Python

#### uv
Extremely fast Python package manager, project manager, and resolver written in Rust. Replaces pip, pip-tools, pipx, poetry, pyenv, and virtualenv.

**Creating Projects**
```bash
uv init                       # Initialize project in current directory
uv init myproj                # Initialize project in myproj/
uv init --app --package       # Initialize packageable app (CLI, web app)
uv init --lib --package       # Initialize packageable library
uv init --python 3.12         # Use specific Python version
```

**Managing Dependencies**
```bash
uv add requests               # Add dependency
uv add pytest --dev           # Add dev dependency
uv add -r requirements.txt    # Add from requirements file
uv remove requests            # Remove dependency
uv tree                       # Show dependency tree
uv lock --upgrade             # Upgrade all dependencies
```

**Running Code**
```bash
uv run python                 # Run Python in project environment
uv run pytest                 # Run pytest
uv run --with rich python     # Run with additional package
uv run --with bpython bpython # Run bpython REPL
uv run --python 3.11 python   # Run with specific Python version
```

**Tools (like pipx)**
```bash
uvx ruff check .              # Run tool without installing (alias for uv tool run)
uvx --from textual textual-demo  # Run command from specific package
uv tool install ruff          # Install tool globally
uv tool install --with plugins pkg  # Install with extra dependencies
uv tool list                  # List installed tools
uv tool upgrade ruff          # Upgrade specific tool
uv tool upgrade --all         # Upgrade all tools
uv tool uninstall ruff        # Uninstall tool
```

**Scripts with Inline Dependencies**
```bash
uv init --script myscript.py  # Initialize script with metadata
uv add click --script myscript.py  # Add dependency to script
uv run myscript.py            # Run script (installs deps automatically)
```

Add shebang to make scripts executable: `#!/usr/bin/env -S uv run`

**Python Version Management**
```bash
uv python list                # List installed and available versions
uv python install 3.12        # Install Python version
uv python uninstall 3.11      # Uninstall Python version
uv python pin 3.12            # Pin project to Python version
```

**Project Lifecycle**
```bash
uv build                      # Build packageable project
uv publish                    # Publish to PyPI
uv version                    # Check project version
uv version --bump minor       # Bump version
```

**Use cases:** Project management, dependency resolution, running scripts, tool management, Python version management

#### pixi
Fast package manager for conda environments. Like Poetry for the conda world.

```bash
pixi init                     # Initialize project
pixi add numpy                # Add dependency
pixi run python script.py     # Run in environment
pixi shell                    # Activate environment
```

**Use cases:** Data science projects, conda ecosystem, reproducible environments

### Node.js & JavaScript

#### node
JavaScript runtime built on Chrome's V8 engine.

```bash
node script.js                # Run JavaScript
node -e "console.log('hi')"   # Evaluate expression
node --inspect script.js      # Debug mode
```

#### bun
Fast all-in-one JavaScript runtime, bundler, and package manager.

```bash
bun run script.ts             # Run TypeScript directly
bun install                   # Install dependencies
bun add package               # Add dependency
bun build ./src/index.ts      # Bundle
bun test                      # Run tests
```

**Use cases:** Fast package installs, TypeScript execution, bundling

#### yarn
Fast, reliable dependency management.

```bash
yarn                          # Install dependencies
yarn add package              # Add dependency
yarn run script               # Run script
```

Aliases:
```bash
y     # yarn
ya    # yarn add
yad   # yarn add --dev
yr    # yarn run
ys    # yarn start
yt    # yarn test
```

### Go

#### go
The Go programming language. Compiled, statically typed.

```bash
go run main.go                # Run program
go build                      # Compile
go test                       # Run tests
go mod init                   # Initialize module
go get package                # Add dependency
```

### Rust

#### rust (rustc, cargo)
Systems programming language focused on safety and performance.

```bash
cargo new project             # Create project
cargo build                   # Compile
cargo run                     # Build and run
cargo test                    # Run tests
cargo add package             # Add dependency
rustc --version               # Check version
```

---

## AI & LLM Tools

### opencode
Open source AI coding agent with terminal UI, desktop app, and IDE extensions. Neovim-inspired interface for AI pair programming.

```bash
opencode                      # Start TUI in current project
opencode -c                   # Continue last session
opencode -s <id>              # Continue specific session
opencode -m anthropic/claude  # Use specific model
opencode run "prompt"         # Non-interactive mode
opencode run -f file.py "explain this"  # Attach files
opencode serve                # Start headless server
opencode models               # List available models
opencode auth login           # Configure API keys
opencode upgrade              # Update to latest version
```

| Key | Action |
|-----|--------|
| `Ctrl+x` | Leader key |
| `<leader>n` | New session |
| `<leader>l` | List sessions |
| `<leader>m` | List models |
| `<leader>a` | List agents |
| `<leader>t` | List themes |
| `<leader>b` | Toggle sidebar |
| `<leader>u` | Undo changes |
| `<leader>r` | Redo changes |
| `<leader>y` | Copy messages |
| `<leader>c` | Compact context |
| `Tab` | Cycle agent (Plan/Build mode) |
| `Escape` | Interrupt |
| `@` | Fuzzy find files |
| `Ctrl+p` | Command list |

**Commands:**
- `/init` - Initialize project (creates AGENTS.md)
- `/undo` - Undo last changes
- `/redo` - Redo changes
- `/share` - Share conversation link
- `/connect` - Configure provider API keys

**Modes:**
- **Build mode** - AI makes changes to code
- **Plan mode** (Tab) - AI suggests implementation without editing

Configuration: `~/.config/opencode/opencode.json`

**Use cases:** AI pair programming, code generation, refactoring, learning codebases

### ollama
Run large language models locally.

```bash
ollama run llama2             # Run model
ollama list                   # List installed models
ollama pull mistral           # Download model
ollama serve                  # Start server
```

**Use cases:** Local AI, privacy-focused LLM usage, offline development

### llm
CLI tool for interacting with LLMs. Supports multiple providers.

```bash
llm "What is Python?"         # Query default model
llm -m gpt-4 "prompt"         # Specify model
llm -t cmd "list files"       # Use template
llm chat                      # Interactive chat
llm models                    # List models
```

Installed via: `uv tool install llm`

Configured templates:
- `cmd` - Linux terminal commands
- `nvim` - Neovim commands

### llama.cpp
LLM inference in C/C++. Run models efficiently on CPU.

```bash
llama-cli -m model.gguf -p "prompt"  # Run inference
```

### LM Studio
Desktop app for running local LLMs with a UI. Better than Ollama + Open WebUI combined.

**Use cases:** Local LLM experimentation, model comparison, GUI-based AI

---

## Productivity Applications

### 1Password
Password manager with CLI integration.

```bash
op signin                     # Authenticate
op item get "item name"       # Retrieve item
op read "op://vault/item/field"  # Read secret
```

### Raycast
Spotlight replacement with extensibility. Launcher, snippets, clipboard history.

Default shortcut: `Cmd + Space`

**Use cases:** App launching, snippets, window management, calculations

### espanso
Cross-platform text expander. Type abbreviations, get expansions.

```yaml
# Example config
matches:
  - trigger: ":email"
    replace: "user@example.com"
```

**Use cases:** Email templates, code snippets, common phrases

### Shortcat
Keyboard-driven UI navigation. Click any button with your keyboard.

Shortcut: `Cmd + Shift + Space` (configurable)

**Use cases:** Mouseless workflow, accessibility, RSI prevention

### hiddenbar
Hide menu bar items. Keep your menu bar clean.

### Notion
Note-taking and knowledge management.

### CleanShot
Screenshot and screen recording tool with annotation.

### Alt-Tab
Windows-style alt-tab window switcher for macOS.

---

## Window Management

### AeroSpace
Tiling window manager for macOS. i3-like experience.

Configuration: `~/.config/aerospace/aerospace.toml`

| Key | Action |
|-----|--------|
| `alt + h/j/k/l` | Focus window |
| `alt + shift + h/j/k/l` | Move window |
| `alt + 1-9` | Switch workspace |
| `alt + shift + 1-9` | Move to workspace |

**Use cases:** Tiling window management, keyboard-driven workflow

### skhd
Simple hotkey daemon for macOS. Define custom keyboard shortcuts.

Configuration: `~/.config/skhd/skhdrc`

---

## System Utilities

### stow
Symlink farm manager. Manages dotfiles by creating symlinks.

```bash
stow -d ~/dotfiles -t ~ zsh   # Stow zsh config
stow -D zsh                   # Unstow
stow --adopt zsh              # Adopt existing files
```

**Use cases:** Dotfiles management, keeping configs in git

### direnv
Load/unload environment variables based on directory.

```bash
# Create .envrc in project directory
echo 'export API_KEY=xxx' > .envrc
direnv allow                  # Allow the envrc
```

**Use cases:** Per-project environment, secrets management, auto-activation

### thefuck
Corrects your previous console command.

```bash
fuck                          # Correct last command
```

Alias configured: `f` -> `fuck`

### tldr (tlrc)
Official tldr client written in Rust. Simplified man pages with practical examples.

```bash
tldr tar                      # Show tar examples
tldr git commit               # Show git commit examples
tldr --update                 # Update page cache
```

Installed via: `brew install tlrc` (installs as `tldr`)

### wireguard-tools
Tools for WireGuard VPN.

```bash
wg                            # Show interface status
wg-quick up wg0               # Bring up interface
wg-quick down wg0             # Bring down interface
```

### AlDente
Battery charge limiter for MacBooks. Extends battery lifespan.

### Lulu
macOS firewall. Block unknown outgoing connections.

### Flux
Adjusts display color based on time of day. Reduces eye strain.

---

## Fonts

Installed fonts:
- **Hack** - Monospace font designed for source code
- **Hack Nerd Font** - Hack with additional glyphs/icons
- **Symbols Only Nerd Font** - Just the icons (for yazi)

---

## Additional Tools from install.sh

### Bun
Installed via: `curl -fsSL https://bun.sh/install | bash`

### goose
AI agent for automated coding tasks.

Installed via: install.sh

### repgrep (rgr)
Interactive ripgrep. Browse search results in a TUI.

```bash
rgr pattern                   # Interactive search
```

Installed via: `cargo install repgrep`

---

## Quick Reference

### File Operations
| Task | Command |
|------|---------|
| Find files | `fd pattern` |
| Search content | `rg pattern` |
| Fuzzy find | `fzf` |
| List files | `eza -la` |
| Disk usage | `ncdu` |
| File manager | `yazi` |

### Git Operations
| Task | Command |
|------|---------|
| Status | `gs` (git status) |
| Stage all | `gaa` (git add .) |
| Commit | `gc "message"` |
| Push | `gp` |
| Visual git | `lazygit` |
| Commit graph | `serie` |

### Development
| Task | Command |
|------|---------|
| New Python project | `uv init` |
| Add dependency | `uv add package` |
| Run Python | `uv run python` |
| Run tool once | `uvx ruff check .` |
| Run TypeScript | `bun run file.ts` |

### System
| Task | Command |
|------|---------|
| Process monitor | `btop` |
| Benchmark | `hyperfine 'cmd'` |
| Correct command | `fuck` |
| Quick docs | `tldr command` |
