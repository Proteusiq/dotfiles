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
  - [Code Quality & Security](#code-quality--security)
  - [Infrastructure & Cloud](#infrastructure--cloud)
  - [Database Tools](#database-tools)
- [Command Line Utilities](#command-line-utilities)
  - [File Navigation & Search](#file-navigation--search)
  - [File Viewing & Processing](#file-viewing--processing)
  - [System Monitoring](#system-monitoring)
  - [Text Processing](#text-processing)
- [Terminal & Editors](#terminal--editors)
  - [zsh & antidote](#zsh--antidote)
  - [atuin](#atuin)
- [Neovim](#neovim)
- [Programming Languages](#programming-languages)
  - [mise (runtime manager)](#mise-runtime-manager)
  - [Python](#python)
  - [Node.js & JavaScript](#nodejs--javascript)
  - [Go](#go)
  - [Rust](#rust)
- [AI & LLM Tools](#ai--llm-tools)
- [Productivity Applications](#productivity-applications)
- [Window Management](#window-management)
- [System Utilities](#system-utilities)
- [Fonts](#fonts)
- [Additional Tools](#additional-tools)
- [Dotfiles Management](#dotfiles-management)
- [Good Commands to Know](#good-commands-to-know)
- [Quick Reference](#quick-reference)

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

Configuration: `~/.config/git/config` (stow package `git`; there is no `~/.gitconfig`). Identity is not tracked: it comes from `~/.config/git/personal.gitconfig` or `work.gitconfig`, chosen by the repository's remote URL (`includeIf "hasconfig:remote.*.url:..."`). Commits and tags are signed with SSH keys. Git aliases defined there:

```bash
git l                         # Graph log, one line per commit
git ld                        # Graph log with relative dates and authors
git ll                        # Log with stats and patches
git branches                  # Remote branches by last commit date
git delete-merged             # Prune, then delete merged branches (keeps main/master/dev/develop/staging and the current branch)
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

#### git-delta
Pager for git with syntax highlighting. Set as git's pager (`core.pager = delta`) and for `git add -p` (`interactive.diffFilter = delta --color-only`), with `navigate`, `line-numbers` and the Catppuccin Mocha syntax theme.

```bash
git diff                      # Rendered by delta
git log -p                    # Patches rendered by delta
git show HEAD                 # Last commit rendered by delta
```

| Key | Action |
|-----|--------|
| `n` / `N` | Next / previous file or hunk (`navigate = true`) |
| `q` | Quit the pager |

`git diff` output stays a valid patch: no external diff tool is set globally.

#### difftastic
Structural diff tool that understands syntax. Shows meaningful diffs, not just line changes. Used on demand through git aliases in `~/.config/git/config`.

```bash
difft file1.py file2.py       # Compare two files
git dft                       # git difftool with difftastic (working tree changes)
git dft main                  # Structural diff against main
git dlog                      # git log -p with difftastic
git dshow                     # git show with difftastic
```

**Use cases:** Code review, understanding changes in context, syntax-aware diffs

### Code Quality & Security

#### prek
Fast git hooks runner, compatible with pre-commit's `.pre-commit-config.yaml`. This repository's hooks run gitleaks, shellcheck, shfmt, `zsh -n`, stylua, actionlint, ruff and a few built-in checks.

```bash
prek install                  # Once per clone: install the git hook shims
prek run --all-files          # Run every hook on all tracked files
prek run gitleaks             # Run one hook by id
prek list                     # List configured hooks
```

**Use cases:** Consistent checks before every commit, running the same checks as CI locally

#### gitleaks
Finds secrets (API keys, tokens, private keys) in files and git history. Runs as a prek hook on staged changes, and in CI over the full history.

```bash
gitleaks git .                # Scan every commit of the repository
gitleaks dir .                # Scan files on disk
```

**Use cases:** Catching leaked credentials before they are pushed, auditing old history

#### Other linters and formatters

| Tool | Purpose | Example |
|------|---------|---------|
| shellcheck | Shell linter | `shellcheck install.sh` |
| shfmt | Shell formatter | `shfmt -i 4 -w script.sh` |
| stylua | Lua formatter | `stylua nvim/` |
| actionlint | GitHub Actions linter | `actionlint` |
| biome | JS/TS linter and formatter | `biome check --write .` |
| bacon | Background Rust checker | `bacon clippy` |

ruff and ty are covered under [Python](#python).

### Infrastructure & Cloud

#### opentofu
Open-source, Terraform-compatible Infrastructure as Code tool. The command is `tofu`. Replaces terraform, which is no longer installed. Neovim formats Terraform files with `tofu fmt`.

```bash
tofu init                     # Initialize working directory
tofu plan                     # Preview changes
tofu apply                    # Apply changes
tofu destroy                  # Tear down infrastructure
tofu fmt                      # Format configuration files
```

#### azure-cli
Microsoft Azure command-line interface for managing Azure resources.

```bash
az login                      # Authenticate
az account list               # List subscriptions
az vm list                    # List virtual machines
az group create -n mygroup -l eastus  # Create resource group
az bicep build -f main.bicep  # Compile Bicep (installed by: update --only utils)
```

#### azd (Azure Developer CLI)
Provision and deploy applications to Azure from templates. Installed from the `azure/azd` tap.

```bash
azd auth login                # Authenticate
azd init                      # Initialize a new application
azd up                        # Provision and deploy in one command
azd provision                 # Provision Azure resources only
azd deploy                    # Deploy code only
azd down                      # Delete the project's Azure resources
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

#### resterm
Terminal-based API client for HTTP, GraphQL, gRPC, WebSocket, and SSE. Keyboard-driven with no cloud sync - everything stays local in `.http`/`.rest` files.

```bash
resterm                       # Open TUI in current directory
resterm init                  # Bootstrap new project with templates
resterm --workspace ./api     # Open specific workspace
resterm --from-curl cmd.txt   # Import curl commands
resterm --from-openapi spec.yaml  # Import OpenAPI spec
```

| Key | Action |
|-----|--------|
| `Ctrl+Enter` | Send request |
| `Tab` | Cycle panes (sidebar/editor/response) |
| `g+p` | Jump to response pane |
| `g+i` | Jump to editor pane |
| `Ctrl+E` | Switch environments |
| `Ctrl+G` | View captured globals |
| `g+c` | Compare responses (with `@compare`) |

**Features:**
- OAuth 2.0 with auto token refresh (client credentials, password, auth code + PKCE)
- SSH tunnels for HTTP/gRPC/WebSocket/SSE
- Workflows with `@workflow`/`@step` directives
- Request tracing and timeline visualization
- RestermScript (RTS) for templates and logic

**Use cases:** API testing, debugging webhooks, gRPC development, WebSocket testing

#### Containers: OrbStack, colima and the docker CLI
The Docker CLI (`docker`, `docker-compose`, `docker-buildx`) comes from Homebrew. The engine comes from one of:

- **OrbStack** (cask, default engine): Docker and Linux VMs for macOS. Start the app, then use `docker` as usual.
- **colima** (open-source alternative, built on Lima): start it with `colima start`.

```bash
docker run --rm hello-world   # Works with either engine
docker context ls             # Show which engine docker talks to
colima start                  # Start colima (sets the docker context "colima")
colima status                 # Is colima running?
colima stop                   # Stop colima
docker compose up             # Start a Compose stack
docker buildx build --platform linux/amd64 .  # Multi-platform build
```

`prefix D` in tmux opens lazydocker in a popup.

**Use cases:** Local containers and Compose stacks without Docker Desktop

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

#### mintoolkit (mint, formerly docker-slim)
Container image optimizer. Minify container images by up to 30x while making them more secure by removing unnecessary files and auto-generating security profiles (Seccomp, AppArmor). The Homebrew formula is `mintoolkit`; the command is `mint`.

```bash
mint slim my-image            # Analyze & minify image (alias: mint build)
mint slim --target my-image --tag my-image.slim  # Custom output tag
mint xray my-image            # Inspect image layers & reverse-engineer Dockerfile
mint lint Dockerfile          # Lint Dockerfile for best practices
mint debug my-container       # Debug running container with sidecar
mint profile my-image         # Profile without building slim image
mint images                   # List container images
```

| Command | Description |
|---------|-------------|
| `mint slim` / `mint build` | Analyze and create optimized image |
| `mint xray` | Inspect image, show layers, reverse-engineer Dockerfile |
| `mint lint` | Lint Dockerfiles |
| `mint debug` | Attach debug sidecar to running container |
| `mint profile` | Profile image without building |

**Build flags:**
- `--http-probe=false` - Disable HTTP probing (for CLI tools)
- `--include-path /path` - Include additional paths
- `--include-shell` - Keep basic shell in minified image
- `--copy-meta-artifacts /path` - Copy Seccomp/AppArmor profiles

**Example workflow:**
```bash
# 1. Build and minify
mint slim --target python:3.12 --tag python:3.12.slim

# 2. Compare sizes
docker images | grep python

# 3. Use generated security profile
docker run --security-opt seccomp:my-image-seccomp.json my-image.slim
```

**Use cases:** Reduce image size, improve security, optimize CI/CD pipelines, remove attack surface

#### temporal
Durable execution platform for building reliable workflows. The CLI includes a local development server, workflow management, and debugging tools.

```bash
temporal server start-dev     # Start local dev server (Web UI at :8233)
temporal server start-dev --db-filename temporal.db  # Persist data
temporal server start-dev --ui-port 8080  # Custom Web UI port
temporal workflow list        # List workflows
temporal workflow show -w <id> # Show workflow details
temporal workflow start --task-queue myqueue --type MyWorkflow  # Start workflow
temporal workflow signal -w <id> --name mySignal --input '{"key":"value"}'
temporal workflow cancel -w <id>  # Cancel running workflow
temporal workflow terminate -w <id>  # Force terminate workflow
```

| Command | Description |
|---------|-------------|
| `temporal server start-dev` | Start local Temporal Service + Web UI |
| `temporal workflow list` | List all workflows |
| `temporal workflow show` | Show workflow execution history |
| `temporal workflow start` | Start a new workflow |
| `temporal workflow signal` | Send signal to running workflow |
| `temporal workflow cancel` | Request graceful cancellation |
| `temporal workflow terminate` | Force terminate workflow |

**Server flags:**
- `--db-filename <file>` - Persist workflows between restarts
- `--ui-port <port>` - Change Web UI port (default: 8233)
- `--port <port>` - Change gRPC port (default: 7233)
- `--log-level <level>` - Set log verbosity

**SDK setup (TypeScript):**
```bash
npx @temporalio/create@latest ./my-app  # Create new project
npm install @temporalio/client @temporalio/worker @temporalio/workflow @temporalio/activity
```

**Use cases:** Durable workflows, long-running processes, saga patterns, distributed transactions, reliable task queues

### Database Tools

#### dbt
Data build tool for analytics engineering. Transform raw data into analytics-ready tables using SQL and Jinja templating. The installed `dbt` is the **dbt Cloud CLI** (tap `dbt-labs/dbt-cli`).

```bash
dbt init myproject            # Initialize new project
dbt run                       # Run all models
dbt run --select model_name   # Run specific model
dbt test                      # Run tests
dbt build                     # Run models + tests
dbt docs generate             # Generate documentation
dbt docs serve                # Serve docs locally
dbt debug                     # Test connection
```

| Command | Description |
|---------|-------------|
| `dbt run` | Execute models |
| `dbt test` | Run data tests |
| `dbt build` | Run + test |
| `dbt compile` | Compile SQL without running |
| `dbt seed` | Load CSV files |
| `dbt snapshot` | Run snapshots |
| `dbt source freshness` | Check source data freshness |

**Project structure:**
```
myproject/
├── dbt_project.yml           # Project config
├── models/                   # SQL models
│   ├── staging/              # Raw data transforms
│   └── marts/                # Business logic
├── tests/                    # Custom tests
├── macros/                   # Reusable Jinja macros
└── seeds/                    # CSV files to load
```

**Use cases:** Data transformation, ELT pipelines, analytics engineering, data modeling

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

#### snowflake-cli (snow)
Snowflake's command-line interface. The command is `snow`. Replaces SnowSQL, which is no longer installed.

```bash
snow connection add           # Add a named connection (interactive)
snow connection list          # List configured connections
snow connection test -c prod  # Test a connection
snow connection set-default prod  # Make a connection the default
snow sql -q "select current_role()"     # Run a query
snow sql -q "select 1" -c prod          # Run against a named connection
snow sql -f script.sql                  # Run a SQL file
```

**Data loading:**
```bash
snow sql -q "PUT file://data.csv @mystage"
snow sql -q "COPY INTO mytable FROM @mystage FILE_FORMAT=(TYPE=CSV)"
```

**Use cases:** SQL development, data loading/unloading, Snowflake administration, scripting ETL pipelines

#### duckdb
In-process analytical SQL database. Queries CSV, Parquet and JSON files directly.

```bash
duckdb                        # Interactive shell, in-memory database
duckdb analytics.duckdb       # Open or create a database file
duckdb -c "select * from 'data/*.parquet' limit 5"   # One-off query on files
duckdb -c "select count(*) from 'events.csv'"
duckdb -ui                    # Web UI (ui extension)
```

Harlequin is installed with the DuckDB adapter: `harlequin analytics.duckdb`.

**Use cases:** Fast local analytics, exploring Parquet/CSV, prototyping SQL before running it in a warehouse

#### sqlfluff
SQL linter and formatter with dbt and Snowflake dialects.

```bash
sqlfluff lint models/ --dialect snowflake   # Report problems
sqlfluff fix models/ --dialect snowflake    # Fix what can be fixed
sqlfluff format models/ --dialect snowflake # Format only
```

**Use cases:** Consistent SQL style in dbt projects, catching errors in review

#### sqlit
The lazygit of SQL databases - connect and query any database from your terminal in seconds. Supports SQL Server, PostgreSQL, MySQL, SQLite, DuckDB, and more.

```bash
sqlit                         # Launch TUI, pick a connection
sqlit --mock=sqlite-demo      # Try without a real database
sqlit query -c "MyDB" -q "SELECT * FROM users"  # CLI mode
sqlit connections add sqlite --name "Local" --file-path "./db.sqlite"
```

| Key | Action |
|-----|--------|
| `i` | Enter INSERT mode (typing) |
| `Esc` | Back to NORMAL mode |
| `e/q/r` | Focus Explorer/Query/Results |
| `s` | SELECT TOP 100 from table |
| `h` | Query history |
| `d` | Clear query |
| `y` | Copy query |
| `<space>c` | Connect to database |
| `<space>t` | Change theme |
| `Ctrl+Q` | Quit |

**Use cases:** Quick database queries, connection management, SQL development without heavy IDE

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
nvim $(fzf)                   # Open selected file in nvim
cd $(find . -type d | fzf)    # cd to selected directory

# Shortcuts (with shell integration)
Ctrl+t                        # Paste selected file path (fd list, bat/eza preview)
Alt+c                         # cd to selected directory (eza tree preview)
cd **<Tab>                    # fzf completion with preview
Ctrl+g Ctrl+f                 # fzf-git: pick git files (also b branches, h commits, s stashes, ...)
```

`Ctrl+r` is handled by [atuin](#atuin), which loads after fzf. Configuration: `~/.config/zsh/fzf.zsh` (fd as the file source, Catppuccin Mocha colours).

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
yy                            # Open yazi, cd to its directory on exit
```

Custom keys from `~/.config/yazi/keymap.toml` (prepended to Yazi's defaults; Colemak-style `u`/`e`/`n`/`i` navigation):

| Key | Action |
|-----|--------|
| `u` / `e` | Up / down (`U` / `E`: 5 lines) |
| `n` | Parent directory |
| `i` | Enter directory or open file (smart-enter) |
| `N` / `I` | Back / forward in history |
| `C-u` / `C-e` | Scroll preview |
| `l` / `L` | Symlink yanked files (absolute / relative) |
| `-` / `=` | Next / previous find match |
| `w` | Open a shell here |
| `W` | Show tasks |

Theme: Catppuccin flavors (Mocha dark, Latte light), cloned by `update --only yazi`. In Neovim: `<leader>fy` (current file), `<leader>fY` (cwd).

**Use cases:** File browsing, bulk operations, preview files without opening

#### broot
Interactive tree view with search. Navigate and operate on directory structures.

```bash
broot                         # Open in current directory
br                            # Launcher function (sourced in ~/.zshrc): cd on exit
```

| Key | Action |
|-----|--------|
| Type | Filter/search |
| `Enter` | cd to directory |
| `alt+Enter` | Open in $EDITOR |
| `ctrl+q` | Quit |

#### croc
Securely send files and folders between any two computers, end-to-end encrypted with a relay fallback (works across NAT/firewalls).

```bash
croc send file.zip            # Send a file, prints a one-time code
croc send folder/             # Send a directory
croc send --text "secret"     # Send text/clipboard content
croc <code-phrase>            # Receive using the code from the sender
croc --yes <code-phrase>      # Receive without confirmation prompt
```

**Use cases:** Quick device-to-device transfers, sharing files without cloud, moving data across networks

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

#### jolt
Terminal-based battery and energy monitor for macOS and Linux. Tracks power consumption, process energy usage, and battery health in a themeable TUI.

```bash
jolt                          # Start TUI
jolt pipe                     # Output metrics as JSON for scripting
jolt debug                    # Print system and battery debug info
jolt daemon start             # Start background daemon for history
jolt daemon status            # Check daemon status
jolt history                  # View historical data
jolt theme                    # Manage themes
```

| Key | Action |
|-----|--------|
| `j/k` | Navigate up/down |
| `Enter` | Expand/collapse process group |
| `K` | Kill selected process |
| `g` | Toggle graph (battery/power) |
| `t` | Open theme picker |
| `s` | Open settings |
| `h` | View history |
| `?` | Show help |
| `q` | Quit |

**Features:**
- Battery status (charge, time remaining, health, cycle count)
- Power monitoring (system power draw with CPU/GPU breakdown)
- Process tracking sorted by energy impact
- Historical graphs for battery and power trends
- 10+ built-in themes with dark/light auto-detection
- Background daemon for data collection

**Use cases:** Battery diagnostics, identifying power-hungry processes, monitoring battery health

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

Interactive zsh puts the GNU coreutils, findutils, sed, tar, grep and awk first on `PATH` under their usual names (no `g` prefix). Scripts keep the BSD tools.

Configured aliases (verbose file operations):
```bash
cp      # cp -v
mv      # mv -v
rm      # rm -v
mkdir   # mkdir -v
chmod   # chmod -v
chown   # chown -v
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

### aliases CLI
Built-in CLI tool to view and manage shell aliases. Supports quick lookups and interactive TUI browsing with Nerd Font icons.

```bash
aliases                       # Show help and categories
aliases -s git                # Show git aliases (󰊢)
aliases -s files              # Show file operation aliases (󰉋)
aliases -d ga                 # Describe specific alias
aliases --tui                 # Launch interactive TUI browser
aliases -t                    # Short form for TUI
```

| Key (TUI) | Action |
|-----------|--------|
| `/` | Search aliases |
| `j/k` or `↓/↑` | Navigate |
| `Enter` | Select |
| `Escape` | Clear search |
| `q` | Quit |

**Categories:** `git` `files` `nav` `term` `pkg` `sys` `gnu` `fn`

**Use cases:** Learning aliases, quick reference, discovering available shortcuts

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

### leaf
GUI-like terminal markdown previewer with a TOC sidebar, live watch mode, fuzzy file picker, and syntax highlighting.

```bash
leaf README.md                # Render a markdown file
leaf -w notes.md              # Watch mode: auto-reload on save
leaf                          # Fuzzy markdown picker
leaf --picker                 # Directory browser picker
leaf --theme forest README.md # Pick a color theme
leaf --inline ansi README.md  # Render to stdout (pipes, fzf previews)
cat README.md | leaf          # Preview from stdin
claude "explain X" | leaf     # Stream markdown from another CLI
```

| Key | Action |
|-----|--------|
| `j/k` or `↓/↑` | Scroll down/up |
| `g/G` | Top/bottom |
| `t` | Toggle TOC sidebar |
| `w` | Toggle watch mode |
| `Ctrl+P` | Fuzzy picker |
| `Ctrl+E` | Open in editor |
| `/` | Find |
| `q` | Quit |

Config: `leaf --config` (theme, editor, watch, width). CLI flags always win.

**leaf vs glow:**
- **leaf** = Richer TUI (TOC, watch, themes, LaTeX/mermaid, editor integration)
- **glow** = Lightweight quick render

**Use cases:** Reading long docs with navigation, live-previewing AI-generated markdown, fzf preview pane

### ghostty
GPU-accelerated terminal emulator. Fast, feature-rich, and highly configurable.

Configuration: `~/.config/ghostty/config` (theme Catppuccin Mocha, left Option key as Alt). New windows show a greeting and count down to herdr (`t` tmux, `h` herdr, any other key adds 5 seconds) when `TERM_PROGRAM=ghostty`, outside tmux/herdr and SSH, unless `DOTFILES_NO_TMUX` is set or `MULTIPLEXER` picks one.

Custom keys are sequences that start with `Cmd+b`:

| Key | Action |
|-----|--------|
| `Cmd+b r` | Reload config |
| `Cmd+b x` | Close window |
| `Cmd+b n` | New window |
| `Cmd+b i` | New split right |
| `Cmd+b -` | New split down |
| `Cmd+b h/j/k/l` | Go to split left/bottom/top/right |
| `Cmd+b z` | Toggle split zoom |
| `Cmd+b e` | Equalize splits |

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

Prefix: `Ctrl+b` (tmux default). Configuration: `~/.tmux.conf`.

| Binding | Action |
|---------|--------|
| `prefix + i` | Split right (current directory) |
| `prefix + -` | Split down (current directory) |
| `Ctrl + h/j/k/l` | Move between panes, no prefix (passed to Neovim when it runs in the pane) |
| `prefix + h/j/k/l` | Resize pane |
| `prefix + c` | New window (current directory) |
| `prefix + < / >` | Swap window left / right |
| `prefix + x` | Kill pane (no prompt) |
| `prefix + Ctrl+s` | Toggle synchronize-panes |
| `prefix + r` | Reload config |
| `prefix + g` | lazygit popup |
| `prefix + D` | lazydocker popup |
| `prefix + K` | sesh picker (gum) |
| `prefix + T` | sesh picker (fzf) |
| `prefix + P` | Paste buffer (overrides the tmux-floax menu key) |
| `prefix + I` | Install plugins (tpm) |

Copy mode uses vi keys: `v` begin selection, `y` copy, `r` rectangle. tmux's other default bindings (`prefix + d` detach, `prefix + z` zoom, ...) are unchanged.

Aliases:
```bash
iexit   # Kill current session
ikill   # Kill the tmux server
iswitch # Interactive session switcher
ipop    # Popup with a "scratch" session in the current directory
```

**tmux.expose** (plugin): Mission Control-style session switcher with live text previews of every session in a grid. Press `Alt+e` (no prefix) to open the popup, arrows/`hjkl` to move, `Enter` to switch, `q`/`Esc` to close. Backed by the `tmux-expose` binary (a `cargo` entry in the Brewfile).

### sesh
Smart session manager for tmux. Quick switching between projects.

```bash
sesh connect project          # Connect to or create session
sesh list                     # List sessions
```

Pickers: `Alt+s` in zsh, `prefix + K` or `prefix + T` in tmux.

Configuration: `~/.config/sesh/sesh.toml` (sessions: `Downloads 📥` with yazi, `dotfiles` with nvim, `tmux config`).

### starship
Minimal, fast, customizable prompt for any shell.

Configuration: `~/.config/starship.toml` (starship's default location)

### zsh & antidote
zsh configuration is split by when it runs:

| File | Runs for | Contents |
|------|----------|----------|
| `~/.zshenv` | Every zsh | XDG variables, `DOTFILES_DIR`, `EDITOR=nvim`, `PATH` |
| `~/.zprofile` | Login shells | Rebuilds `PATH` after macOS `path_helper`; sources `~/.zprofile.local` |
| `~/.zshrc` | Interactive shells | tmux auto-start, history, plugins, completions, tool init, aliases, functions; sources `~/.zshrc.local` last |

Machine-local settings, and lines that installers append to `~/.zshrc`, belong in `~/.zshrc.local` (not tracked).

**antidote** is the plugin manager (replaces antigen and zplug). Plugins are listed one per line in `~/.config/zsh/plugins.txt`; antidote compiles them into a static file in `$XDG_CACHE_HOME/zsh`.

```bash
# ~/.config/zsh/plugins.txt
romkatv/zsh-defer
zsh-users/zsh-completions path:src kind:fpath
djui/alias-tips
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting kind:defer
```

```bash
antidote list                 # Cloned bundles
antidote update               # Update antidote and all bundles
```

After editing `plugins.txt`, open a new shell (or `reload`) and antidote rebuilds the bundle.

### atuin
Searchable shell history with context (directory, host). Replaces fzf's history search: it is loaded last in `~/.zshrc`, so it owns `Ctrl+R` and the up arrow.

```bash
Ctrl+R                        # Search all history
atuin search docker           # Search from the command line
atuin stats                   # Most used commands
atuin import zsh              # Import existing zsh history
```

Configuration: `~/.config/atuin/config.toml` (`enter_accept = true`: Enter runs the selected command).

**Use cases:** Finding that command from last month, history per directory, optional sync between machines (`atuin login`, `atuin sync`)

---

## Neovim

Hyperextensible text editor built on Vim. Configured with [LazyVim](https://www.lazyvim.org/) as the base distribution.

```bash
nvim file                     # Open file
nvim +42 file                 # Open at line 42
nvim -d file1 file2           # Diff mode
```

Configuration: `~/.config/nvim/`. LazyVim extras are listed only in `lazyvim.json`; custom plugins live in `lua/plugins/`.

Aliases: `n`, `v`, `vi`, `vim` -> `nvim`

- **Picker:** snacks (Telescope is not used). **Completion:** blink.cmp. **Colorscheme:** Catppuccin Mocha.
- **Python:** ty (`vim.g.lazyvim_python_lsp = "ty"`) for types, ruff for lint and format; both from Homebrew, not Mason. Plugins use `~/.virtualenvs/neovim` (pynvim), created by `update --only venv`.
- **Terraform:** formatted with `tofu fmt`.
- **Autosave** on leaving a buffer, losing focus, or leaving insert mode; insert mode ends after 5 seconds without typing.
- Press `<leader>` (Space) and wait: which-key lists every mapping. `<leader>sk` searches keymaps.

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
| `<leader><leader>` | Find files (snacks picker) |
| `<leader>ff` | Find files |
| `<leader>fr` | Recent files |
| `<leader>/` | Grep (root dir) |
| `<leader>sg` | Live grep |
| `<leader>fb` / `<leader>,` | Buffer list |
| `<leader>sh` | Help pages |
| `<leader>e` | File explorer (neo-tree) |
| `<leader>fy` | Yazi at the current file |
| `<leader>fY` | Yazi in the working directory |
| `<leader>bd` | Delete buffer |
| `<leader>.` | Scratch buffer |
| `Shift+h/l` | Previous/next buffer |

### Harpoon (Quick File Access)

| Key | Action |
|-----|--------|
| `<leader>a` | Add file to harpoon |
| `Ctrl+e` | Harpoon menu |
| `<leader>1-4` | Jump to harpoon file 1-4 |
| `Ctrl+Shift+p/n` | Previous/next harpoon file |

### Git Integration

| Key | Action |
|-----|--------|
| `<leader>gg` | Open Lazygit (snacks) |
| `<leader>gf` | Current file history (snacks picker) |
| `<leader>gH` | Git file history (custom, snacks picker) |
| `<leader>gl` | Git log |
| `<leader>gb` | Blame line |
| `<leader>gB` | Browse on GitHub |
| `]h/[h` | Next/Previous hunk |
| `<leader>ghs` | Stage hunk |
| `co/ct/cb/c0` | Resolve conflict: ours/theirs/both/none (git-conflict) |
| `]x/[x` | Next/Previous conflict (git-conflict) |

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
| `<leader>cn` | Navbuddy symbol tree |
| `]d/[d` | Next/Previous diagnostic |

### Secrets (Camouflage)

Values of sensitive keys (API keys, tokens, passwords, ...) in `.env`-style files are masked until revealed.

| Key | Action |
|-----|--------|
| `<leader>ct` | Toggle masking |
| `<leader>cv` | Reveal the secret on this line |
| `<leader>cy` | Yank the secret value |

### Testing

| Key | Action |
|-----|--------|
| `<leader>tr` | Run nearest test |
| `<leader>tt` | Run file tests |
| `<leader>tT` | Run all test files |
| `<leader>tl` | Run last test |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Show test output |
| `<leader>tS` | Stop tests |
| `<leader>td` | Debug nearest test |

### Debugging (DAP)

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Run/Continue |
| `<leader>di` / `<leader>dO` / `<leader>do` | Step into/over/out |
| `<leader>du` | Toggle DAP UI |
| `<leader>dt` | Terminate |
| `<leader>dPt` | Debug Python test method |
| `<leader>dPc` | Debug Python test class |

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
| `s` / `S` | Leap forward/backward |
| `<leader>p` | Yank history |

### Multi-cursor

| Key | Action |
|-----|--------|
| `Up/Down` | Add cursor above/below |
| `<leader>Up/Down` | Skip line above/below |
| `<leader>mn` / `<leader>mN` | Add cursor at next/previous match |
| `<leader>ms` / `<leader>mS` | Skip next/previous match |
| `Ctrl+q` | Disable/enable cursors |
| `Ctrl+click` | Add/remove cursor |
| `Left/Right` | Switch main cursor (with cursors active) |
| `<leader>x` | Delete main cursor (with cursors active) |
| `Esc` | Clear cursors |

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
| **Snacks** | Picker, lazygit, dashboard, notifications, scratch, terminal |
| **blink.cmp** | Autocompletion |
| **neo-tree** | File explorer |
| **Harpoon** | Quick file marks |
| **yazi.nvim** | Terminal file manager |
| **multicursor.nvim** | Multiple cursors |
| **camouflage.nvim** | Mask secrets in `.env` files |
| **nvim-navbuddy** | Symbol tree |
| **opencode.nvim** | AI agent integration |
| **git-conflict.nvim** | Resolve merge conflicts |
| **nvim-surround** | Surround text objects |
| **leap.nvim** | Jump anywhere (replaces flash) |
| **nvim-dap** | Debugger |
| **neotest** | Test runner |
| **Treesitter** | Syntax highlighting |
| **Mason** | Tool installer (actionlint, shellcheck, language extras) |
| **tiny-inline-diagnostic** | Inline diagnostics (virtual text off) |
| **atone.nvim** | Undo tree (`:Atone`) |
| **typr** | Typing practice (`:Typr`) |
| **Catppuccin** | Color scheme |

---

## Programming Languages

### mise (runtime manager)
One manager for language runtimes and npm-based tools. Replaces n (Node versions) and direnv. Rule from its config: language runtimes and npm-based tools live in mise; system tools live in the Brewfile; Python is managed by uv and Rust by rustup.

Global tools (`~/.config/mise/config.toml`): `node` (lts), `go`, `bun`, `pnpm`, `usage`, and `npm:@earendil-works/pi-coding-agent` (the `pi` command). mise also reads `.nvmrc`, `.node-version` and `.go-version` files in projects.

```bash
mise install                  # Install everything in the config (update --only runtimes)
mise use node@24              # Pin Node for this project (writes mise.toml)
mise use -g go@latest         # Change a global version
mise ls                       # Installed and active versions
mise outdated                 # Available updates
mise upgrade                  # Upgrade (also run by update --all)
mise exec node@20 -- node -v  # Run one command with another version
mise doctor                   # Check the setup (also run by update --doctor)
```

Per-project environment variables, previously in `.envrc` (direnv), go in the project's `mise.toml`:

```toml
[env]
DATABASE_URL = "postgres://localhost/dev"
```

**Use cases:** Per-project runtime versions, one tool instead of n and direnv

### Python

#### uv
Extremely fast Python package manager, project manager, and resolver written in Rust. Replaces pip, pip-tools, pipx, poetry, pyenv, and virtualenv.

**Creating Projects**
```bash
uv init                       # Initialize project in current directory
uv init myproj                # Initialize project in myproj/
uv init --app --package       # Initialize packageable app (CLI, web app)
uv init --lib --package       # Initialize packageable library
uv init --python 3.14         # Use specific Python version (3.14 is the default here)
```

**Managing Dependencies**
```bash
uv add 'httpx2[ws]'           # Add dependency (HTTP client with WebSockets)
uv add pytest --dev           # Add dev dependency
uv add -r requirements.txt    # Add from requirements file
uv remove httpx2              # Remove dependency
uv tree                       # Show dependency tree
uv lock --upgrade             # Upgrade all dependencies
```

**Running Code**
```bash
uv run python                 # Run Python in project environment
uv run pytest                 # Run pytest
uv run --with rich python     # Run with additional package
uv run --with bpython bpython # Run bpython REPL
uv run --python 3.13 python   # Run with another Python version
```

**Tools (like pipx)**
```bash
uvx pycowsay hello            # Run tool without installing (alias for uv tool run)
uvx --from textual textual-demo  # Run command from specific package
uv tool install harlequin     # Install tool globally
uv tool install --with plugins pkg  # Install with extra dependencies
uv tool list                  # List installed tools
uv tool upgrade harlequin     # Upgrade specific tool
uv tool upgrade --all         # Upgrade all tools
uv tool uninstall harlequin   # Uninstall tool
```

Global uv tools are declared in the Brewfile (`uv "harlequin[duckdb,mysql,postgres,sqlite]"`, `uv "sqlit-tui"`) and installed by `brew bundle`. ruff and ty are Homebrew formulae, not uv tools.

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
uv python install 3.14        # Install Python version
uv python upgrade 3.14        # Upgrade to the latest patch release
uv python uninstall 3.13      # Uninstall Python version
uv python pin 3.14            # Pin project to Python version
uv python pin --global 3.14   # Change the global default
```

The default Python is **3.14**, pinned in `uv/.config/uv/.python-version` (stowed to `~/.config/uv/.python-version`, which uv reads globally). `update --only runtimes` installs it and links `python` and `python3` in `~/.local/bin` to it, so they win over Homebrew's `python3`. To move to a new version, edit that file and run `update --only runtimes venv`.

**Project Lifecycle**
```bash
uv build                      # Build packageable project
uv publish                    # Publish to PyPI
uv version                    # Check project version
uv version --bump minor       # Bump version
```

**Use cases:** Project management, dependency resolution, running scripts, tool management, Python version management

#### httpx2
The standard HTTP client for Python code in this setup (sync and async, HTTP/2, WebSockets). Use it instead of `requests` or `httpx`. Add the `ws` extra when you need WebSockets:

```bash
uv add 'httpx2[ws]'           # Project dependency
uv add --script script.py 'httpx2[ws]'  # Single-file script
```

```python
import asyncio

import httpx2


async def fetch_titles(client: httpx2.AsyncClient, urls: list[str]) -> list[str]:
    async with asyncio.TaskGroup() as group:
        tasks = [group.create_task(client.get(url)) for url in urls]
    return [task.result().raise_for_status().json()["title"] for task in tasks]
```

Pass the client in instead of creating one inside the function, so tests can give it a mock transport. The full conventions and checklist are in [AGENTS.md](./AGENTS.md#python).

#### ruff
Python linter and formatter (Homebrew formula). Also used by Neovim for lint and format, and by this repository's prek hooks.

```bash
ruff check .                  # Lint
ruff check --fix .            # Lint and apply fixes
ruff format .                 # Format
ruff format --check .         # Check formatting only (CI)
```

#### ty
Python type checker from Astral (Homebrew formula). Neovim uses it as the Python language server.

```bash
ty check .                    # Type-check the project
ty check src/app.py           # Type-check one file
```

**Before commit** (from `AGENTS.md`): `uv run ruff format . && uv run ruff check --fix . && uv run ty check . && uv run pytest`

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
JavaScript runtime built on Chrome's V8 engine. Installed by mise (LTS); pin per project with `mise use node@<version>`.

```bash
node script.js                # Run JavaScript
node -e "console.log('hi')"   # Evaluate expression
node --inspect script.js      # Debug mode
```

#### bun
Fast all-in-one JavaScript runtime, bundler, and package manager. Installed by mise.

```bash
bun run script.ts             # Run TypeScript directly
bun install                   # Install dependencies
bun add package               # Add dependency
bun build ./src/index.ts      # Bundle
bun test                      # Run tests
```

**Use cases:** Fast package installs, TypeScript execution, bundling

#### pnpm
Fast, disk-efficient package manager (replaces yarn). Installed by mise.

```bash
pnpm install                  # Install dependencies
pnpm add package              # Add dependency
pnpm run script               # Run script
```

Aliases:
```bash
pn    # pnpm
pna   # pnpm add
pnr   # pnpm run
pni   # pnpm install
```

#### biome
Linter and formatter for JavaScript and TypeScript (Homebrew formula).

```bash
biome check --write .         # Lint and format in one pass
```

### Go

#### go
The Go programming language. Compiled, statically typed. Installed by mise. `GOPATH` is `~/projects/go`; `$GOBIN` is on `PATH`.

```bash
go run main.go                # Run program
go build                      # Compile
go test                       # Run tests
go mod init                   # Initialize module
go get package                # Add dependency
```

### Rust

#### rust (rustc, cargo)
Systems programming language focused on safety and performance. The toolchain is managed by **rustup** (Homebrew formula, keg-only); `update` runs `rustup default stable` and `~/.cargo/bin` is on `PATH`.

```bash
rustup update                 # Update to the latest stable toolchain
cargo new project             # Create project
cargo build                   # Compile
cargo run                     # Build and run
cargo test                    # Run tests
cargo add package             # Add dependency
rustc --version               # Check version
bacon clippy                  # Re-run clippy on every save
```

Global crates are `cargo` entries in the Brewfile (repgrep, tmux-expose, pay-respects), installed with `cargo install --locked`.

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

### pi
Earendil's terminal coding agent (npm package `@earendil-works/pi-coding-agent`). Installed by mise as `npm:@earendil-works/pi-coding-agent` (see `~/.config/mise/config.toml`), so it runs on mise's Node.

```bash
pi                            # Start the coding agent
pi --version                  # Check version
```

Installed by `update --only runtimes` (`mise install`). To update:

```bash
update pi                     # Detected as a mise tool by its command name
mise upgrade                  # Upgrade every mise tool
```

**Use cases:** AI pair programming, code generation, terminal-driven coding

### ollama
Run large language models locally.

```bash
ollama run llama2             # Run model
ollama list                   # List installed models
ollama pull mistral           # Download model
ollama serve                  # Start server
```

**Use cases:** Local AI, privacy-focused LLM usage, offline development

### llama.cpp
LLM inference in C/C++. Run models efficiently on CPU.

```bash
llama-cli -m model.gguf -p "prompt"  # Run inference
llama-server -m model.gguf           # OpenAI-compatible API server
```

### hf (Hugging Face Hub CLI)
Download and upload models and datasets from the Hugging Face Hub.

```bash
hf auth login                 # Authenticate
hf download org/model         # Fetch model weights
hf upload org/model ./folder  # Upload a folder
```

### Unsloth Studio
Local UI for fine-tuning LLMs. Installed by `update --only utils` from the official installer into `~/unsloth_studio`.

```bash
unsloth studio                # Local fine-tuning UI on :8888
```

---

## Productivity Applications

### 1Password
Password manager with CLI integration.

```bash
op signin                     # Authenticate
op item get "item name"       # Retrieve item
op read "op://vault/item/field"  # Read secret
envrun python app.py          # Run one command with .env loaded; op:// references resolved
```

`envrun` (shell function) wraps `op run --env-file=.env -- <command>`, so secrets never enter your shell. `setenv --key` exports `.env` into the current shell instead.

### Raycast
Spotlight replacement with extensibility. Launcher, snippets, clipboard history.

Default shortcut: `Cmd + Space`

**Use cases:** App launching, snippets, window management, calculations

### Shortcat
Keyboard-driven UI navigation. Click any button with your keyboard.

Shortcut: `Cmd + Shift + Space` (configurable)

**Use cases:** Mouseless workflow, accessibility, RSI prevention

### hiddenbar
Hide menu bar items. Keep your menu bar clean.

### CleanShot
Screenshot and screen recording tool with annotation. **Not managed by the Brewfile**: kept at v4 (the license does not cover v5). Install v4 manually.

### mas
Mac App Store from the terminal.

```bash
mas list                      # Installed App Store apps
mas outdated                  # Apps with updates
mas upgrade                   # Upgrade all
```

### Alt-Tab
Windows-style alt-tab window switcher for macOS.

### Zen Browser
Privacy-focused Firefox-based browser with a clean, minimal UI. Emphasizes distraction-free browsing with vertical tabs and workspace organization.

**Use cases:** Privacy-conscious browsing, distraction-free web, Firefox extension compatibility

---

## Window Management

### AeroSpace
Tiling window manager for macOS. i3-like experience.

Configuration: `~/.config/aerospace/aerospace.toml` (stow package `aerospace`; AeroSpace's default template, `start-at-login = false`).

| Key | Action |
|-----|--------|
| `alt + h/j/k/l` | Focus window |
| `alt + shift + h/j/k/l` | Move window |
| `alt + 1-9`, `alt + <letter>` | Switch workspace |
| `alt + shift + 1-9`, `alt + shift + <letter>` | Move to workspace |
| `alt + /` | Tiles layout |
| `alt + ,` | Accordion layout |
| `alt + shift + -` / `alt + shift + =` | Resize |
| `alt + tab` | Previous workspace |
| `alt + shift + ;` | Service mode (`f` float/tile, `r` reset layout, `esc` reload config) |

AeroSpace's `alt + e` and `alt + s` (workspaces E and S) are global and shadow tmux.expose (`Alt+e`) and the zsh sesh picker (`Alt+s`) while AeroSpace runs.

**Use cases:** Tiling window management, keyboard-driven workflow

---

## System Utilities

### stow
Symlink farm manager. Manages dotfiles by creating symlinks.

```bash
stow -d ~/dotfiles -t ~ zsh   # Stow zsh config
stow -D zsh                   # Unstow
stow --adopt zsh              # Adopt existing files
```

`update --only stow` links the packages `aerospace atuin ghostty git mise nvim sesh starship tmux uv yazi zsh` with `stow --no-folding --restow` (files are linked one by one, so directories such as `~/.config/git` stay real). Before stowing it removes stale links into the repository and moves conflicting files to `~/.dotfiles-backup/<timestamp>/`.

**Use cases:** Dotfiles management, keeping configs in git

### Per-project environment (mise)
direnv is no longer installed; mise handles per-project tool versions and environment variables (see [mise](#mise-runtime-manager)). For secrets, use `envrun <command>` with a `.env` file of `op://` references (see [1Password](#1password)).

### pay-respects
Corrects your previous console command. Replaces thefuck. Installed as a `cargo` entry in the Brewfile and initialised in `~/.zshrc` with the alias `f`.

```bash
git brach                     # Typo
f                             # Suggests and runs: git branch
```

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

### Touch ID for sudo
`update --only macos` writes `/etc/pam.d/sudo_local` so `sudo` accepts Touch ID. With pam-reattach (Brewfile) it also works inside tmux. `sudo_local` survives macOS updates.

---

## Fonts

Installed fonts:
- **Hack Nerd Font** - Hack with additional glyphs/icons
- **Symbols Only Nerd Font** - Just the icons (for yazi)

---

## Additional Tools

### Bun
Installed by mise (`bun = "latest"` in `~/.config/mise/config.toml`).

### repgrep (rgr)
Interactive ripgrep. Browse search results in a TUI.

```bash
rgr pattern                   # Interactive search
```

Installed via: `cargo "repgrep"` in the Brewfile (`cargo install --locked`)

### Herdr
Installed by `update --only utils` from the official installer (herdr.dev). Update with `update herdr`.

---

## Dotfiles Management

### update (install.sh CLI)
The primary CLI for managing this dotfiles setup. Installs, updates, checks and queries tools. `update` is an alias for `"$DOTFILES_DIR/install.sh"`.

```bash
update                        # Full dotfiles install (idempotent)
update <tool>                 # Update one tool (auto-detects its source)
update --versions             # Show all installed tool versions
update --versions brew        # Show versions for one group
update --info <tool>          # Show tool info, examples, and category
update --outdated             # Show packages with available updates
update --all                  # Update everything (brew, uv, cargo, mise, git repos)
update --doctor               # Health check: links, PATH, configs, Brewfile, identity
update --only <step>          # Run one install step
update --skip "<step> ..."    # Skip steps (one quoted argument)
update --list                 # List install steps
update --dry-run -v           # Preview without changing anything
update --help                 # Show help
```

**Install steps** (in order): `dirs`, `xcode`, `brew`, `stow`, `runtimes`, `venv`, `tmux`, `yazi`, `utils`, `macos`, `cleanup`.

**Version groups:** `brew`, `cask`, `uv`, `cargo`, `mise`, `git`, `other`

**Tool sources** for `update <tool>`: Homebrew formula, cask, uv tool, cargo crate, mise tool (also by command name, e.g. `pi`), `herdr`, `tpm`, `yazi-flavors`.

**Examples:**
```bash
update bat                    # Update bat (detects: brew)
update ruff                   # Update ruff (detects: brew)
update harlequin              # Update harlequin (detects: uv tool)
update pi                     # Update pi (detects: mise)
update --info fzf             # Show fzf description and examples
update --outdated             # Check what needs updating
update --all                  # Update all package managers
update --only stow            # Re-link dotfiles
update --only runtimes        # Re-run mise install and rustup
update --doctor               # Check that the setup is healthy
```

Log file: `$XDG_STATE_HOME/dotfiles/install.log` (default `~/.local/state/dotfiles/install.log`). Failed steps do not stop the run; they are summarised at the end and the exit code is non-zero.

**Use cases:** Dotfiles installation, tool updates, version management, system maintenance

### Git hooks (prek)
Run `prek install` once per clone. Hooks run on every commit; `prek run --all-files` runs them on demand. See [prek](#prek).

---

## Good Commands to Know

Handy one-liners worth remembering.

### List directories by most recently modified

After a break, find which projects you touched last:

```bash
for d in */; do echo "$(find "$d" -type f -exec stat -f '%m' {} + 2>/dev/null | sort -nr | head -1) $d"; done | sort -nr | while read ts dir; do echo "$(date -r "$ts" '+%Y-%m-%d %H:%M:%S') $dir"; done
```

Sorts subdirectories by the timestamp of their newest file (macOS `stat -f`).

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
| Delete by pattern | `purge '*.csv'` or `pg '*.log'` |

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
| Lint Python | `ruff check .` |
| Run TypeScript | `bun run file.ts` |

### System
| Task | Command |
|------|---------|
| Process monitor | `btop` |
| Benchmark | `hyperfine 'cmd'` |
| Correct command | `f` (pay-respects) |
| Quick docs | `tldr command` |
