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


class Category(str, Enum):
    GIT = "git"
    COREUTILS = "coreutils"
    YARN = "yarn"
    PNPM = "pnpm"
    SHORTCUTS = "shortcuts"
    EDITORS = "editors"
    NAVIGATION = "navigation"
    MODERN = "modern"
    TMUX = "tmux"
    MACOS = "macos"
    FUNCTIONS = "functions"


# ═══════════════════════════════════════════════════════════════════════════
# ALIAS DATA
# ═══════════════════════════════════════════════════════════════════════════

GIT_ALIASES = [
    ("g", "git", "Use git"),
    ("ga", "git add", "Add file contents to the index"),
    ("gb", "git branch", "List, create, or delete branches"),
    ("gf", "git fetch", "Download objects and refs from another repository"),
    ("gg", "git grep", "Print lines matching a pattern"),
    ("gl", "git log", "Show commit logs"),
    ("gm", "git merge", "Join two or more development histories together"),
    ("gr", "git remote", "Manage set of tracked repositories"),
    ("gs", "git status", "Show the working tree status"),
    ("gw", "git whatchanged", "Show logs with difference each commit introduces"),
    ("gmc", "git merge --continue", "Continue the merge process"),
    ("gma", "git merge --abort", "Abort the merge process"),
    ("gpl", "git pull", "Fetch from and integrate with another repository or a local branch"),
    ("gaa", "git add .", "Add current directory contents to the index"),
    ("gap", "git add --patch", "Interactively add changes to the index"),
    ("gau", "git add --update", "Update the index with the current content found in the working tree"),
    ("gbe", "git branch --edit-description", "Edit the description for the branch"),
    ("gbd", "git branch -d", "Delete a branch"),
    ("gbdd", "git branch -D", "Force delete a branch"),
    ("gch", "git checkout", "Switch branches or restore working tree files"),
    ("gcb", "git checkout -b", "Create and switch to a new branch"),
    ("gbm", "git branch --merged", "List branches that have been merged"),
    ("gbnm", "git branch --no-merged", "List branches that have not been merged"),
    ("gchp", "git cherry-pick", "Apply the changes introduced by some existing commits"),
    ("gcl", "git clone", "Clone a repository into a new directory"),
    ("gc", "git commit -am", "Commit changes with message"),
    ("gcm", "git commit --amend --message", "Amend the last commit with a new message"),
    ("gdt", "git difftool", "Show changes using common diff tools"),
    ("gd", "git diff --color", "Show changes between commits, commit and working tree, etc"),
    ("gitfix", "git diff --name-only | uniq | xargs code", "Open changed files in VSCode"),
    ("ggl", "git grep --line-number", "Print lines matching a pattern with line numbers"),
    ("ggg", "git grep --break --heading --line-number", "Print lines matching a pattern with breaks and headings"),
    ("glg", "git log --graph", "Show commit logs with a graph"),
    ("glo", "git log --oneline", "Show commit logs as a single line per commit"),
    ("changelog", 'git log --pretty=format:"%h %ad%x09%an%x09%s" --date=short', "Generate a changelog"),
    ("gp", "git push", "Update remote refs along with associated objects"),
    ("gpu", "git push -u origin", "Push the branch and set remote as upstream"),
    ("undopush", "git push -f origin HEAD^:master", "Undo the last push"),
    ("gre", "git rebase", "Reapply commits on top of another base tip"),
    ("gra", "git remote add origin", "Add a new remote"),
    ("gst", "git stash", "Stash the changes in a dirty working directory away"),
    ("gsa", "git stash apply", "Apply the changes recorded in a stash"),
    ("gsp", "git stash pop", "Apply the changes recorded in a stash and remove it from the stash list"),
    ("gsd", "git stash drop", "Remove a single stash entry from the list"),
    ("gbi", "git browse -- issues", "Open the issues page of the repository in the browser"),
    ("gpr", "git pull-request", "Create a pull request"),
]

COREUTILS_ALIASES = [
    ("tail", "gtail -F", "Follow log rotations"),
    ("split", "gsplit", "Split a file into pieces"),
    ("csplit", "gcsplit", "Split a file into context-determined pieces"),
    ("sum", "gsum", "Checksum and count the blocks in a file"),
    ("cksum", "cksum", "Checksum and count the bytes in a file"),
    ("md5sum", "gmd5sum", "Compute and check MD5 message digest"),
    ("sha1sum", "gsha1sum", "Compute and check SHA1 message digest"),
    ("cut", "gcut", "Remove sections from each line of files"),
    ("join", "gjoin", "Join lines of two files on a common field"),
    ("cp", "gcp -v", "Copy files and directories"),
    ("mv", "gmv -v", "Move files"),
    ("rm", "grm -v", "Remove files or directories"),
    ("shred", "gshred", "Overwrite a file to hide its contents and optionally delete it"),
    ("link", "glink", "Make a hard link between files"),
    ("unlink", "gunlink", "Call the unlink function to remove the specified file"),
    ("mkdir", "gmkdir -v", "Create directories"),
    ("rmdir", "grmdir -v", "Remove empty directories"),
    ("readlink", "greadlink", "Print value of a symbolic link or canonical file name"),
    ("chmod", "gchmod -v", "Change file modes or Access Control Lists"),
    ("chown", "gchown -v", "Change file owner and group"),
    ("chgrp", "gchgrp -v", "Change group ownership"),
    ("touch", "gtouch", "Change file timestamps"),
    ("df", "gdf", "Report file system disk space usage"),
    ("stat", "gstat", "Display file or file system status"),
    ("sync", "gsync", "Synchronize cached writes to persistent storage"),
    ("truncate", "gtruncate", "Shrink or extend the size of a file to the specified size"),
    ("echo", "gecho", "Display a line of text"),
    ("tee", "gtee", "Read from standard input and write to standard output and files"),
    ("awk", "gawk", "Pattern scanning and processing language"),
    ("grep", "ggrep --color", "Print lines matching a pattern with color"),
    ("sed", "gsed", "Stream editor for filtering and transforming text"),
    ("ln", "gln", "Make links between files"),
    ("ln-sym", "gln -nsf", "Create symbolic links"),
    ("find", "gfind", "Search for files in a directory hierarchy"),
    ("locate", "glocate", "Find files by name"),
    ("updatedb", "gupdatedb", "Update a database for mlocate"),
    ("xargs", "gxargs", "Build and execute command lines from standard input"),
    ("tar", "gtar", "Archive utility"),
    ("which", "gwhich", "Locate a command"),
]

YARN_ALIASES = [
    ("y", "yarn", "Manage JavaScript projects"),
    ("yi", "yarn init", "Create a new Yarn project"),
    ("ya", "yarn add", "Add a package"),
    ("yad", "yarn add --dev", "Add a dev package"),
    ("yga", "yarn global add", "Add a global package"),
    ("yr", "yarn run", "Run a defined package script"),
    ("ys", "yarn start", "Start a project"),
    ("yis", "yarn install && yarn start", "Install dependencies and start the project"),
    ("yrm", "yarn remove", "Remove a package"),
    ("yup", "yarn upgrade", "Upgrade dependencies"),
    ("ycl", "yarn clean", "Clean the project"),
    ("ych", "yarn check", "Check for outdated or missing dependencies"),
    ("yt", "yarn test", "Run tests"),
    ("ycc", "yarn cache clean", "Clean the yarn cache"),
]

PNPM_ALIASES = [
    ("pn", "pnpm", "Manage JavaScript projects with pnpm"),
    ("pna", "pnpm add", "Add a package with pnpm"),
    ("pnr", "pnpm run", "Run a script with pnpm"),
    ("pni", "pnpm install", "Install dependencies with pnpm"),
]

SHORTCUTS = [
    ("c", "clear", "Clear the terminal screen"),
    ("x", "exit", "Exit the shell"),
    ("o", "open .", "Open the current directory"),
    ("t", "touch", "Create empty files"),
    ("md", "mkdir", "Create directories"),
    ("x+", "chmod +x", "Make a file executable"),
    ("reload", "source ~/.zshrc", "Reload the shell configuration"),
    ("clip", "pbcopy", "Copy to clipboard"),
    ("paste", "pbpaste", "Paste from clipboard"),
    ("get", "curl -O -L", "Download a file using curl"),
]

EDITORS = [
    ("v", "nvim", "Open Neovim"),
    ("vi", "nvim", "Open Neovim"),
    ("vim", "nvim", "Open Neovim"),
    ("n", "nvim", "Open Neovim"),
]

NAVIGATION = [
    ("dev", "cd ~/dev", "Change to development directory"),
    ("work", "cd ~/dev/work", "Change to work directory"),
    ("desk", "cd ~/desktop", "Change to desktop directory"),
    ("docs", "cd ~/documents", "Change to documents directory"),
    ("dl", "cd ~/downloads", "Change to downloads directory"),
    ("home", "cd ~", "Change to home directory"),
    ("dots", "cd ~/dotfiles", "Change to dotfiles directory"),
]

MODERN_CLI = [
    ("cat", "bat", "Use bat for displaying file contents"),
    ("ls", "eza --icons=always", "Use eza for directory listing with icons"),
    ("ll", "eza -l", "Long listing with eza"),
    ("la", "eza -la", "Long listing including hidden files"),
    ("tree", "eza --tree", "Tree view with eza"),
    ("top", "btop", "Use btop for system monitoring"),
    ("du", "ncdu", "Use ncdu for disk usage analysis"),
]

TMUX_ALIASES = [
    ("iexit", "tmux kill-session", "Exit current tmux session"),
    ("ix", "iexit", "Alias for iexit"),
    ("ikill", "tmux kill-server", "Kill tmux server (all sessions)"),
    ("ik", "ikill", "Alias for ikill"),
    ("iswitch", "tmux choose-session", "Show tmux session picker"),
    ("ipop", "tmux display-popup", "Open tmux popup in current directory"),
]

MACOS_ALIASES = [
    ("show", "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder", "Show hidden files in Finder"),
    ("hide", "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder", "Hide hidden files in Finder"),
    ("showdesktop", "defaults write com.apple.finder CreateDesktop -bool true && killall Finder", "Show desktop icons"),
    ("hidedesktop", "defaults write com.apple.finder CreateDesktop -bool false && killall Finder", "Hide desktop icons"),
    ("spotoff", "sudo mdutil -a -i off", "Turn off Spotlight indexing"),
    ("spoton", "sudo mdutil -a -i on", "Turn on Spotlight indexing"),
    ("afk", "CGSession -suspend", "Lock screen when going AFK"),
    ("stfu", "osascript -e 'set volume output muted true'", "Mute the system volume"),
    ("restart", "sudo reboot", "Reboot the system"),
    ("bye", "sudo shutdown -r now", "Restart the system immediately"),
    ("rm_ds", "find . -name '*.DS_Store' -type f -ls -delete", "Remove .DS_Store files"),
    ("xcodepurge", "rm -rf ~/Library/Developer/Xcode/DerivedData", "Remove cached Xcode build data"),
    ("chromekill", "ps ux | grep ... | xargs kill", "Kill all Chrome tabs to free memory"),
    ("mergepdf", "join.py", "Merge PDFs using Automator"),
]

FUNCTIONS = [
    ("take", "mkdir && cd", "Create a directory and change into it"),
    ("tk", "take", "Alias for take"),
    ("up", "cd ..", "Go up N parent directories"),
    ("yy", "yazi wrapper", "Open yazi, cd to dir on exit"),
    ("git", "smart git clone", "Clone a repository and cd into it"),
    ("gi", "gitignore.io", "Generate .gitignore from templates"),
    ("create-repo", "GitHub repo", "Create a new GitHub repository"),
    ("rename-branch", "git branch -m", "Rename a git branch locally and remotely"),
    ("gifify", "ffmpeg + gifsicle", "Create animated gifs from video files"),
    ("emptytrash", "rm -rf ~/.Trash", "Empty system trashes"),
    ("activate", "source venv/bin/activate", "Activate Python venv in current or parent dir"),
    ("setenv", "export from .env", "Load .env file into environment"),
    ("unsetenv", "unset from .env", "Unload .env variables from environment"),
    ("clean", "clean_pycache", "Remove __pycache__ directories"),
    ("update", "install.sh", "Run dotfiles install script"),
    ("f", "fuck", "Use thefuck for command corrections"),
    ("pip", "uv pip", "Use uv for pip operations"),
]

# Mapping for easy access
ALIAS_MAP = {
    Category.GIT: ("Git Aliases", GIT_ALIASES),
    Category.COREUTILS: ("Coreutils Aliases", COREUTILS_ALIASES),
    Category.YARN: ("Yarn Aliases", YARN_ALIASES),
    Category.PNPM: ("PNPM Aliases", PNPM_ALIASES),
    Category.SHORTCUTS: ("Shortcuts", SHORTCUTS),
    Category.EDITORS: ("Editors", EDITORS),
    Category.NAVIGATION: ("Directory Navigation", NAVIGATION),
    Category.MODERN: ("Modern CLI Replacements", MODERN_CLI),
    Category.TMUX: ("Tmux", TMUX_ALIASES),
    Category.MACOS: ("macOS Specific", MACOS_ALIASES),
    Category.FUNCTIONS: ("Functions", FUNCTIONS),
}

ALL_ALIASES = (
    GIT_ALIASES + COREUTILS_ALIASES + YARN_ALIASES + PNPM_ALIASES +
    SHORTCUTS + EDITORS + NAVIGATION + MODERN_CLI + TMUX_ALIASES +
    MACOS_ALIASES + FUNCTIONS
)


# ═══════════════════════════════════════════════════════════════════════════
# RICH CLI OUTPUT (default mode)
# ═══════════════════════════════════════════════════════════════════════════

def print_alias(name: str, command: str, description: str, table: Table) -> None:
    """Add an alias to the table."""
    table.add_row(f"[cyan bold]{name}[/]", f"[green]{command}[/]", description)


def add_aliases(category: str, aliases: list[tuple[str, str, str]]) -> None:
    """Display a category of aliases in a single table."""
    table = Table(box=ROUNDED, border_style="blue", expand=True)
    table.add_column("Alias", style="cyan bold", width=15)
    table.add_column("Command", style="green", width=30)
    table.add_column("Description")

    for name, command, description in aliases:
        print_alias(name, command, description, table)

    console.print()
    console.print(Panel(table, title=f"[blue bold]{category}[/]", title_align="center", border_style="blue"))
    console.print()


def show_category_aliases(category: Category):
    """Display aliases for a specific category."""
    if category in ALIAS_MAP:
        title, aliases = ALIAS_MAP[category]
        add_aliases(title, aliases)


def show_alias_description(alias_name: str):
    """Show detailed description for a specific alias with examples."""
    for name, command, description in ALL_ALIASES:
        if name == alias_name:
            main_table = Table(
                box=HEAVY,
                title="[blue bold]Alias Information[/]",
                border_style="blue",
                show_header=True,
                width=100
            )
            main_table.add_column("Category", style="cyan bold", width=30)
            main_table.add_column("Details", style="white")

            # Details section
            details_content = Table(show_header=False, box=None)
            details_content.add_column("", style="green")
            details_content.add_row(f"[cyan bold]Alias:[/] {name}")
            details_content.add_row(f"[green]Command:[/] {command}")
            details_content.add_row(f"Description: {description}")
            main_table.add_row("[blue]Details[/]", details_content)

            # Examples section
            examples_content = Table(show_header=False, box=None)
            examples_content.add_column("", style="yellow")

            if name in [a[0] for a in GIT_ALIASES]:
                examples_content.add_row(f"$ {name} # Run basic command")
                if "add" in command:
                    examples_content.add_row(f"$ {name} file.txt # Add specific file")
                    examples_content.add_row(f"$ {name} . # Add all changes")
                elif "commit" in command:
                    examples_content.add_row(f'$ {name} "feat: add new feature"')
                elif "checkout" in command:
                    examples_content.add_row(f"$ {name} main # Switch to main branch")
                    examples_content.add_row(f"$ {name} -b feature # Create new branch")
            elif name in [a[0] for a in YARN_ALIASES]:
                examples_content.add_row(f"$ {name} # Basic command")
                if "add" in command:
                    examples_content.add_row(f"$ {name} react # Add package")
                    examples_content.add_row(f"$ {name} @types/react # Add types")
            elif name in [a[0] for a in PNPM_ALIASES]:
                examples_content.add_row(f"$ {name} # Basic command")
                if "add" in command:
                    examples_content.add_row(f"$ {name} -D typescript # Add dev dependency")
            elif "mkdir" in command or "cd" in command:
                examples_content.add_row(f"$ {name} new-project")
                examples_content.add_row(f"$ {name} path/to/dir")
            else:
                examples_content.add_row(f"$ {name}")

            main_table.add_row("[yellow]Examples[/]", examples_content)

            # Tips section
            if any(keyword in command for keyword in ["git", "yarn", "pnpm", "nvim"]):
                tips_content = Table(show_header=False, box=None)
                tips_content.add_column("", style="green")

                if "git" in command:
                    tips_content.add_row("• Use --help to see all available options")
                    tips_content.add_row("• Add -v for verbose output")
                elif "yarn" in command or "pnpm" in command:
                    tips_content.add_row("• Check package.json for available scripts")
                    tips_content.add_row("• Use --help to see all options")
                elif "nvim" in command:
                    tips_content.add_row("• Press :help for built-in documentation")
                    tips_content.add_row("• Use :checkhealth to verify setup")

                main_table.add_row("[green]Tips[/]", tips_content)

            console.print()
            console.print(Panel(main_table, border_style="blue"))
            console.print()
            return

    console.print(f"[red]Alias '{alias_name}' not found.[/]")


def show_help():
    """Display help information with examples."""
    console.print("\n[cyan bold]Usage Examples:[/]")
    console.print("  [green]aliases --show git[/]        # Show all Git aliases")
    console.print("  [green]aliases --show modern[/]     # Show modern CLI replacements")
    console.print("  [green]aliases --describe ga[/]     # Show details for 'ga' alias")
    console.print("  [green]aliases --tui[/]             # Launch interactive TUI")

    table = Table(title="Available Categories", show_header=True, box=ROUNDED)
    table.add_column("Category", style="green")
    table.add_column("Description")
    table.add_column("Examples", style="cyan")

    table.add_row("git", "Git version control shortcuts", "g, ga, gp, gs")
    table.add_row("coreutils", "GNU coreutils (macOS)", "cp, mv, rm, grep, sed")
    table.add_row("yarn", "Yarn package manager", "y, ya, yr, ys")
    table.add_row("pnpm", "PNPM package manager", "pn, pna, pni")
    table.add_row("shortcuts", "Quick command shortcuts", "c, x, o, clip, paste")
    table.add_row("editors", "Editor shortcuts", "v, vi, vim, n")
    table.add_row("navigation", "Directory navigation", "dev, work, dots, dl")
    table.add_row("modern", "Modern CLI replacements", "cat, ls, tree, top, du")
    table.add_row("tmux", "Tmux session management", "ix, ik, iswitch, ipop")
    table.add_row("macos", "macOS specific commands", "show, hide, afk, stfu")
    table.add_row("functions", "Shell functions", "take, yy, activate, setenv")

    console.print("\n[yellow bold]Categories:[/]")
    console.print(table)

    console.print("\n[yellow bold]Options:[/]")
    console.print("[green]--show, -s CATEGORY[/]    Show all aliases in a category")
    console.print("[green]--describe, -d ALIAS[/]   Show detailed description of an alias")
    console.print("[green]--tui, -t[/]              Launch interactive TUI browser")

    console.print("\n[cyan]Tip:[/] Use [green]aliases --tui[/] for an interactive browsing experience!")


# ═══════════════════════════════════════════════════════════════════════════
# TEXTUAL TUI MODE
# ═══════════════════════════════════════════════════════════════════════════

def run_tui():
    """Launch the Textual TUI application."""
    from textual.app import App, ComposeResult
    from textual.binding import Binding
    from textual.containers import Container, Horizontal, Vertical
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

        def compose(self) -> ComposeResult:
            yield Header(show_clock=True)
            with Container(id="sidebar"):
                yield Static("Categories", classes="title")
                yield ListView(
                    *[ListItem(Label(cat.value), id=f"cat-{cat.value}") for cat in Category],
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
            table = self.query_one("#alias-table", DataTable)
            table.clear()

            title, aliases = ALIAS_MAP[category]
            filtered = self.filter_aliases(aliases)

            for name, command, description in filtered:
                table.add_row(name, command, description)

            self.query_one("#details", Static).update(f"[bold]{title}[/] - {len(filtered)} aliases")

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
                details = f"[cyan bold]{name}[/] → [green]{command}[/]\n{description}"
                self.query_one("#details", Static).update(details)

        def on_input_changed(self, event: Input.Changed) -> None:
            if event.input.id == "search":
                self.search_query = event.value
                self.load_category(self.current_category)

        def action_focus_search(self) -> None:
            self.query_one("#search", Input).focus()

        def action_clear_search(self) -> None:
            search = self.query_one("#search", Input)
            search.value = ""
            self.search_query = ""
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
    CLI tool to display and manage shell aliases and functions

    Examples:
        List all available categories:
            aliases

        Show all Git aliases:
            aliases --show git
            aliases -s git

        Launch interactive TUI:
            aliases --tui
            aliases -t

        Show details for a specific alias:
            aliases --describe ga
            aliases -d ga
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
