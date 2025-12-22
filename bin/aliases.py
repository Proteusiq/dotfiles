#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.8"
# dependencies = [
#     "rich",
#     "typer",
#     "textual",
# ]
# ///

from enum import Enum
from typing import Optional

import typer
from rich.box import HEAVY, ROUNDED
from rich.console import Console
from rich.panel import Panel
from rich.table import Table

console = Console()
app = typer.Typer(help="CLI tool to display and manage aliases")


# ═══════════════════════════════════════════════════════════════════════════
# CATEGORIES with Nerd Font Icons
# ═══════════════════════════════════════════════════════════════════════════

class Category(str, Enum):
    GIT = "git"
    FILES = "files"
    NAV = "nav"
    TERM = "term"
    PKG = "pkg"
    SYS = "sys"
    GNU = "gnu"
    FN = "fn"


# Category metadata: (icon, title, description)
CATEGORY_META = {
    Category.GIT: ("󰊢", "Git", "Version control shortcuts"),
    Category.FILES: ("󰉋", "Files", "Modern file operations"),
    Category.NAV: ("󰉖", "Navigation", "Directory jumping"),
    Category.TERM: ("󰆍", "Terminal", "Terminal & shell"),
    Category.PKG: ("󰏗", "Packages", "Package managers"),
    Category.SYS: ("󰒓", "System", "macOS & system"),
    Category.GNU: ("󰌽", "GNU", "GNU coreutils"),
    Category.FN: ("󰊕", "Functions", "Shell functions"),
}


# ═══════════════════════════════════════════════════════════════════════════
# ALIAS DATA
# ═══════════════════════════════════════════════════════════════════════════

GIT_ALIASES = [
    ("g", "git", "Git command"),
    ("ga", "git add", "Add file contents to index"),
    ("gaa", "git add .", "Add all changes"),
    ("gap", "git add --patch", "Interactively stage changes"),
    ("gau", "git add --update", "Update tracked files"),
    ("gb", "git branch", "List/create branches"),
    ("gbd", "git branch -d", "Delete branch"),
    ("gbdd", "git branch -D", "Force delete branch"),
    ("gbm", "git branch --merged", "List merged branches"),
    ("gbnm", "git branch --no-merged", "List unmerged branches"),
    ("gc", "git commit -am", "Commit with message"),
    ("gcm", "git commit --amend --message", "Amend last commit"),
    ("gcb", "git checkout -b", "Create and switch branch"),
    ("gch", "git checkout", "Switch branches"),
    ("gchp", "git cherry-pick", "Apply commits"),
    ("gcl", "git clone", "Clone repository"),
    ("gd", "git diff --color", "Show changes"),
    ("gdt", "git difftool", "Diff with tool"),
    ("gf", "git fetch", "Download objects/refs"),
    ("gg", "git grep", "Search patterns"),
    ("ggl", "git grep --line-number", "Search with line numbers"),
    ("gl", "git log", "Show commit logs"),
    ("glg", "git log --graph", "Log with graph"),
    ("glo", "git log --oneline", "Compact log"),
    ("gm", "git merge", "Merge branches"),
    ("gma", "git merge --abort", "Abort merge"),
    ("gmc", "git merge --continue", "Continue merge"),
    ("gp", "git push", "Push to remote"),
    ("gpu", "git push -u origin", "Push and set upstream"),
    ("gpl", "git pull", "Pull from remote"),
    ("gr", "git remote", "Manage remotes"),
    ("gra", "git remote add origin", "Add remote"),
    ("gre", "git rebase", "Rebase commits"),
    ("gs", "git status", "Show status"),
    ("gst", "git stash", "Stash changes"),
    ("gsa", "git stash apply", "Apply stash"),
    ("gsp", "git stash pop", "Pop stash"),
    ("gsd", "git stash drop", "Drop stash"),
    ("gw", "git whatchanged", "Show change logs"),
    ("changelog", "git log --pretty=format:...", "Generate changelog"),
    ("undopush", "git push -f origin HEAD^:master", "Undo last push"),
    ("gitfix", "git diff --name-only | xargs code", "Open changed files"),
]

FILES_ALIASES = [
    ("cat", "bat", "View files with syntax highlighting"),
    ("ls", "eza --icons=always", "List with icons"),
    ("ll", "eza -l", "Long listing"),
    ("la", "eza -la", "Long listing with hidden"),
    ("tree", "eza --tree", "Tree view"),
    ("top", "btop", "System monitor"),
    ("du", "ncdu", "Disk usage analyzer"),
    ("fd", "fd", "Find files (fast)"),
    ("rg", "ripgrep", "Search file contents"),
    ("cp", "gcp -v", "Copy files (verbose)"),
    ("mv", "gmv -v", "Move files (verbose)"),
    ("rm", "grm -v", "Remove files (verbose)"),
    ("mkdir", "gmkdir -v", "Create directories"),
    ("rmdir", "grmdir -v", "Remove directories"),
    ("chmod", "gchmod -v", "Change permissions"),
    ("chown", "gchown -v", "Change ownership"),
    ("ln", "gln", "Create links"),
    ("ln-sym", "gln -nsf", "Create symlinks"),
    ("touch", "gtouch", "Update timestamps"),
    ("rename", "rename", "Batch rename files"),
]

NAV_ALIASES = [
    ("dev", "cd ~/dev", "Development directory"),
    ("work", "cd ~/dev/work", "Work directory"),
    ("desk", "cd ~/desktop", "Desktop"),
    ("docs", "cd ~/documents", "Documents"),
    ("dl", "cd ~/downloads", "Downloads"),
    ("home", "cd ~", "Home directory"),
    ("dots", "cd ~/dotfiles", "Dotfiles directory"),
    ("..", "cd ..", "Parent directory"),
    ("...", "cd ../..", "Two levels up"),
    ("z", "zoxide", "Smart directory jump"),
]

TERM_ALIASES = [
    ("c", "clear", "Clear screen"),
    ("x", "exit", "Exit shell"),
    ("reload", "source ~/.zshrc", "Reload shell config"),
    ("iexit", "tmux kill-session", "Kill tmux session"),
    ("ix", "iexit", "Kill tmux session (short)"),
    ("ikill", "tmux kill-server", "Kill tmux server"),
    ("ik", "ikill", "Kill tmux server (short)"),
    ("iswitch", "tmux choose-session", "Switch tmux session"),
    ("ipop", "tmux display-popup", "Tmux popup"),
    ("f", "fuck", "Correct last command"),
    ("clip", "pbcopy", "Copy to clipboard"),
    ("paste", "pbpaste", "Paste from clipboard"),
]

PKG_ALIASES = [
    # Yarn
    ("y", "yarn", "Yarn command"),
    ("ya", "yarn add", "Add package"),
    ("yad", "yarn add --dev", "Add dev package"),
    ("yga", "yarn global add", "Add global package"),
    ("yr", "yarn run", "Run script"),
    ("ys", "yarn start", "Start project"),
    ("yt", "yarn test", "Run tests"),
    ("yup", "yarn upgrade", "Upgrade packages"),
    ("yrm", "yarn remove", "Remove package"),
    # PNPM
    ("pn", "pnpm", "PNPM command"),
    ("pna", "pnpm add", "Add package"),
    ("pnr", "pnpm run", "Run script"),
    ("pni", "pnpm install", "Install packages"),
    # Python
    ("pip", "uv pip", "Python packages (via uv)"),
    ("pixi", "pixi", "Conda-compatible env manager"),
]

SYS_ALIASES = [
    ("show", "defaults write ... AppleShowAllFiles true", "Show hidden files"),
    ("hide", "defaults write ... AppleShowAllFiles false", "Hide hidden files"),
    ("showdesktop", "defaults write ... CreateDesktop true", "Show desktop icons"),
    ("hidedesktop", "defaults write ... CreateDesktop false", "Hide desktop icons"),
    ("spotoff", "sudo mdutil -a -i off", "Disable Spotlight"),
    ("spoton", "sudo mdutil -a -i on", "Enable Spotlight"),
    ("afk", "CGSession -suspend", "Lock screen"),
    ("stfu", "osascript -e 'set volume output muted true'", "Mute volume"),
    ("restart", "sudo reboot", "Reboot system"),
    ("bye", "sudo shutdown -r now", "Shutdown now"),
    ("rm_ds", "find . -name '*.DS_Store' -delete", "Remove .DS_Store files"),
    ("emptytrash", "rm -rf ~/.Trash/*", "Empty trash"),
    ("clean", "clean_pycache", "Remove __pycache__"),
]

GNU_ALIASES = [
    ("tail", "gtail -F", "Follow log files"),
    ("split", "gsplit", "Split files"),
    ("sum", "gsum", "Checksum files"),
    ("md5sum", "gmd5sum", "MD5 checksum"),
    ("sha1sum", "gsha1sum", "SHA1 checksum"),
    ("cut", "gcut", "Cut columns"),
    ("join", "gjoin", "Join files"),
    ("shred", "gshred", "Secure delete"),
    ("readlink", "greadlink", "Read symlinks"),
    ("df", "gdf", "Disk free space"),
    ("stat", "gstat", "File statistics"),
    ("sync", "gsync", "Sync filesystem"),
    ("truncate", "gtruncate", "Truncate files"),
    ("echo", "gecho", "Echo text"),
    ("tee", "gtee", "Pipe to file and stdout"),
    ("awk", "gawk", "Pattern processing"),
    ("grep", "ggrep --color", "Search with color"),
    ("sed", "gsed", "Stream editor"),
    ("find", "gfind", "Find files"),
    ("xargs", "gxargs", "Build command lines"),
    ("tar", "gtar", "Archive files"),
    ("which", "gwhich", "Locate command"),
]

FN_ALIASES = [
    # Editors
    ("v", "nvim", "Open Neovim"),
    ("vi", "nvim", "Open Neovim"),
    ("vim", "nvim", "Open Neovim"),
    ("n", "nvim", "Open Neovim"),
    # Functions
    ("take", "mkdir && cd", "Create and enter directory"),
    ("tk", "take", "Create and enter (short)"),
    ("up", "cd ..", "Go up N directories"),
    ("yy", "yazi wrapper", "File manager with cd on exit"),
    ("gi", "gitignore.io", "Generate .gitignore"),
    ("create-repo", "gh repo create", "Create GitHub repo"),
    ("rename-branch", "git branch -m", "Rename git branch"),
    ("gifify", "ffmpeg + gifsicle", "Create GIFs from video"),
    ("activate", "source venv/bin/activate", "Activate Python venv"),
    ("setenv", "export from .env", "Load .env file"),
    ("unsetenv", "unset from .env", "Unload .env file"),
    ("update", "install.sh", "Run dotfiles installer"),
    ("o", "open .", "Open current directory"),
    ("t", "touch", "Create empty file"),
    ("md", "mkdir", "Create directory"),
    ("x+", "chmod +x", "Make executable"),
    ("get", "curl -O -L", "Download file"),
]


# Mapping categories to their data
ALIAS_MAP = {
    Category.GIT: GIT_ALIASES,
    Category.FILES: FILES_ALIASES,
    Category.NAV: NAV_ALIASES,
    Category.TERM: TERM_ALIASES,
    Category.PKG: PKG_ALIASES,
    Category.SYS: SYS_ALIASES,
    Category.GNU: GNU_ALIASES,
    Category.FN: FN_ALIASES,
}

ALL_ALIASES = sum(ALIAS_MAP.values(), [])


# ═══════════════════════════════════════════════════════════════════════════
# RICH CLI OUTPUT
# ═══════════════════════════════════════════════════════════════════════════

def add_aliases(category: Category, aliases: list[tuple[str, str, str]]) -> None:
    """Display a category of aliases in a styled table with pagination if needed."""
    import os
    import shutil
    import subprocess
    from io import StringIO
    
    icon, title, desc = CATEGORY_META[category]
    
    table = Table(box=ROUNDED, border_style="blue", expand=True)
    table.add_column("Alias", style="cyan bold", width=15)
    table.add_column("Command", style="green", width=35)
    table.add_column("Description")

    for name, command, description in aliases:
        table.add_row(f"[cyan bold]{name}[/]", f"[green]{command}[/]", description)

    panel = Panel(
        table,
        title=f"[blue bold]{icon}  {title}[/]",
        subtitle=f"[dim]{desc}[/]",
        title_align="center",
        border_style="blue"
    )
    
    # Use pager if content exceeds terminal height and we're in a TTY
    terminal_height = shutil.get_terminal_size().lines
    estimated_lines = len(aliases) * 2 + 6
    
    if estimated_lines > terminal_height and os.isatty(1):
        # Render to string with ANSI codes
        string_io = StringIO()
        temp_console = Console(file=string_io, force_terminal=True)
        temp_console.print()
        temp_console.print(panel)
        temp_console.print()
        output = string_io.getvalue()
        
        # Pipe through less with ANSI support
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


def show_category_aliases(category: Category):
    """Display aliases for a specific category."""
    if category in ALIAS_MAP:
        add_aliases(category, ALIAS_MAP[category])


def show_alias_description(alias_name: str):
    """Show detailed description for a specific alias."""
    for name, command, description in ALL_ALIASES:
        if name == alias_name:
            # Find which category this alias belongs to
            cat_name = "Unknown"
            for cat, aliases in ALIAS_MAP.items():
                if any(a[0] == alias_name for a in aliases):
                    icon, title, _ = CATEGORY_META[cat]
                    cat_name = f"{icon}  {title}"
                    break

            main_table = Table(box=HEAVY, border_style="blue", show_header=False, width=80)
            main_table.add_column("Key", style="cyan bold", width=15)
            main_table.add_column("Value", style="white")

            main_table.add_row("Alias", f"[cyan bold]{name}[/]")
            main_table.add_row("Command", f"[green]{command}[/]")
            main_table.add_row("Description", description)
            main_table.add_row("Category", cat_name)

            console.print()
            console.print(Panel(main_table, title="[blue bold]Alias Details[/]", border_style="blue"))
            console.print()
            return

    console.print(f"[red]Alias '{alias_name}' not found.[/]")


def show_help():
    """Display help information with category overview."""
    console.print("\n[cyan bold]Usage:[/]")
    console.print("  [green]aliases -s git[/]       Show git aliases")
    console.print("  [green]aliases -s files[/]    Show file operation aliases")
    console.print("  [green]aliases -d ga[/]       Describe 'ga' alias")
    console.print("  [green]aliases --tui[/]       Interactive browser")

    table = Table(title="[bold]Categories[/]", show_header=True, box=ROUNDED, border_style="blue")
    table.add_column("", style="cyan", width=3)
    table.add_column("Name", style="green bold")
    table.add_column("Description")
    table.add_column("Count", style="dim", justify="right")

    for cat in Category:
        icon, title, desc = CATEGORY_META[cat]
        count = len(ALIAS_MAP[cat])
        table.add_row(icon, cat.value, desc, str(count))

    console.print()
    console.print(table)
    console.print()
    console.print("[dim]Tip: Use [green]aliases --tui[/] for interactive browsing![/]")


# ═══════════════════════════════════════════════════════════════════════════
# TEXTUAL TUI MODE
# ═══════════════════════════════════════════════════════════════════════════

def run_tui():
    """Launch the Textual TUI application."""
    from textual.app import App, ComposeResult
    from textual.binding import Binding
    from textual.containers import Container
    from textual.widgets import DataTable, Footer, Header, Input, Static, ListView, ListItem, Label

    class AliasApp(App):
        """Interactive alias browser TUI."""

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
            self.current_category = Category.GIT
            self.search_query = ""
            self.showing_all = False  # True when showing cross-category search results

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
                yield Input(placeholder="Search aliases... (press /)", id="search")
                with Container(id="table-container"):
                    yield DataTable(id="alias-table")
                yield Static("Select an alias to see details", id="details")
            yield Footer()

        def on_mount(self) -> None:
            table = self.query_one("#alias-table", DataTable)
            table.add_columns("Alias", "Command", "Description")
            table.cursor_type = "row"
            self.load_category(self.current_category)

        def load_category(self, category: Category) -> None:
            self.current_category = category
            self.showing_all = False
            table = self.query_one("#alias-table", DataTable)
            table.clear()

            aliases = ALIAS_MAP[category]
            filtered = self.filter_aliases(aliases)

            for name, command, description in filtered:
                table.add_row(name, command, description)

            icon, title, desc = CATEGORY_META[category]
            self.query_one("#details", Static).update(
                f"[bold]{icon}  {title}[/] — {desc} ({len(filtered)} aliases)"
            )

        def load_all_matching(self) -> None:
            """Load aliases from ALL categories matching the search query."""
            self.showing_all = True
            table = self.query_one("#alias-table", DataTable)
            table.clear()

            query = self.search_query.lower()
            results = []
            for cat in Category:
                for name, command, description in ALIAS_MAP[cat]:
                    if query in name.lower() or query in command.lower() or query in description.lower():
                        results.append((name, command, description, cat))

            for name, command, description, cat in results:
                icon = CATEGORY_META[cat][0]
                table.add_row(name, command, f"{icon} {description}")

            self.query_one("#details", Static).update(
                f"[bold]󰍉  Search Results[/] — {len(results)} matches across all categories"
            )

        def filter_aliases(self, aliases: list) -> list:
            if not self.search_query:
                return aliases
            query = self.search_query.lower()
            return [
                (n, c, d) for n, c, d in aliases
                if query in n.lower() or query in c.lower() or query in d.lower()
            ]

        def on_list_view_selected(self, event: ListView.Selected) -> None:
            item_id = event.item.id
            if item_id and item_id.startswith("cat-"):
                cat_name = item_id.replace("cat-", "")
                self.load_category(Category(cat_name))

        def on_data_table_row_selected(self, event: DataTable.RowSelected) -> None:
            table = self.query_one("#alias-table", DataTable)
            row_key = event.row_key
            row = table.get_row(row_key)
            if row:
                name, command, description = row
                # Find the category for this alias
                cat_info = ""
                for cat in Category:
                    if any(a[0] == name for a in ALIAS_MAP[cat]):
                        icon, title, _ = CATEGORY_META[cat]
                        cat_info = f" [{title}]"
                        break
                details = f"[cyan bold]{name}[/]{cat_info} → [green]{command}[/]\n{description}"
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
            table = self.query_one("#alias-table", DataTable)
            table.action_cursor_down()

        def action_cursor_up(self) -> None:
            table = self.query_one("#alias-table", DataTable)
            table.action_cursor_up()

    app = AliasApp()
    app.run()


# ═══════════════════════════════════════════════════════════════════════════
# MAIN CLI
# ═══════════════════════════════════════════════════════════════════════════

@app.command()
def main(
    show: Optional[Category] = typer.Option(
        None, "--show", "-s", help="Show aliases for a specific category"
    ),
    describe: str = typer.Option(
        None, "--describe", "-d", help="Describe a specific alias"
    ),
    tui: bool = typer.Option(
        False, "--tui", "-t", help="Launch interactive TUI browser"
    ),
):
    """
    CLI tool to display and manage shell aliases and functions.

    Categories:
      git    - Version control shortcuts
      files  - Modern file operations  
      nav    - Directory jumping
      term   - Terminal & shell
      pkg    - Package managers
      sys    - macOS & system
      gnu    - GNU coreutils
      fn     - Shell functions

    Examples:
      aliases              # Show categories
      aliases -s git       # Show git aliases
      aliases -d ga        # Describe 'ga' alias
      aliases --tui        # Interactive browser
    """
    if tui:
        run_tui()
        return

    if describe:
        show_alias_description(describe)
        return

    if show:
        show_category_aliases(show)
        return

    show_help()


if __name__ == "__main__":
    app()
