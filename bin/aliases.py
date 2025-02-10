#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.8"
# dependencies = [
#     "rich",
#     "typer",
# ]
# ///

import typer
from rich.console import Console
from rich.table import Table
from rich.panel import Panel
from rich.box import ROUNDED, HEAVY
from typing import Optional
from enum import Enum

console = Console()
app = typer.Typer(help="CLI tool to display and manage aliases")


class Category(str, Enum):
    GIT = "git"
    COREUTILS = "coreutils"
    YARN = "yarn"
    PNPM = "pnpm"
    SHORTCUTS = "shortcuts"
    SPECIAL = "special"
    FUNCTIONS = "functions"


def print_alias(name: str, command: str, description: str, table: Table) -> None:
    """Add an alias to the table."""
    table.add_row(
        f"[cyan bold]{name}[/]",
        f"[green]{command}[/]",
        description
    )


def add_aliases(category: str, aliases: list[tuple[str, str, str]]) -> None:
    """Display a category of aliases in a single table."""
    table = Table(box=ROUNDED, title=f"[blue bold]{category}[/]", border_style="blue", width=300)
    table.add_column("Alias", style="cyan bold", width=15)
    table.add_column("Command", style="green", width=30)
    table.add_column("Description", width=90)
    
    for name, command, description in aliases:
        print_alias(name, command, description, table)
    
    console.print()
    console.print(Panel(table, border_style="blue"))
    console.print()


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
    (
        "gpl",
        "git pull",
        "Fetch from and integrate with another repository or a local branch",
    ),
    ("gaa", "git add .", "Add current directory contents to the index"),
    ("gap", "git add --patch", "Interactively add changes to the index"),
    (
        "gau",
        "git add --update",
        "Update the index with the current content found in the working tree",
    ),
    ("gbe", "git branch --edit-description", "Edit the description for the branch"),
    ("gbd", "git branch -d", "Delete a branch"),
    ("gbdd", "git branch -D", "Force delete a branch"),
    ("gch", "git checkout", "Switch branches or restore working tree files"),
    ("gcb", "git checkout -b", "Create and switch to a new branch"),
    ("gbm", "git branch --merged", "List branches that have been merged"),
    ("gbnm", "git branch --no-merged", "List branches that have not been merged"),
    (
        "gchp",
        "git cherry-pick",
        "Apply the changes introduced by some existing commits",
    ),
    ("gcl", "git clone", "Clone a repository into a new directory"),
    ("gc", "git commit -am", "Commit changes with message"),
    ("gcm", "git commit --amend --message", "Amend the last commit with a new message"),
    ("gdt", "git difftool", "Show changes using common diff tools"),
    (
        "gd",
        "git diff --color",
        "Show changes between commits, commit and working tree, etc",
    ),
    (
        "gitfix",
        "git diff --name-only | uniq | xargs code",
        "Open changed files in VSCode",
    ),
    (
        "ggl",
        "git grep --line-number",
        "Print lines matching a pattern with line numbers",
    ),
    (
        "ggg",
        "git grep --break --heading --line-number",
        "Print lines matching a pattern with breaks and headings",
    ),
    ("glg", "git log --graph", "Show commit logs with a graph"),
    ("glo", "git log --oneline", "Show commit logs as a single line per commit"),
    (
        "changelog",
        'git log --pretty=format:"%h %ad%x09%an%x09%s" --date=short',
        "Generate a changelog",
    ),
    ("gp", "git push", "Update remote refs along with associated objects"),
    ("gpu", "git push -u origin", "Push the branch and set remote as upstream"),
    ("undopush", "git push -f origin HEAD^:master", "Undo the last push"),
    ("gre", "git rebase", "Reapply commits on top of another base tip"),
    ("gra", "git remote add origin", "Add a new remote"),
    ("gst", "git stash", "Stash the changes in a dirty working directory away"),
    ("gsa", "git stash apply", "Apply the changes recorded in a stash"),
    (
        "gsp",
        "git stash pop",
        "Apply the changes recorded in a stash and remove it from the stash list",
    ),
    ("gsd", "git stash drop", "Remove a single stash entry from the list"),
    (
        "gbi",
        "git browse -- issues",
        "Open the issues page of the repository in the browser",
    ),
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
    ("paste", "gpaste", "Merge lines of files"),
    ("join", "gjoin", "Join lines of two files on a common field"),
    ("cp", "gcp -v", "Copy files and directories"),
    ("mv", "gmv -v", "Move files"),
    ("rm", "grm -v", "Remove files or directories"),
    (
        "shred",
        "gshred",
        "Overwrite a file to hide its contents and optionally delete it",
    ),
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
    (
        "truncate",
        "gtruncate",
        "Shrink or extend the size of a file to the specified size",
    ),
    ("echo", "gecho", "Display a line of text"),
    ("tee", "gtee", "Read from standard input and write to standard output and files"),
    ("awk", "gawk", "Pattern scanning and processing language"),
    ("grep", "ggrep --color", "Print lines matching a pattern with color"),
    ("ln", "gln", "Make links between files"),
    ("ln-sym", "gln -nsf", "Create symbolic links"),
    ("find", "gfind", "Search for files in a directory hierarchy"),
    ("locate", "glocate", "Find files by name"),
    ("updatedb", "gupdatedb", "Update a database for mlocate"),
    ("xargs", "gxargs", "Build and execute command lines from standard input"),
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
    ("md", "mkdir", "Create directories"),
    ("t", "touch", "Create empty files"),
    ("x", "exit", "Exit the shell"),
    ("c", "clear", "Clear the terminal screen"),
    ("o", "open .", "Open the current directory"),
    ("vi", "nvim", "Open Neovim"),
    ("vim", "nvim", "Open Neovim"),
    ("v", "nvim", "Open Neovim"),
    ("n", "nvim", "Open Neovim"),
    ("x+=", "chmod +x", "Make a file executable"),
    ("restart", "sudo reboot", "Reboot the system"),
    ("bye", "sudo shutdown -r now", "Restart the system immediately"),
    ("get", "curl -O -L", "Download a file using curl"),
    ("reload", "source ~/.zshrc", "Reload the shell configuration"),
]

SPECIAL_ALIASES = [
    ("cat", "bat", "Use bat for displaying file contents"),
    ("dev", "cd ~/dev", "Change to development directory"),
    ("work", "cd ~/dev/work", "Change to work directory"),
    ("desk", "cd ~/desktop", "Change to desktop directory"),
    ("docs", "cd ~/documents", "Change to documents directory"),
    ("dl", "cd ~/downloads", "Change to downloads directory"),
    ("home", "cd ~", "Change to home directory"),
    ("dots", "cd ~/dotfiles", "Change to dotfiles directory"),
    ("dotfiles", "cd ~/dotfiles", "Change to dotfiles directory"),
    ("pip", "uv pip", "Use uv to manage pip"),
    (
        "mergepdf",
        "/System/Library/Automator/Combine\\ PDF\\ Pages.action/Contents/Resources/join.py",
        "Merge PDFs using Automator",
    ),
    ("spotoff", "sudo mdutil -a -i off", "Turn off Spotlight indexing"),
    ("spoton", "sudo mdutil -a -i on", "Turn on Spotlight indexing"),
    (
        "rm_ds",
        "find . -name '*.DS_Store' -type f -ls -delete",
        "Remove .DS_Store files",
    ),
    (
        "show",
        "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder",
        "Show hidden files",
    ),
    (
        "hide",
        "defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder",
        "Hide hidden files",
    ),
    (
        "hidedesktop",
        "defaults write com.apple.finder CreateDesktop -bool false && killall Finder",
        "Hide desktop items",
    ),
    (
        "showdesktop",
        "defaults write com.apple.finder CreateDesktop -bool true && killall Finder",
        "Show desktop items",
    ),
    (
        "chromekill",
        "ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill",
        "Kill all Chrome tabs to free memory",
    ),
    (
        "afk",
        "/System/Library/CoreServices/Menu\\ Extras/User.menu/Contents/Resources/CGSession -suspend",
        "Lock screen when going AFK",
    ),
    ("stfu", "osascript -e 'set volume output muted true'", "Mute the system volume"),
    (
        "xcodepurge",
        "rm -rf ~/Library/Developer/Xcode/DerivedData",
        "Remove cached Xcode build data",
    ),
    ("top", "bpytop", "Use bpytop for system monitoring"),
    ("du", "ncdu", "Use ncdu for disk usage analysis"),
    ("ls", "eza --icons=always", "Use eza for better directory listing"),
    ("tree", "eza --tree", "Use eza for better tree listing"),
]

FUNCTIONS = [
    ("gi", "generate .gitignore", "Generate .gitignore files"),
    (
        "create-repo",
        "create a GitHub repo",
        "Create a new GitHub repository and push initial commit",
    ),
    ("take", "mkdir and cd", "Create a directory and change into it"),
    ("up", "cd up", "Change directory to a parent directory"),
    ("gifify", "convert video to gif", "Create animated gifs from video files"),
    ("emptytrash", "empty trashes", "Empty system trashes"),
    ("rename-branch", "rename git branch", "Rename a git branch and update it"),
    ("git", "smart git clone", "Clone a repository and change into it"),
    ("yy", "yazi", "Open yazi with a temporary file for cwd"),
    (
        "activate",
        "activate Python virtual environment",
        "Activate virtual environment in current or parent directory",
    ),
    ("setenv", "load .env or -f dotenv file to activate", "Export .env to global PATH"),
    (
        "unsetenv",
        "unload .env or -f dotenv file to activate",
        "Export .env to global PATH",
    ),
    ("clean_pycache", "remove all __pycache__ directories", "Clean Python cache files"),
    (
        "cmd",
        'llm_func() { command llm -t cmd "$@" | xargs -I {} sh -c "echo "execute:\\n\\t {}\\n"; eval {}"; }; llm_func',
        "Productive laziness with llm",
    ),
    (
        "iexit",
        "tmux kill-session -t $(tmux display-message -p '#S')",
        "Exit tmux session",
    ),
    ("ikill", "tmux kill-server", "Kill tmux server"),
    ("iswitch", "tmux choose-session", "Show tmux sessions"),
    (
        "ipop",
        'tmux display-popup -E "cd $(tmux display -p -F "#{pane_current_path}") && tmux new-session -A -s scratch"',
        "Open tmux popup",
    ),
    ("f", "thefuck", "Use thefuck for command corrections"),
]


@app.command()
def main(
    show: Optional[Category] = typer.Option(
        None, "--show", "-s", help="Show aliases for a specific category"
    ),
    describe: str = typer.Option(
        None, "--describe", "-d", help="Describe a specific alias"
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

        Show all shortcuts:
            aliases --show shortcuts
            aliases -s shortcuts

        Show details for a specific alias:
            aliases --describe ga
            aliases -d ga

        Get help with yarn commands:
            aliases --show yarn
            aliases -s yarn

        Learn about special commands:
            aliases --show special
            aliases -s special

        Discover useful functions:
            aliases --show functions
            aliases -s functions
    """
    if describe:
        show_alias_description(describe)
        return

    if show:
        show_category_aliases(show)
        return

    show_help()


def show_category_aliases(category: Category):
    """Display aliases for a specific category."""
    alias_map = {
        Category.GIT: ("Git Aliases", GIT_ALIASES),
        Category.COREUTILS: ("Coreutils Aliases", COREUTILS_ALIASES),
        Category.YARN: ("Yarn Aliases", YARN_ALIASES),
        Category.PNPM: ("PNPM Aliases", PNPM_ALIASES),
        Category.SHORTCUTS: ("Shortcuts", SHORTCUTS),
        Category.SPECIAL: ("Special Aliases", SPECIAL_ALIASES),
        Category.FUNCTIONS: ("Functions", FUNCTIONS),
    }

    if category in alias_map:
        title, aliases = alias_map[category]
        add_aliases(title, aliases)


def show_alias_description(alias_name: str):
    """Show detailed description for a specific alias with examples."""
    all_aliases = (
        GIT_ALIASES
        + COREUTILS_ALIASES
        + YARN_ALIASES
        + PNPM_ALIASES
        + SHORTCUTS
        + SPECIAL_ALIASES
        + FUNCTIONS
    )

    for name, command, description in all_aliases:
        if name == alias_name:
            # Create a single container with all details
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

            # Generate contextual examples
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

            # Tips section if available
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

            # Print the single container
            console.print()
            console.print(Panel(main_table, border_style="blue"))
            console.print()
            return

    console.print(f"[red]Alias '{alias_name}' not found.[/]")


def show_help():
    """Display help information with examples."""
    console.print("\n[cyan bold]🚀 Usage Examples:[/]")
    console.print("  [green]aliases --show git[/]        # Show all Git aliases")
    console.print("  [green]aliases --show shortcuts[/]  # Show all shortcuts")
    console.print("  [green]aliases --describe ga[/]     # Show details for 'ga' alias")
    console.print("  [green]aliases --show yarn[/]       # Show Yarn package manager commands")
    console.print("  [green]aliases --show functions[/]  # Show useful shell functions")

    table = Table(title="📚 Available Categories", show_header=True, box=ROUNDED)
    table.add_column("Category 📂", style="green")
    table.add_column("Description 📝")
    table.add_column("Examples ✨", style="cyan")

    table.add_row("git", "Git version control shortcuts", "g (git), ga (add), gp (push)")
    table.add_row("coreutils", "Enhanced Unix commands", "ls (list), cp (copy), mv (move)")
    table.add_row("yarn", "Yarn package manager", "y (yarn), yi (init), ya (add)")
    table.add_row("pnpm", "PNPM package manager", "pn (pnpm), pna (add), pni (install)")
    table.add_row("shortcuts", "Quick command shortcuts", "c (clear), x (exit), o (open)")
    table.add_row("special", "Special system commands", "cat (bat), dev (cd ~/dev)")
    table.add_row("functions", "Useful shell functions", "gi (gitignore), take (mkdir+cd)")

    console.print("\n[yellow bold]🗂️  Categories:[/]")
    console.print(table)

    console.print("\n[yellow bold]⚙️  Options:[/]")
    console.print("[green]--show, -s CATEGORY[/]    Show all aliases in a category")
    console.print("[green]--describe, -d ALIAS[/]    Show detailed description of an alias")
    
    console.print("\n[cyan]💡 Tip:[/] Use [green]aliases --describe <alias>[/] to learn more about any command!")


if __name__ == "__main__":
    app()
