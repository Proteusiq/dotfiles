#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "rich",
#     "typer",
#     "textual",
# ]
# ///

"""
Fox's Den - A CLI/TUI tool to explore all installed tools and packages.
Mirrors the design of aliases.py for consistency.
"""

import os
import shutil
import subprocess
from enum import Enum
from io import StringIO
from typing import Annotated, ClassVar

import typer
from rich.box import HEAVY, ROUNDED
from rich.console import Console
from rich.panel import Panel
from rich.table import Table

console = Console()
app = typer.Typer(help="Fox's Den - Explore your installed tools")


# ═══════════════════════════════════════════════════════════════════════════
# CATEGORIES with Nerd Font Icons
# ═══════════════════════════════════════════════════════════════════════════


class Category(str, Enum):
    SHELL = "shell"
    EDIT = "edit"
    CLI = "cli"
    FILES = "files"
    VC = "vc"
    QUALITY = "quality"
    DATA = "data"
    DEV = "dev"
    INFRA = "infra"
    LANG = "lang"
    AI = "ai"
    GNU = "gnu"
    MEDIA = "media"
    APPS = "apps"
    WM = "wm"
    SYS = "sys"


# Category metadata: (icon, title, description)
CATEGORY_META = {
    Category.SHELL: ("󰆍", "Shell", "Terminal, prompt, multiplexer"),
    Category.EDIT: ("󰷈", "Editors", "Text editors & writing"),
    Category.CLI: ("󰘳", "Modern CLI", "Modern Unix replacements"),
    Category.FILES: ("󰉋", "Files", "File management & navigation"),
    Category.VC: ("󰊢", "VC", "Version control tools"),
    Category.QUALITY: ("󰄬", "Quality", "Linters, formatters, secret scanning"),
    Category.DATA: ("󰆼", "Data", "Databases & data processing"),
    Category.DEV: ("󰅩", "Dev", "Development & build tools"),
    Category.INFRA: ("󰒋", "Infra", "Infrastructure & cloud"),
    Category.LANG: ("󰘧", "Languages", "Programming languages & runtimes"),
    Category.AI: ("󰧑", "AI", "AI & LLM tools"),
    Category.GNU: ("󰌽", "GNU", "GNU tools, first on PATH in zsh"),
    Category.MEDIA: ("󰕧", "Media", "Media & documents"),
    Category.APPS: ("󰀻", "Apps", "Productivity applications"),
    Category.WM: ("󱂬", "Windows", "Window management"),
    Category.SYS: ("󰒓", "System", "System & security"),
}


# ═══════════════════════════════════════════════════════════════════════════
# TOOL DATA
# Format: (name, description, example)
# Examples should be practical "aha!" moments
# ═══════════════════════════════════════════════════════════════════════════

SHELL_TOOLS = [
    (
        "zsh",
        "Modern shell with plugins & completions",
        "Tab-complete git branches, kubectl resources, ssh hosts",
    ),
    (
        "antidote",
        "Fast zsh plugin manager, static bundle",
        "Edit ~/.config/zsh/plugins.txt → new shell picks it up",
    ),
    (
        "starship",
        "Beautiful prompt showing git, python, node status",
        "See branch, venv, node version at a glance",
    ),
    (
        "tmux",
        "Split terminal into panes, persist sessions",
        "tmux new -s work → detach → reattach from anywhere",
    ),
    (
        "sesh",
        "Fuzzy-find and switch tmux sessions instantly",
        "sesh connect → pick project → instant context switch",
    ),
    (
        "tmux-expose",
        "Mission Control-style tmux session switcher",
        "Alt+e → grid of live session previews → Enter to jump",
    ),
    (
        "atuin",
        "Searchable shell history with context",
        "Ctrl+R → fuzzy search every command, by directory or host",
    ),
    (
        "ghostty",
        "GPU-rendered terminal, native feel, fast AF",
        "Smooth scrolling, ligatures, 60fps rendering",
    ),
    ("herdr", "Herdr (herdr.dev)", "herdr --help → see available commands"),
]

EDIT_TOOLS = [
    (
        "neovim",
        "Vim but modern: LSP, Treesitter, Lua config",
        "Space-f-f to fuzzy find files, gd to go to definition",
    ),
    (
        "dawn",
        "Distraction-free writing, live markdown render",
        "dawn notes.md → headers scale, math renders inline",
    ),
    (
        "glow",
        "Render markdown beautifully in terminal",
        "glow README.md → styled output, no browser needed",
    ),
    (
        "leaf-markdown-viewer",
        "GUI-like markdown previewer: TOC, watch, themes",
        "leaf -w notes.md → live reload with sidebar navigation",
    ),
]

CLI_TOOLS = [
    (
        "bat",
        "cat with syntax highlighting & line numbers",
        "bat script.py → colored code, git diff markers",
    ),
    (
        "eza",
        "ls with icons, git status, tree view built-in",
        "eza -la --git → see file permissions + git status",
    ),
    (
        "fd",
        "find but intuitive, respects .gitignore",
        "fd 'test.*py' → finds test files, skips node_modules",
    ),
    (
        "ripgrep",
        "grep but 10x faster, smart defaults",
        "rg 'TODO' → searches code, skips binaries & .git",
    ),
    (
        "repgrep",
        "Interactive find & replace on ripgrep results",
        "rgr 'old_name' → pick matches → replace in place",
    ),
    (
        "zoxide",
        "cd that learns your habits",
        "z proj → jumps to ~/dev/my-project from anywhere",
    ),
    (
        "httpie",
        "curl for humans, colored JSON output",
        "http GET api.github.com/users/octocat → pretty JSON",
    ),
    (
        "tlrc",
        "tldr pages: man pages but useful examples",
        "tldr tar → shows common tar commands, not 50 pages",
    ),
    (
        "pay-respects",
        "Fix your last mistyped command",
        "git brach → f → runs git branch",
    ),
]

FILES_TOOLS = [
    (
        "yazi",
        "Fastest file manager, vim keys, preview all",
        "yy → u/e move, i enters or opens, n goes up; quit to cd there",
    ),
    (
        "broot",
        "Navigate directories as a tree, fuzzy search",
        "br → type to filter, alt+enter to cd into result",
    ),
    (
        "fzf",
        "Fuzzy find anything: files, history, processes",
        "Ctrl+T → fuzzy pick a file into the command line",
    ),
    (
        "ncdu",
        "Where's my disk space going? Interactive view",
        "ncdu ~ → drill down into what's eating your SSD",
    ),
    (
        "btop",
        "htop but prettier, shows CPU/RAM/disk/network",
        "btop → visual system monitor, kill processes",
    ),
    (
        "stow",
        "Symlink manager for dotfiles",
        "stow nvim → links nvim/.config/nvim to ~/.config/nvim",
    ),
    (
        "rename",
        "Batch rename with regex",
        "rename 's/IMG_/photo_/' *.jpg → renames all photos",
    ),
    (
        "rsync",
        "Fast incremental file copy and sync",
        "rsync -avh src/ dst/ → copy only what changed",
    ),
    (
        "croc",
        "Send files device-to-device, encrypted, any network",
        "croc send file.zip → share code → croc <code> to receive",
    ),
]

VC_TOOLS = [
    (
        "git",
        "Track code changes, collaborate, time travel",
        "git log --oneline --graph → visual branch history",
    ),
    (
        "git-lfs",
        "Store large files without bloating repo",
        "git lfs track '*.psd' → Photoshop files in LFS",
    ),
    (
        "git-filter-repo",
        "Rewrite git history safely",
        "git filter-repo --path secrets.env --invert-paths → purge a file",
    ),
    (
        "git-delta",
        "Pager for git diff with syntax highlighting",
        "git diff → side-by-side-ready, navigable hunks (n/N)",
    ),
    (
        "difftastic",
        "Diff that understands code structure",
        "git dft → structural diff of your changes",
    ),
    (
        "gh",
        "GitHub from terminal: PRs, issues, releases",
        "gh pr create → create PR without leaving terminal",
    ),
    (
        "lazygit",
        "Git TUI: stage hunks, rebase interactively",
        "lazygit → space to stage, c to commit, visual rebase",
    ),
    (
        "serie",
        "Beautiful git commit graph in terminal",
        "serie → see branch topology with colors",
    ),
    (
        "gitlogue",
        "Replay commits like a movie",
        "gitlogue → watch your project evolve cinematically",
    ),
]

QUALITY_TOOLS = [
    (
        "prek",
        "Fast git hooks runner (pre-commit compatible)",
        "prek install → hooks run on every commit",
    ),
    (
        "gitleaks",
        "Find secrets in code and git history",
        "gitleaks git . → scan every commit for leaked keys",
    ),
    (
        "shellcheck",
        "Lint shell scripts",
        "shellcheck install.sh → catch quoting and logic bugs",
    ),
    (
        "shfmt",
        "Format shell scripts",
        "shfmt -i 4 -w script.sh → consistent formatting",
    ),
    ("stylua", "Format Lua", "stylua nvim/ → format the Neovim config"),
    (
        "actionlint",
        "Lint GitHub Actions workflows",
        "actionlint → find typos and expression errors",
    ),
    (
        "ruff",
        "Python linter and formatter, very fast",
        "ruff check --fix . && ruff format .",
    ),
    (
        "ty",
        "Python type checker from Astral",
        "ty check . → type errors in milliseconds",
    ),
    (
        "biome",
        "JS/TS linter and formatter",
        "biome check --write . → lint + format in one pass",
    ),
    ("bacon", "Background Rust checker", "bacon clippy → re-runs clippy on every save"),
]

DATA_TOOLS = [
    (
        "jq",
        "Query & transform JSON like a boss",
        "curl api | jq '.items[].name' → extract nested fields",
    ),
    ("yq", "jq for YAML", "yq '.parameters' main.params.yaml → read Bicep params"),
    (
        "duckdb",
        "In-process analytical SQL on files",
        "duckdb -c \"select * from 'data/*.parquet' limit 5\"",
    ),
    (
        "tabiew",
        "View CSV/Parquet/JSON with SQL queries",
        "tw data.csv → spreadsheet view, SQL filtering",
    ),
    (
        "dbt",
        "dbt Cloud CLI for analytics engineering",
        "dbt run → transform raw data into analytics-ready tables",
    ),
    (
        "snowflake-cli",
        "Snowflake CLI (snow) for queries & apps",
        "snow sql -q 'select current_role()' → query Snowflake",
    ),
    (
        "sqlfluff",
        "SQL linter and formatter (dbt, Snowflake)",
        "sqlfluff lint models/ --dialect snowflake",
    ),
    (
        "harlequin",
        "Full SQL IDE in your terminal",
        "harlequin db.duckdb → autocomplete, results, export",
    ),
    (
        "sqlit-tui",
        "Lazygit for databases, connect & query fast",
        "sqlit → pick connection, run queries, vim keys",
    ),
    (
        "mongosh",
        "MongoDB shell with autocomplete",
        "mongosh → db.users.find({age: {$gt: 21}})",
    ),
    (
        "lnav",
        "Navigate log files with search & filter",
        "lnav /var/log/*.log → time-synced, filterable",
    ),
    ("pgadmin4", "PostgreSQL admin GUI", "Browse schemas, run queries, inspect plans"),
]

DEV_TOOLS = [
    (
        "watchexec",
        "Run command when files change",
        "watchexec -e py pytest → auto-test on save",
    ),
    (
        "hyperfine",
        "Benchmark commands scientifically",
        "hyperfine 'fd' 'find' → compare with statistics",
    ),
    (
        "act",
        "Test GitHub Actions locally before push",
        "act -j test → run test job without pushing",
    ),
    (
        "vhs",
        "Record terminal as GIF with a script",
        "vhs demo.tape → reproducible terminal recordings",
    ),
    (
        "scooter",
        "Interactive find & replace across files",
        "scooter → TUI for project-wide refactoring",
    ),
    (
        "resterm",
        "Terminal API client for REST/GraphQL/gRPC",
        "resterm → TUI for API testing, OAuth, workflows",
    ),
    (
        "universal-ctags",
        "Index symbols for editors",
        "ctags -R . → jump to definitions without an LSP",
    ),
    ("postman", "API client GUI", "Collections, environments and tests for HTTP APIs"),
    (
        "gum",
        "Beautiful shell script prompts & spinners",
        "gum choose 'opt1' 'opt2' → pretty selection menu",
    ),
]

INFRA_TOOLS = [
    (
        "orbstack",
        "Fast Docker and Linux VMs for macOS",
        "docker run --rm hello-world → runs on OrbStack",
    ),
    (
        "colima",
        "Open-source container runtime on Lima",
        "colima start → docker context colima",
    ),
    ("lima", "Linux VMs on Mac", "limactl start → full Linux shell for testing"),
    (
        "docker",
        "Docker CLI (engine from OrbStack or colima)",
        "docker compose up → start the stack",
    ),
    (
        "docker-compose",
        "Multi-container apps",
        "docker compose logs -f api → follow one service",
    ),
    (
        "docker-buildx",
        "Multi-platform image builds",
        "docker buildx build --platform linux/amd64 .",
    ),
    (
        "lazydocker",
        "Docker TUI: containers, images, logs",
        "lazydocker → manage Docker without remembering flags",
    ),
    (
        "mintoolkit",
        "Minify containers by 30x (formerly docker-slim)",
        "mint slim my-image → optimized image + seccomp profile",
    ),
    (
        "opentofu",
        "Open-source Terraform (tofu)",
        "tofu plan → preview infrastructure changes",
    ),
    (
        "azure-cli",
        "Manage Azure from terminal",
        "az bicep build -f main.bicep → compile Bicep",
    ),
    ("azd", "Azure Developer CLI", "azd up → provision and deploy an app"),
    (
        "temporal",
        "Durable execution: reliable workflows & queues",
        "temporal server start-dev → local server + Web UI",
    ),
]

LANG_TOOLS = [
    (
        "mise",
        "One manager for node, go, bun and per-project versions",
        "mise use node@24 → pin Node for this project",
    ),
    (
        "uv",
        "Python packages, tools and versions, very fast",
        "uv add pandas → installs in milliseconds",
    ),
    (
        "pixi",
        "Conda-compatible, fast, cross-platform",
        "pixi add numpy → manages Python + system deps",
    ),
    ("rustup", "Rust toolchain manager", "rustup update → latest stable Rust"),
    ("node", "JavaScript runtime (via mise)", "node --version → LTS from mise"),
    ("go", "Go toolchain (via mise)", "go run . → build and run"),
    (
        "bun",
        "Node.js but faster: runtime + bundler (via mise)",
        "bun run dev → start dev server, 10x faster",
    ),
    (
        "pnpm",
        "Fast, disk-efficient npm (via mise)",
        "pnpm install → shared store, strict deps",
    ),
]

AI_TOOLS = [
    (
        "opencode",
        "AI coding agent in your terminal",
        "opencode → an agent that edits code and runs commands",
    ),
    (
        "pi",
        "Earendil's coding agent (via mise npm)",
        "pi → chat-driven coding agent in the terminal",
    ),
    (
        "llama.cpp",
        "Run GGUF models locally, fast",
        "llama-server -m model.gguf → OpenAI-compatible API",
    ),
    (
        "ollama-app",
        "Run LLMs locally: Llama, Mistral, etc",
        "ollama run llama3 → chat locally, no API key",
    ),
    ("hf", "Hugging Face Hub CLI", "hf download org/model → fetch model weights"),
    (
        "unsloth",
        "Fine-tune LLMs 2x faster with 80% less memory",
        "unsloth studio → local fine-tuning UI on :8888",
    ),
]

GNU_TOOLS = [
    (
        "coreutils",
        "GNU cp, ls, date... under their usual names",
        "cp --backup=numbered a b → safe copy",
    ),
    (
        "gnu-sed",
        "GNU sed under the name sed",
        "sed -i 's/old/new/g' file → in-place replace, no ''",
    ),
    (
        "gawk",
        "GNU awk under the name awk",
        "awk '{sum+=$1} END {print sum}' → sum a column",
    ),
    (
        "wget",
        "Download files & mirror websites",
        "wget -r site.com → mirror entire website",
    ),
    (
        "gnupg",
        "Encrypt and sign files",
        "gpg -c secrets.txt → password-protected encryption",
    ),
]

MEDIA_TOOLS = [
    (
        "ffmpeg",
        "Convert any media format to any other",
        "ffmpeg -i vid.mov out.mp4 → convert video",
    ),
    (
        "gifsicle",
        "Optimize and edit GIFs",
        "gifify demo.mov → small GIF (uses ffmpeg + gifsicle)",
    ),
    (
        "imagemagick",
        "Batch process images from CLI",
        "magick img.png -resize 50% thumb.png → resize",
    ),
    (
        "mermaid-cli",
        "Generate diagrams from text",
        "mmdc -i diagram.md -o out.png → flowcharts",
    ),
    (
        "slides",
        "Present markdown as slides in terminal",
        "slides deck.md → terminal presentations",
    ),
    ("figlet", "BIG ASCII text banners", "figlet 'Hello' → ASCII art text"),
    ("toilet", "Coloured ASCII art text", "toilet -f mono12 -F metal Hi"),
]

APPS_TOOLS = [
    (
        "1password",
        "Password manager with CLI integration",
        "op item get 'AWS' --fields password → scripts",
    ),
    (
        "1password-cli",
        "1Password from the terminal",
        "envrun python app.py → secrets injected for one command",
    ),
    (
        "raycast",
        "Spotlight but extensible with scripts",
        "Cmd+Space → clipboard history, snippets, emoji",
    ),
    (
        "cleanshot",
        "Screenshots (install v4 manually, not in Brewfile)",
        "Cmd+Shift+4 → draw → copy/upload in seconds",
    ),
    (
        "espanso",
        "Text expansion everywhere",
        "Type :sig → expands to full email signature",
    ),
    ("hiddenbar", "Hide menu bar icons", "Cmd-drag icons behind the divider"),
    (
        "shortcat",
        "Click any UI element with keyboard",
        "Cmd+Shift+Space → type to click buttons",
    ),
    ("mas", "Mac App Store from the terminal", "mas outdated → App Store updates"),
    (
        "arc",
        "Chrome but with workspaces & better UX",
        "Spaces for work/personal, auto-archive tabs",
    ),
    ("zen", "Firefox-based privacy browser", "Vertical tabs, workspaces, split view"),
]

WM_TOOLS = [
    (
        "aerospace",
        "Tiling WM: auto-arrange windows",
        "Alt+h/j/k/l focus, Alt+1..9 workspaces, windows auto-tile",
    ),
    (
        "alt-tab",
        "Windows-style alt-tab with previews",
        "Alt+Tab → see window previews, not just icons",
    ),
]

SYS_TOOLS = [
    (
        "jolt",
        "Battery & energy monitor TUI",
        "jolt → see battery health, power draw, kill draining apps",
    ),
    (
        "wireguard-tools",
        "Modern VPN, simple & fast",
        "wg-quick up vpn → connect to VPN instantly",
    ),
    (
        "lulu",
        "See & block outgoing connections",
        "App tries to phone home → LuLu asks permission",
    ),
    (
        "aldente",
        "Stop charging at 80% for battery health",
        "Keep MacBook plugged in without damaging battery",
    ),
]


# Mapping categories to their data
TOOL_MAP = {
    Category.SHELL: SHELL_TOOLS,
    Category.EDIT: EDIT_TOOLS,
    Category.CLI: CLI_TOOLS,
    Category.FILES: FILES_TOOLS,
    Category.VC: VC_TOOLS,
    Category.QUALITY: QUALITY_TOOLS,
    Category.DATA: DATA_TOOLS,
    Category.DEV: DEV_TOOLS,
    Category.INFRA: INFRA_TOOLS,
    Category.LANG: LANG_TOOLS,
    Category.AI: AI_TOOLS,
    Category.GNU: GNU_TOOLS,
    Category.MEDIA: MEDIA_TOOLS,
    Category.APPS: APPS_TOOLS,
    Category.WM: WM_TOOLS,
    Category.SYS: SYS_TOOLS,
}

ALL_TOOLS = [tool for tools in TOOL_MAP.values() for tool in tools]


# ═══════════════════════════════════════════════════════════════════════════
# RICH CLI OUTPUT
# ═══════════════════════════════════════════════════════════════════════════


def show_tools(category: Category, tools: list[tuple[str, str, str]]) -> None:
    """Display a category of tools in a styled table with pagination if needed."""
    icon, title, desc = CATEGORY_META[category]

    table = Table(box=ROUNDED, border_style="blue", expand=True)
    table.add_column("Tool", style="cyan bold", no_wrap=True)
    table.add_column("Description", style="white")
    table.add_column("Example", style="green dim")

    for name, description, example in tools:
        table.add_row(f"[cyan bold]{name}[/]", description, f"[green dim]{example}[/]")

    panel = Panel(
        table,
        title=f"[blue bold]{icon}  {title}[/]",
        subtitle=f"[dim]{desc}[/]",
        title_align="center",
        border_style="blue",
    )

    # Use pager if content exceeds terminal height and we're in a TTY
    terminal_height = shutil.get_terminal_size().lines
    estimated_lines = len(tools) * 2 + 6

    if estimated_lines > terminal_height and os.isatty(1):
        string_io = StringIO()
        temp_console = Console(file=string_io, force_terminal=True)
        temp_console.print()
        temp_console.print(panel)
        temp_console.print()
        output = string_io.getvalue()

        pager = subprocess.Popen(["less", "-R", "-S"], stdin=subprocess.PIPE, text=True)
        pager.communicate(input=output)
    else:
        console.print()
        console.print(panel)
        console.print()


def show_category_tools(category: Category):
    """Display tools for a specific category."""
    if category in TOOL_MAP:
        show_tools(category, TOOL_MAP[category])


def show_tool_description(tool_name: str):
    """Show detailed description for a specific tool."""
    for name, description, example in ALL_TOOLS:
        if name == tool_name:
            # Find which category this tool belongs to
            cat_name = "Unknown"
            for cat, tools in TOOL_MAP.items():
                if any(t[0] == name for t in tools):
                    icon, title, _ = CATEGORY_META[cat]
                    cat_name = f"{icon}  {title}"
                    break

            main_table = Table(
                box=HEAVY, border_style="blue", show_header=False, width=80
            )
            main_table.add_column("Key", style="cyan bold", width=15)
            main_table.add_column("Value", style="white")

            main_table.add_row("Tool", f"[cyan bold]{name}[/]")
            main_table.add_row("Description", description)
            main_table.add_row("Example", f"[green]{example}[/]")
            main_table.add_row("Category", cat_name)

            console.print()
            console.print(
                Panel(
                    main_table, title="[blue bold]Tool Details[/]", border_style="blue"
                )
            )
            console.print()
            return

    console.print(f"[red]Tool '{tool_name}' not found.[/]")


def show_help():
    """Display help information with category overview."""
    console.print("\n[cyan bold]Usage:[/]")
    console.print("  [green]tools -s vc[/]         Show version control tools")
    console.print("  [green]tools -s cli[/]        Show modern CLI tools")
    console.print("  [green]tools -d lazygit[/]    Describe lazygit")
    console.print("  [green]tools --tui[/]         Interactive browser")

    table = Table(
        title="[bold]Categories[/]", show_header=True, box=ROUNDED, border_style="blue"
    )
    table.add_column("", style="cyan", width=3)
    table.add_column("Name", style="green bold")
    table.add_column("Description")
    table.add_column("Count", style="dim", justify="right")

    for cat in Category:
        icon, _, desc = CATEGORY_META[cat]
        count = len(TOOL_MAP[cat])
        table.add_row(icon, cat.value, desc, str(count))

    console.print()
    console.print(table)
    console.print()
    console.print("[dim]Tip: Use [green]tools --tui[/] for interactive browsing![/]")


# ═══════════════════════════════════════════════════════════════════════════
# TEXTUAL TUI MODE
# ═══════════════════════════════════════════════════════════════════════════


def run_tui():
    """Launch the Textual TUI application."""
    from textual.app import App, ComposeResult
    from textual.binding import Binding
    from textual.containers import Container
    from textual.widgets import (
        DataTable,
        Footer,
        Header,
        Input,
        Label,
        ListItem,
        ListView,
        Static,
    )

    class ToolsApp(App):
        """Interactive tool browser TUI."""

        TITLE = "Fox's Den"

        CSS = """
        Screen {
            layout: grid;
            grid-size: 2;
            grid-columns: 1fr 3fr;
        }

        #sidebar {
            width: 100%;
            height: 100%;
            border: solid $primary;
            padding: 1;
        }

        #main {
            width: 100%;
            height: 100%;
            border: solid $secondary;
        }

        #search {
            dock: top;
            margin: 1;
        }

        #category-list {
            height: 100%;
        }

        .category-item {
            padding: 0 1;
        }

        .category-item:hover {
            background: $boost;
        }

        #table-container {
            height: 100%;
            padding: 1;
        }

        DataTable {
            height: 100%;
        }

        #details {
            dock: bottom;
            height: 6;
            border-top: solid $primary;
            padding: 1;
        }

        .title {
            text-style: bold;
            color: $text;
            padding: 1;
            text-align: center;
        }
        """

        BINDINGS: ClassVar[list[Binding]] = [
            Binding("q", "quit", "Quit"),
            Binding("/", "focus_search", "Search"),
            Binding("escape", "clear_search", "Clear"),
            Binding("j", "cursor_down", "Down", show=False),
            Binding("k", "cursor_up", "Up", show=False),
        ]

        def __init__(self):
            super().__init__()
            self.current_category = Category.SHELL
            self.search_query = ""
            self.showing_all = False

        def compose(self) -> ComposeResult:
            yield Header(show_clock=True)
            with Container(id="sidebar"):
                yield Static("󰘳  Categories", classes="title")
                yield ListView(
                    *[
                        ListItem(
                            Label(f"{CATEGORY_META[cat][0]}  {cat.value}"),
                            id=f"cat-{cat.value}",
                        )
                        for cat in Category
                    ],
                    id="category-list",
                )
            with Container(id="main"):
                yield Input(placeholder="Search tools... (press /)", id="search")
                with Container(id="table-container"):
                    yield DataTable(id="tool-table")
                yield Static("Select a tool to see details", id="details")
            yield Footer()

        def on_mount(self) -> None:
            table = self.query_one("#tool-table", DataTable)
            table.add_columns("Tool", "Description", "Example")
            table.cursor_type = "row"
            self.load_category(self.current_category)

        def load_category(self, category: Category) -> None:
            self.current_category = category
            self.showing_all = False
            table = self.query_one("#tool-table", DataTable)
            table.clear()

            tools = TOOL_MAP[category]
            filtered = self.filter_tools(tools)

            for name, description, example in filtered:
                table.add_row(name, description, example)

            icon, title, desc = CATEGORY_META[category]
            self.query_one("#details", Static).update(
                f"[bold]{icon}  {title}[/] — {desc} ({len(filtered)} tools)"
            )

        def load_all_matching(self) -> None:
            """Load tools from ALL categories matching the search query."""
            self.showing_all = True
            table = self.query_one("#tool-table", DataTable)
            table.clear()

            query = self.search_query.lower()
            results = []
            for cat in Category:
                for name, description, example in TOOL_MAP[cat]:
                    if (
                        query in name.lower()
                        or query in description.lower()
                        or query in example.lower()
                    ):
                        results.append((name, description, example, cat))

            for name, description, example, cat in results:
                icon = CATEGORY_META[cat][0]
                table.add_row(name, f"{icon} {description}", example)

            self.query_one("#details", Static).update(
                f"[bold]󰍉  Search Results[/] — {len(results)} matches across all categories"
            )

        def filter_tools(self, tools: list) -> list:
            if not self.search_query:
                return tools
            query = self.search_query.lower()
            return [
                t
                for t in tools
                if query in t[0].lower()
                or query in t[1].lower()
                or query in t[2].lower()
            ]

        def on_list_view_selected(self, event: ListView.Selected) -> None:
            item_id = event.item.id
            if item_id and item_id.startswith("cat-"):
                cat_name = item_id.replace("cat-", "")
                self.load_category(Category(cat_name))

        def on_data_table_row_selected(self, event: DataTable.RowSelected) -> None:
            table = self.query_one("#tool-table", DataTable)
            row_key = event.row_key
            row = table.get_row(row_key)
            if row:
                name, description, example = row
                # Find the category for this tool
                cat_info = ""
                for cat in Category:
                    if any(t[0] == name for t in TOOL_MAP[cat]):
                        _, title, _ = CATEGORY_META[cat]
                        cat_info = f" [{title}]"
                        break
                details = f"[cyan bold]{name}[/]{cat_info}\n{description}\n[green]→ {example}[/]"
                self.query_one("#details", Static).update(details)

        def on_input_changed(self, event: Input.Changed) -> None:
            if event.input.id == "search":
                self.search_query = event.value
                if self.search_query:
                    self.load_all_matching()
                else:
                    self.load_category(self.current_category)

        def action_focus_search(self) -> None:
            self.query_one("#search", Input).focus()

        def action_clear_search(self) -> None:
            search = self.query_one("#search", Input)
            search.value = ""
            self.search_query = ""
            self.showing_all = False
            self.load_category(self.current_category)

        def action_cursor_down(self) -> None:
            table = self.query_one("#tool-table", DataTable)
            table.action_cursor_down()

        def action_cursor_up(self) -> None:
            table = self.query_one("#tool-table", DataTable)
            table.action_cursor_up()

    app = ToolsApp()
    app.run()


# ═══════════════════════════════════════════════════════════════════════════
# MAIN CLI
# ═══════════════════════════════════════════════════════════════════════════


def get_tool_json(tool_name: str) -> dict | None:
    """Get tool info as a dictionary for machine consumption."""
    for cat, tools in TOOL_MAP.items():
        for name, description, example in tools:
            if name == tool_name:
                _, title, _ = CATEGORY_META[cat]
                return {
                    "name": name,
                    "description": description,
                    "example": example,
                    "category": cat.value,
                    "category_title": title,
                }
    return None


@app.command()
def main(
    show: Annotated[
        Category | None,
        typer.Option("--show", "-s", help="Show tools for a specific category"),
    ] = None,
    describe: Annotated[
        str | None, typer.Option("--describe", "-d", help="Describe a specific tool")
    ] = None,
    json_out: Annotated[
        str | None,
        typer.Option("--json", "-j", help="Output tool info as JSON (for scripts)"),
    ] = None,
    tui: Annotated[
        bool, typer.Option("--tui", "-t", help="Launch interactive TUI browser")
    ] = False,
):
    """
    Fox's Den - Explore your installed tools and packages.

    Categories:
      shell  - Terminal, prompt, multiplexer
      edit   - Text editors & writing
      cli    - Modern Unix replacements
      files  - File management & navigation
      vc     - Version control tools
      quality - Linters, formatters, secret scanning
      data   - Databases & data processing
      dev    - Development & build tools
      infra  - Infrastructure & cloud
      lang   - Programming languages & runtimes
      ai     - AI & LLM tools
      gnu    - GNU coreutils
      media  - Media & documents
      apps   - Productivity applications
      wm     - Window management
      sys    - System & security

    Examples:
      tools              # Show categories
      tools -s vc        # Show version control tools
      tools -d lazygit   # Describe lazygit
      tools --tui        # Interactive browser
    """
    if tui:
        run_tui()
        return

    if json_out:
        import json

        info = get_tool_json(json_out)
        if info:
            print(json.dumps(info))
        else:
            import sys

            sys.exit(1)
        return

    if describe:
        show_tool_description(describe)
        return

    if show:
        show_category_tools(show)
        return

    show_help()


if __name__ == "__main__":
    app()
