#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.8"
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

from enum import Enum
from typing import Optional
import os
import shutil
import subprocess
from io import StringIO

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
    Category.DATA: ("󰆼", "Data", "Databases & data processing"),
    Category.DEV: ("󰅩", "Dev", "Development & build tools"),
    Category.INFRA: ("󰒋", "Infra", "Infrastructure & cloud"),
    Category.LANG: ("󰘧", "Languages", "Programming languages & runtimes"),
    Category.AI: ("󰧑", "AI", "AI & LLM tools"),
    Category.GNU: ("󰌽", "GNU", "GNU coreutils"),
    Category.MEDIA: ("󰕧", "Media", "Media & documents"),
    Category.APPS: ("󰀻", "Apps", "Productivity applications"),
    Category.WM: ("󱂬", "Windows", "Window management"),
    Category.SYS: ("󰒓", "System", "System & security"),
}


# ═══════════════════════════════════════════════════════════════════════════
# TOOL DATA
# Format: (name, command/package, description, install_type)
# install_type: brew, cask, uv, cargo, npm, script, builtin
# ═══════════════════════════════════════════════════════════════════════════

SHELL_TOOLS = [
    ("zsh", "zsh", "Modern shell with plugins", "brew"),
    ("zplug", "zplug", "Zsh plugin manager", "brew"),
    ("starship", "starship", "Cross-shell customizable prompt", "brew"),
    ("tmux", "tmux", "Terminal multiplexer", "brew"),
    ("sesh", "sesh", "Smart tmux session manager", "brew"),
    ("ghostty", "ghostty", "GPU-accelerated terminal emulator", "cask"),
]

EDIT_TOOLS = [
    ("neovim", "nvim", "Hyperextensible Vim-based editor", "brew"),
    ("dawn", "dawn", "Distraction-free markdown editor", "brew"),
    ("glow", "glow", "Terminal markdown viewer", "brew"),
]

CLI_TOOLS = [
    ("bat", "bat", "Cat with syntax highlighting", "brew"),
    ("eza", "eza", "Modern ls with git integration", "brew"),
    ("fd", "fd", "Fast find respecting .gitignore", "brew"),
    ("ripgrep", "rg", "Blazingly fast grep", "brew"),
    ("zoxide", "z", "Smarter cd that learns", "brew"),
    ("difftastic", "difft", "Structural diff tool", "brew"),
    ("httpie", "http", "Human-friendly HTTP client", "brew"),
    ("tlrc", "tldr", "Simplified man pages", "brew"),
    ("thefuck", "fuck", "Correct previous command", "brew"),
]

FILES_TOOLS = [
    ("yazi", "yazi", "Blazing fast terminal file manager", "brew"),
    ("broot", "broot", "Interactive tree navigator", "brew"),
    ("fzf", "fzf", "Fuzzy finder for everything", "brew"),
    ("ncdu", "ncdu", "Disk usage analyzer", "brew"),
    ("btop", "btop", "Beautiful system monitor", "brew"),
    ("stow", "stow", "Symlink farm manager", "brew"),
    ("unar", "unar", "Universal archive extractor", "brew"),
    ("rename", "rename", "Batch file renaming", "brew"),
    ("rsync", "rsync", "Fast file synchronization", "brew"),
]

GIT_TOOLS = [
    ("git", "git", "Distributed version control", "brew"),
    ("git-lfs", "git lfs", "Large file storage for Git", "brew"),
    ("git-filter-repo", "git-filter-repo", "History rewriting tool", "brew"),
    ("gh", "gh", "GitHub CLI", "brew"),
    ("lazygit", "lazygit", "Simple terminal UI for git", "brew"),
    ("serie", "serie", "Rich git commit graph", "brew"),
    ("gitlogue", "gitlogue", "Cinematic commit replay", "brew"),
]

DATA_TOOLS = [
    ("jq", "jq", "JSON processor", "brew"),
    ("tabiew", "tabiew", "CSV/Parquet/JSON viewer with SQL", "brew"),
    ("mongosh", "mongosh", "MongoDB shell", "brew"),
    ("lnav", "lnav", "Log file navigator", "brew"),
    ("harlequin", "harlequin", "SQL IDE in the terminal", "uv"),
    ("pgadmin4", "pgadmin4", "PostgreSQL admin GUI", "cask"),
]

DEV_TOOLS = [
    ("watchexec", "watchexec", "File watcher for auto-execution", "brew"),
    ("hyperfine", "hyperfine", "Command-line benchmarking", "brew"),
    ("act", "act", "Run GitHub Actions locally", "brew"),
    ("vhs", "vhs", "Record terminal sessions as GIFs", "brew"),
    ("scooter", "scooter", "Interactive find-and-replace", "brew"),
    ("direnv", "direnv", "Per-directory environments", "brew"),
    ("universal-ctags", "ctags", "Code indexing", "brew"),
    ("postman", "postman", "API development platform", "cask"),
]

INFRA_TOOLS = [
    ("lima", "lima", "Linux VMs on macOS", "brew"),
    ("lazydocker", "lazydocker", "Docker TUI", "brew"),
    ("terraform", "terraform", "Infrastructure as code", "brew"),
    ("azure-cli", "az", "Azure command-line interface", "brew"),
]

LANG_TOOLS = [
    ("uv", "uv", "Fast Python package manager", "brew"),
    ("pixi", "pixi", "Conda-compatible env manager", "brew"),
    ("node", "node", "JavaScript runtime", "brew"),
    ("yarn", "yarn", "Node package manager", "brew"),
    ("bun", "bun", "Fast JS runtime & bundler", "script"),
    ("go", "go", "Go programming language", "brew"),
    ("rust", "cargo", "Rust programming language", "brew"),
    ("gum", "gum", "Glamorous shell scripts", "brew"),
]

AI_TOOLS = [
    ("opencode", "opencode", "AI coding agent CLI", "brew"),
    ("llm", "llm", "CLI for LLMs with plugins", "uv"),
    ("goose", "goose", "AI agent for development", "script"),
    ("llama.cpp", "llama", "Local LLM inference", "brew"),
    ("ollama", "ollama", "Local LLM runner", "cask"),
    ("lm-studio", "lm-studio", "LLM GUI application", "cask"),
]

GNU_TOOLS = [
    ("coreutils", "g*", "GNU core utilities", "brew"),
    ("findutils", "gfind", "GNU find, xargs", "brew"),
    ("diffutils", "gdiff", "GNU diff, cmp", "brew"),
    ("binutils", "gobjdump", "GNU binary utilities", "brew"),
    ("moreutils", "sponge", "Additional Unix utilities", "brew"),
    ("gnu-sed", "gsed", "GNU stream editor", "brew"),
    ("gnu-tar", "gtar", "GNU tape archive", "brew"),
    ("gawk", "gawk", "GNU awk", "brew"),
    ("grep", "ggrep", "GNU grep with color", "brew"),
    ("gnupg", "gpg", "GNU privacy guard", "brew"),
    ("wget", "wget", "Network downloader", "brew"),
]

MEDIA_TOOLS = [
    ("ffmpeg", "ffmpeg", "Media converter", "brew"),
    ("imagemagick", "convert", "Image manipulation", "brew"),
    ("poppler", "pdftotext", "PDF rendering utilities", "brew"),
    ("graphviz", "dot", "Graph visualization", "brew"),
    ("mermaid-cli", "mmdc", "Diagram rendering", "brew"),
    ("tectonic", "tectonic", "Modern LaTeX engine", "brew"),
    ("slides", "slides", "Terminal presentations", "brew"),
    ("figlet", "figlet", "ASCII art text", "brew"),
    ("toilet", "toilet", "ASCII art with fonts", "brew"),
]

APPS_TOOLS = [
    ("1password", "1password", "Password manager", "cask"),
    ("1password-cli", "op", "1Password CLI", "cask"),
    ("raycast", "raycast", "Spotlight replacement", "cask"),
    ("notion", "notion", "Note-taking & docs", "cask"),
    ("cleanshot", "cleanshot", "Screenshot tool", "cask"),
    ("espanso", "espanso", "Text expander", "cask"),
    ("hiddenbar", "hiddenbar", "Menu bar organizer", "cask"),
    ("shortcat", "shortcat", "Keyboard-driven UI", "cask"),
    ("arc", "arc", "Modern web browser", "cask"),
]

WM_TOOLS = [
    ("aerospace", "aerospace", "Tiling window manager", "cask"),
    ("skhd", "skhd", "Hotkey daemon", "brew"),
    ("alt-tab", "alt-tab", "Windows-style alt-tab", "cask"),
]

SYS_TOOLS = [
    ("wireguard", "wg", "VPN tools", "brew"),
    ("lulu", "lulu", "macOS firewall", "cask"),
    ("aldente", "aldente", "Battery management", "cask"),
    ("flux", "flux", "Night shift for eyes", "cask"),
]


# Mapping categories to their data
TOOL_MAP = {
    Category.SHELL: SHELL_TOOLS,
    Category.EDIT: EDIT_TOOLS,
    Category.CLI: CLI_TOOLS,
    Category.FILES: FILES_TOOLS,
    Category.VC: GIT_TOOLS,
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

ALL_TOOLS = sum(TOOL_MAP.values(), [])

# Install type badges
TYPE_BADGE = {
    "brew": "[green]brew[/]",
    "cask": "[blue]cask[/]",
    "uv": "[yellow]uv[/]",
    "cargo": "[red]cargo[/]",
    "npm": "[cyan]npm[/]",
    "script": "[magenta]script[/]",
    "builtin": "[dim]builtin[/]",
}


# ═══════════════════════════════════════════════════════════════════════════
# RICH CLI OUTPUT
# ═══════════════════════════════════════════════════════════════════════════

def show_tools(category: Category, tools: list[tuple[str, str, str, str]]) -> None:
    """Display a category of tools in a styled table with pagination if needed."""
    icon, title, desc = CATEGORY_META[category]
    
    table = Table(box=ROUNDED, border_style="blue", expand=True)
    table.add_column("Tool", style="cyan bold", width=15)
    table.add_column("Command", style="green", width=20)
    table.add_column("Description", width=35)
    table.add_column("Type", justify="right", width=8)

    for name, command, description, install_type in tools:
        badge = TYPE_BADGE.get(install_type, install_type)
        table.add_row(
            f"[cyan bold]{name}[/]",
            f"[green]{command}[/]",
            description,
            badge
        )

    panel = Panel(
        table,
        title=f"[blue bold]{icon}  {title}[/]",
        subtitle=f"[dim]{desc}[/]",
        title_align="center",
        border_style="blue"
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
        
        pager = subprocess.Popen(
            ["less", "-R", "-S"],
            stdin=subprocess.PIPE,
            text=True
        )
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
    for name, command, description, install_type in ALL_TOOLS:
        if name == tool_name or command == tool_name:
            # Find which category this tool belongs to
            cat_name = "Unknown"
            for cat, tools in TOOL_MAP.items():
                if any(t[0] == name for t in tools):
                    icon, title, _ = CATEGORY_META[cat]
                    cat_name = f"{icon}  {title}"
                    break

            main_table = Table(box=HEAVY, border_style="blue", show_header=False, width=80)
            main_table.add_column("Key", style="cyan bold", width=15)
            main_table.add_column("Value", style="white")

            main_table.add_row("Tool", f"[cyan bold]{name}[/]")
            main_table.add_row("Command", f"[green]{command}[/]")
            main_table.add_row("Description", description)
            main_table.add_row("Install Type", TYPE_BADGE.get(install_type, install_type))
            main_table.add_row("Category", cat_name)

            console.print()
            console.print(Panel(main_table, title="[blue bold]Tool Details[/]", border_style="blue"))
            console.print()
            return

    console.print(f"[red]Tool '{tool_name}' not found.[/]")


def show_help():
    """Display help information with category overview."""
    console.print("\n[cyan bold]Usage:[/]")
    console.print("  [green]tools -s git[/]        Show git tools")
    console.print("  [green]tools -s cli[/]        Show modern CLI tools")
    console.print("  [green]tools -d lazygit[/]    Describe lazygit")
    console.print("  [green]tools --tui[/]         Interactive browser")

    table = Table(title="[bold]Categories[/]", show_header=True, box=ROUNDED, border_style="blue")
    table.add_column("", style="cyan", width=3)
    table.add_column("Name", style="green bold")
    table.add_column("Description")
    table.add_column("Count", style="dim", justify="right")

    for cat in Category:
        icon, title, desc = CATEGORY_META[cat]
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
    from textual.widgets import DataTable, Footer, Header, Input, Static, ListView, ListItem, Label

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

        BINDINGS = [
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
                    *[ListItem(
                        Label(f"{CATEGORY_META[cat][0]}  {cat.value}"),
                        id=f"cat-{cat.value}"
                    ) for cat in Category],
                    id="category-list"
                )
            with Container(id="main"):
                yield Input(placeholder="Search tools... (press /)", id="search")
                with Container(id="table-container"):
                    yield DataTable(id="tool-table")
                yield Static("Select a tool to see details", id="details")
            yield Footer()

        def on_mount(self) -> None:
            table = self.query_one("#tool-table", DataTable)
            table.add_columns("Tool", "Command", "Description", "Type")
            table.cursor_type = "row"
            self.load_category(self.current_category)

        def load_category(self, category: Category) -> None:
            self.current_category = category
            self.showing_all = False
            table = self.query_one("#tool-table", DataTable)
            table.clear()

            tools = TOOL_MAP[category]
            filtered = self.filter_tools(tools)

            for name, command, description, install_type in filtered:
                table.add_row(name, command, description, install_type)

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
                for name, command, description, install_type in TOOL_MAP[cat]:
                    if (query in name.lower() or 
                        query in command.lower() or 
                        query in description.lower()):
                        results.append((name, command, description, install_type, cat))

            for name, command, description, install_type, cat in results:
                icon = CATEGORY_META[cat][0]
                table.add_row(name, command, f"{icon} {description}", install_type)

            self.query_one("#details", Static).update(
                f"[bold]󰍉  Search Results[/] — {len(results)} matches across all categories"
            )

        def filter_tools(self, tools: list) -> list:
            if not self.search_query:
                return tools
            query = self.search_query.lower()
            return [
                t for t in tools
                if query in t[0].lower() or query in t[1].lower() or query in t[2].lower()
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
                name, command, description, install_type = row
                # Find the category for this tool
                cat_info = ""
                for cat in Category:
                    if any(t[0] == name for t in TOOL_MAP[cat]):
                        icon, title, _ = CATEGORY_META[cat]
                        cat_info = f" [{title}]"
                        break
                badge = TYPE_BADGE.get(install_type, install_type)
                details = f"[cyan bold]{name}[/]{cat_info} → [green]{command}[/] ({badge})\n{description}"
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

@app.command()
def main(
    show: Optional[Category] = typer.Option(
        None, "--show", "-s", help="Show tools for a specific category"
    ),
    describe: str = typer.Option(
        None, "--describe", "-d", help="Describe a specific tool"
    ),
    tui: bool = typer.Option(
        False, "--tui", "-t", help="Launch interactive TUI browser"
    ),
):
    """
    Fox's Den - Explore your installed tools and packages.

    Categories:
      shell  - Terminal, prompt, multiplexer
      edit   - Text editors & writing
      cli    - Modern Unix replacements
      files  - File management & navigation
      git    - Version control tools
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
      tools -s git       # Show git tools
      tools -d lazygit   # Describe lazygit
      tools --tui        # Interactive browser
    """
    if tui:
        run_tui()
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
