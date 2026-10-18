#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.14"
# dependencies = [
#     "rich",
#     "typer",
#     "textual",
# ]
# ///

import re
from enum import Enum
from pathlib import Path
from typing import Annotated, ClassVar

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
    Category.GNU: ("󰌽", "File ops", "Verbose GNU file operations"),
    Category.FN: ("󰊕", "Functions", "Shell functions"),
}


# ═══════════════════════════════════════════════════════════════════════════
# ALIAS DATA
# ═══════════════════════════════════════════════════════════════════════════

# Read from the zsh config itself, so this list can never drift from the shell.
ZSH_CONFIG_DIR = Path(__file__).resolve().parent.parent / "zsh" / ".config" / "zsh"

SECTION_CATEGORIES = {
    "SHELL": Category.TERM,
    "EDITORS": Category.TERM,
    "TMUX": Category.TERM,
    "MODERN CLI REPLACEMENTS": Category.FILES,
    "SAFER FILE OPERATIONS (verbose)": Category.GNU,
    "GIT": Category.GIT,
    "DIRECTORY NAVIGATION": Category.NAV,
    "PACKAGE MANAGERS": Category.PKG,
    "macOS": Category.SYS,
    "FUNCTION SHORTCUTS": Category.FN,
}

ALIAS_PATTERN = re.compile(r"""^alias\s+([^=\s]+)=(['"])(.*)\2\s*(?:#\s*(.*))?$""")
FUNCTION_PATTERN = re.compile(r"^([A-Za-z_][\w-]*)\(\)\s*\{")
COMMENT_PATTERN = re.compile(r"^#\s?(.*)$")
BANNER_PREFIX = "#####"

Alias = tuple[str, str, str]


def parse_aliases(text: str) -> dict[Category, list[Alias]]:
    """Aliases grouped by section banner; description = trailing comment or sub-heading."""
    aliases: dict[Category, list[Alias]] = {category: [] for category in Category}
    category = Category.TERM
    subheading = ""
    previous_line = ""
    for raw_line in text.splitlines():
        line = raw_line.strip()
        comment = COMMENT_PATTERN.match(line)
        if comment and previous_line.startswith(BANNER_PREFIX):
            category = SECTION_CATEGORIES.get(comment.group(1), category)
            subheading = ""
        elif comment and not line.startswith(BANNER_PREFIX):
            subheading = comment.group(1)
        elif match := ALIAS_PATTERN.match(line):
            name, _, command, description = match.groups()
            aliases[category].append(
                (name, command, description or subheading.capitalize())
            )
        elif not line:
            subheading = ""
        previous_line = line
    return aliases


def parse_functions(text: str) -> list[Alias]:
    """Shell functions with the comment block right above them as description."""
    functions: list[Alias] = []
    comments: list[str] = []
    for raw_line in text.splitlines():
        line = raw_line.strip()
        if comment := COMMENT_PATTERN.match(line):
            comments.append(comment.group(1))
        elif match := FUNCTION_PATTERN.match(line):
            description = " ".join(comments).capitalize()
            functions.append((match.group(1), "function", description))
            comments = []
        else:
            comments = []
    return functions


def load_aliases() -> dict[Category, list[Alias]]:
    aliases = parse_aliases((ZSH_CONFIG_DIR / "aliases.zsh").read_text())
    aliases[Category.FN] += parse_functions(
        (ZSH_CONFIG_DIR / "functions.zsh").read_text()
    )
    return aliases


ALIAS_MAP = load_aliases()

ALL_ALIASES = [alias for aliases in ALIAS_MAP.values() for alias in aliases]


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
        border_style="blue",
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
        pager = subprocess.Popen(["less", "-R", "-S"], stdin=subprocess.PIPE, text=True)
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

            main_table = Table(
                box=HEAVY, border_style="blue", show_header=False, width=80
            )
            main_table.add_column("Key", style="cyan bold", width=15)
            main_table.add_column("Value", style="white")

            main_table.add_row("Alias", f"[cyan bold]{name}[/]")
            main_table.add_row("Command", f"[green]{command}[/]")
            main_table.add_row("Description", description)
            main_table.add_row("Category", cat_name)

            console.print()
            console.print(
                Panel(
                    main_table, title="[blue bold]Alias Details[/]", border_style="blue"
                )
            )
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

    table = Table(
        title="[bold]Categories[/]", show_header=True, box=ROUNDED, border_style="blue"
    )
    table.add_column("", style="cyan", width=3)
    table.add_column("Name", style="green bold")
    table.add_column("Description")
    table.add_column("Count", style="dim", justify="right")

    for cat in Category:
        icon, _, desc = CATEGORY_META[cat]
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

    class AliasApp(App):
        """Interactive alias browser TUI."""

        TITLE = "Fox's Aliases"

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
            self.current_category = Category.GIT
            self.search_query = ""
            self.showing_all = False  # True when showing cross-category search results

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
                    if (
                        query in name.lower()
                        or query in command.lower()
                        or query in description.lower()
                    ):
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
                (n, c, d)
                for n, c, d in aliases
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
                        _, title, _ = CATEGORY_META[cat]
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
    show: Annotated[
        Category | None,
        typer.Option("--show", "-s", help="Show aliases for a specific category"),
    ] = None,
    describe: Annotated[
        str | None, typer.Option("--describe", "-d", help="Describe a specific alias")
    ] = None,
    tui: Annotated[
        bool, typer.Option("--tui", "-t", help="Launch interactive TUI browser")
    ] = False,
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
      gnu    - Verbose GNU file operations
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
