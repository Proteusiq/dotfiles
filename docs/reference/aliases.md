# Aliases Reference

Shell aliases live in `zsh/.config/zsh/aliases.zsh` and shell functions in `zsh/.config/zsh/functions.zsh`. Both are sourced by `~/.zshrc`.

## The `aliases` command is authoritative

`aliases` (`bin/aliases.py`) parses `aliases.zsh` and `functions.zsh` every time it runs, so it always matches your shell. Use it instead of this page when in doubt.

```bash
aliases              # usage and categories with counts
aliases -s git       # one category
aliases -d gcl       # one alias or function
aliases --tui        # interactive browser: / search, Esc clear, j/k move, q quit
```

### Categories

`aliases` assigns each alias to a category from the section banner it sits under in `aliases.zsh`. Every function in `functions.zsh` goes to `fn`.

| Category | Description | `aliases.zsh` sections |
|----------|-------------|------------------------|
| `git` | Version control shortcuts | GIT |
| `files` | Modern file operations | MODERN CLI REPLACEMENTS |
| `nav` | Directory jumping | DIRECTORY NAVIGATION |
| `term` | Terminal & shell | SHELL, EDITORS, TMUX |
| `pkg` | Package managers | PACKAGE MANAGERS |
| `sys` | macOS & system | macOS |
| `gnu` | Verbose GNU file operations | SAFER FILE OPERATIONS (verbose) |
| `fn` | Shell functions | FUNCTION SHORTCUTS, plus every function in `functions.zsh` |

Interactive zsh puts the GNU versions of coreutils, findutils, sed, tar, grep and awk first on `PATH`, so plain names such as `cp` and `sed` run the GNU tools.

## Snapshot

::: warning Snapshot
Generated from `aliases.zsh` and `functions.zsh` on 2026-10-17. It is not maintained by hand and may be out of date. Run `aliases` for the current list.
:::

### `term`: shell, editors, tmux

| Alias | Command | Description |
|-------|---------|-------------|
| `c` | `clear` | Clear screen |
| `x` | `exit` | Exit shell |
| `o` | `open .` | Open current directory |
| `t` | `touch` | Create empty file |
| `md` | `mkdir -p` | Create directory |
| `x+` | `chmod +x` | Make executable |
| `reload` | `exec zsh` | Reload shell config |
| `clip` | `pbcopy` | Copy to clipboard |
| `paste` | `pbpaste` | Paste from clipboard |
| `get` | `curl -fLO` | Download file |
| `update` | `"$DOTFILES_DIR/install.sh"` | Run dotfiles installer |
| `v`, `vi`, `vim`, `n` | `nvim` | Open Neovim |
| `iexit` | `tmux kill-session -t "$(tmux display-message -p "#S")"` | Kill tmux session |
| `ix` | `iexit` | Kill tmux session (short) |
| `ikill` | `tmux kill-server` | Kill tmux server |
| `ik` | `ikill` | Kill tmux server (short) |
| `iswitch` | `tmux choose-session` | Switch tmux session |
| `ipop` | `tmux display-popup -E "cd $(tmux display -p -F "#{pane_current_path}") && tmux new-session -A -s scratch"` | Tmux popup |

### `files`: modern CLI replacements

| Alias | Command | Description |
|-------|---------|-------------|
| `cat` | `bat` | View files with syntax highlighting |
| `ls` | `eza --icons=always` | List with icons |
| `ll` | `eza -l` | Long listing |
| `la` | `eza -la` | Long listing with hidden |
| `tree` | `eza --tree` | Tree view |
| `top` | `btop` | System monitor |
| `du` | `ncdu` | Disk usage analyzer |

### `gnu`: safer file operations

| Alias | Command | Description |
|-------|---------|-------------|
| `cp` | `cp -v` | Copy files (verbose) |
| `mv` | `mv -v` | Move files (verbose) |
| `rm` | `rm -v` | Remove files (verbose) |
| `mkdir` | `mkdir -v` | Create directories |
| `rmdir` | `rmdir -v` | Remove directories |
| `chmod` | `chmod -v` | Change permissions |
| `chown` | `chown -v` | Change ownership |
| `chgrp` | `chgrp -v` | Change group (verbose) |
| `ln-sym` | `ln -nsf` | Create symlinks |
| `grep` | `grep --color=auto` | Search with color |

### `git`

| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Git command |
| `ga` | `git add` | Add file contents to index |
| `gaa` | `git add .` | Add all changes |
| `gap` | `git add --patch` | Interactively stage changes |
| `gau` | `git add --update` | Update tracked files |
| `gb` | `git branch` | List/create branches |
| `gbe` | `git branch --edit-description` | Edit branch description |
| `gbd` | `git branch -d` | Delete branch |
| `gbdd` | `git branch -D` | Force delete branch |
| `gbm` | `git branch --merged` | List merged branches |
| `gbnm` | `git branch --no-merged` | List unmerged branches |
| `gch` | `git checkout` | Switch branches |
| `gcb` | `git checkout -b` | Create and switch branch |
| `gchp` | `git cherry-pick` | Apply commits |
| `gc` | `git commit -am` | Commit with message |
| `gcm` | `git commit --amend --message` | Amend last commit |
| `gd` | `git diff` | Show changes |
| `gdt` | `git difftool` | Diff with tool |
| `gitfix` | `git diff --name-only \| uniq \| xargs "$EDITOR"` | Open changed files |
| `gf` | `git fetch` | Download objects/refs |
| `gg` | `git grep` | Search patterns |
| `ggl` | `git grep --line-number` | Search with line numbers |
| `ggg` | `git grep --break --heading --line-number` | Grep grouped by file |
| `gl` | `git log` | Show commit logs |
| `glg` | `git log --graph` | Log with graph |
| `glo` | `git log --oneline` | Compact log |
| `gw` | `git log --raw --no-merges` | Show change logs |
| `changelog` | `git log --pretty=format:"%h %ad%x09%an%x09%s" --date=short` | Generate changelog |
| `gm` | `git merge` | Merge branches |
| `gmc` | `git merge --continue` | Continue merge |
| `gma` | `git merge --abort` | Abort merge |
| `gpl` | `git pull` | Pull from remote |
| `gp` | `git push` | Push to remote |
| `gpu` | `git push -u origin` | Push and set upstream |
| `undopush` | `git push --force-with-lease origin "HEAD^:$(git branch --show-current)"` | Undo last push |
| `gre` | `git rebase` | Rebase commits |
| `gr` | `git remote` | Manage remotes |
| `gra` | `git remote add origin` | Add remote |
| `gs` | `git status` | Show status |
| `gst` | `git stash` | Stash changes |
| `gsa` | `git stash apply` | Apply stash |
| `gsp` | `git stash pop` | Pop stash |
| `gsd` | `git stash drop` | Drop stash |
| `gbi` | `gh issue list --web` | Open issues in the browser |
| `gpr` | `gh pr create` | Create a pull request |

`git/.config/git/config` also defines git aliases: `git l`, `git ld`, `git ll`, `git branches`, `git delete-merged`, and the difftastic views `git dft`, `git dlog`, `git dshow`.

### `nav`: directory navigation

| Alias | Command | Description |
|-------|---------|-------------|
| `dev` | `cd ~/Codes` | Development directory |
| `desk` | `cd ~/Desktop` | Desktop |
| `docs` | `cd ~/Documents` | Documents |
| `dl` | `cd ~/Downloads` | Downloads |
| `home` | `cd ~` | Home directory |
| `dots` | `cd "$DOTFILES_DIR"` | Dotfiles directory |

### `pkg`: package managers

| Alias | Command | Description |
|-------|---------|-------------|
| `pn` | `pnpm` | PNPM command |
| `pna` | `pnpm add` | Add package |
| `pnr` | `pnpm run` | Run script |
| `pni` | `pnpm install` | Install packages |
| `pip` | `uv pip` | Python packages (via uv) |

### `sys`: macOS

| Alias | Command | Description |
|-------|---------|-------------|
| `show` | `defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder` | Show hidden files |
| `hide` | `defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder` | Hide hidden files |
| `showdesktop` | `defaults write com.apple.finder CreateDesktop -bool true && killall Finder` | Show desktop icons |
| `hidedesktop` | `defaults write com.apple.finder CreateDesktop -bool false && killall Finder` | Hide desktop icons |
| `spotoff` | `sudo mdutil -a -i off` | Disable Spotlight |
| `spoton` | `sudo mdutil -a -i on` | Enable Spotlight |
| `afk` | `pmset displaysleepnow` | Lock screen |
| `stfu` | `osascript -e 'set volume output muted true'` | Mute volume |
| `restart` | `sudo reboot` | Reboot system |
| `bye` | `sudo shutdown -r now` | Shutdown now |
| `rm_ds` | `find . -name '*.DS_Store' -type f -ls -delete` | Remove .DS_Store files |
| `xcodepurge` | `rm -rf ~/Library/Developer/Xcode/DerivedData` | Delete Xcode DerivedData |
| `chromekill` | `ps ux \| grep '[C]hrome Helper --type=renderer' \| grep -v extension-process \| tr -s ' ' \| cut -d ' ' -f2 \| xargs kill` | Kill Chrome renderer processes |

### `fn`: function shortcuts and functions

| Alias | Command | Description |
|-------|---------|-------------|
| `tk` | `take` | Create and enter (short) |
| `clean` | `clean_pycache` | Remove `__pycache__` |
| `activate` | `activate_venv` | Activate Python venv |
| `pg` | `purge` | Delete files matching a pattern |

| Function | Description |
|----------|-------------|
| `take <dir>` | Make a directory and cd into it |
| `up [n]` | Go up n directories (default 1) |
| `yy` | yazi: cd into the directory you were in when yazi exits |
| `gcl <url> [dir]` | git clone, then cd into the new repository |
| `gi <list>` | Write a .gitignore template, e.g. `gi macos,python > .gitignore` |
| `create-repo <name> [--public]` | Create a GitHub repository from the current directory and push it |
| `rename-branch <old> <new>` | Rename a branch locally and on origin |
| `git_add_comment_push` | Add everything, prompt for a message, commit and push |
| `gifify <movie> [--good]` | Animated gif from a video; `--good` for higher quality |
| `emptytrash` | Empty the user trash and the trash on mounted volumes |
| `activate_venv` | Activate the nearest `venv` or `.venv`, searching up from the current directory |
| `setenv [--key]` | Export variables from `.env` into this shell; `--key` resolves `op://` references. Prefer `envrun` |
| `unsetenv` | Unset every variable named in `.env` |
| `envrun <command>` | Run one command with `.env` loaded; `op://` references resolved by 1Password |
| `clean_pycache <dir>` | Remove `__pycache__` directories under a directory |
| `purge <pattern> [dir]` | Delete files matching a pattern, after showing them and asking |
| `sesh-sessions` | Pick a tmux session with sesh + fzf (bound to `Alt+s`) |

Other shell commands set up in `~/.zshrc`, not in these files: `f` (pay-respects: fix the last command), `z`/`zi` (zoxide), `br` (broot).

## Adding an alias or function

1. Open `zsh/.config/zsh/aliases.zsh` (in the repository, or `~/.config/zsh/aliases.zsh`, which is a symlink to it).
2. Put the alias under the section banner that matches its category. The banner decides the category in `aliases`.
3. End the line with a `# description` comment. `aliases` uses it as the description; without it, the nearest sub-heading comment is used.

```bash
###############################################################################
# GIT
###############################################################################

alias gsw="git switch"  # Switch branches
```

`aliases` reads the form `alias name="command"  # description` (single or double quotes).

For a function, add it to `functions.zsh` with a comment directly above it; that comment becomes its description:

```bash
# print the current branch name
branch() {
    git branch --show-current
}
```

Then run `reload` (`exec zsh`) and check it with `aliases -d <name>`.

Machine-local aliases that should not be committed belong in `~/.zshrc.local`, which `~/.zshrc` sources last. `aliases` does not show them.
