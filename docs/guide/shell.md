# Shell (Zsh)

The shell is Zsh. Plugins load through [antidote](https://github.com/mattmc3/antidote). Startup is kept short: `update --doctor` warns when an interactive shell takes more than 300 ms to start.

## Files

| Repository file | Linked to | Read by |
|-----------------|-----------|---------|
| `zsh/.zshenv` | `~/.zshenv` | every zsh |
| `zsh/.zprofile` | `~/.zprofile` | login shells |
| `zsh/.zshrc` | `~/.zshrc` | interactive shells |
| `zsh/.config/zsh/plugins.txt` | `~/.config/zsh/plugins.txt` | antidote |
| `zsh/.config/zsh/fzf.zsh` | `~/.config/zsh/fzf.zsh` | `.zshrc` |
| `zsh/.config/zsh/fzf-git.sh` | `~/.config/zsh/fzf-git.sh` | `fzf.zsh` |
| `zsh/.config/zsh/aliases.zsh` | `~/.config/zsh/aliases.zsh` | `.zshrc` |
| `zsh/.config/zsh/functions.zsh` | `~/.config/zsh/functions.zsh` | `.zshrc` |

For the load order, see [Architecture](/guide/architecture#shell-load-order).

## Environment

`~/.zshenv` sets the environment for every zsh, including scripts and editors:

| Variable | Value |
|----------|-------|
| `XDG_CONFIG_HOME`, `XDG_CACHE_HOME`, `XDG_DATA_HOME`, `XDG_STATE_HOME` | `~/.config`, `~/.cache`, `~/.local/share`, `~/.local/state` (if not set) |
| `DOTFILES_DIR` | `~/dotfiles` (if not set) |
| `EDITOR`, `VISUAL`, `SUDO_EDITOR` | `nvim` |
| `PAGER`, `MANPAGER` | `less`, `nvim +Man!` |
| `RIPGREP_CONFIG_PATH` | `~/.rgrc` |
| `GOPATH`, `GOBIN` | `~/projects/go`, `~/projects/go/bin` |
| `PNPM_HOME` | `~/Library/pnpm` |
| `HOMEBREW_PREFIX` | `/opt/homebrew` or `/usr/local`, whichever has `brew` |

## PATH

The `dotfiles_path` function in `~/.zshenv` builds `PATH` in this order:

1. `~/.local/bin`
2. mise shims (`$XDG_DATA_HOME/mise/shims`)
3. `~/.cargo/bin`
4. `$GOBIN`
5. `$PNPM_HOME`
6. rustup (`$HOMEBREW_PREFIX/opt/rustup/bin`)
7. Homebrew `bin` and `sbin`
8. the existing `PATH`
9. `/usr/local/bin /usr/bin /bin /usr/sbin /sbin`

Directories that do not exist are dropped, and duplicates are removed (`typeset -U`). On macOS, `/etc/zprofile` reorders `PATH` for login shells, so `~/.zprofile` runs `dotfiles_path` again.

### GNU Tools

Interactive shells put the GNU versions of coreutils, findutils, sed, tar, grep and awk first on `PATH`, under their usual names (`ls`, `sed`, `find`, ...). Scripts do not get this change, so they keep the BSD tools that macOS scripts expect.

## Multiplexer on start

A new Ghostty window greets you by time of day and counts down to herdr:

````
  ☀  Good afternoon, Prayson
     Saturday 24 October · 12:31

     ❯ herdr in 3s    t tmux  h herdr  · any key +5s
````

- `t` starts tmux, `h` starts herdr straight away
- any other key adds 5 seconds
- no key starts herdr, which reopens its last session
- `MULTIPLEXER=herdr|tmux` skips the greeting and starts that multiplexer

The greeting runs only when all of these are true:

- `TERM_PROGRAM` is `ghostty`
- the shell is not already inside a multiplexer (`TMUX`, `HERDR_ENV`)
- the session is not over SSH
- the shell is not running a command (`zsh -c`)
- `DOTFILES_NO_TMUX` is not set

Other terminals, IDEs and agents get a plain shell. `update --doctor` and CI set `DOTFILES_NO_TMUX=1` when they start zsh.

## History

| Setting | Value |
|---------|-------|
| `HISTSIZE`, `SAVEHIST` | 50000 |
| Options | `EXTENDED_HISTORY`, `HIST_IGNORE_ALL_DUPS`, `HIST_IGNORE_SPACE`, `HIST_REDUCE_BLANKS`, `SHARE_HISTORY` |

Other options: `AUTO_CD` (type a directory name to `cd` into it) and `INTERACTIVE_COMMENTS`.

[atuin](https://atuin.sh) owns `Ctrl-R` and the up arrow. Its config (`~/.config/atuin/config.toml`) sets `enter_accept = true`: Enter runs the selected command at once.

::: tip
`HIST_IGNORE_SPACE` keeps commands that start with a space out of the zsh history.
:::

## Plugins

`~/.config/zsh/plugins.txt` lists the plugins:

```
romkatv/zsh-defer
zsh-users/zsh-completions path:src kind:fpath
djui/alias-tips
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting kind:defer
```

antidote is installed by Homebrew. It compiles the list into one static file, `$XDG_CACHE_HOME/zsh/plugins.zsh`, and rebuilds that file when `plugins.txt` changes.

To add a plugin:

1. Add one line to `zsh/.config/zsh/plugins.txt` in the repository.
2. Open a new shell.

## Completions

- Completions that tools generate (`uv`, `uvx`, `pixi`, `mise`) are cached in `$XDG_CACHE_HOME/zsh/completions/`. A cache file is rebuilt only when the tool binary is newer.
- `fpath` also includes `~/.zfunc` and Homebrew's `share/zsh/site-functions`.
- `compinit` runs once per shell. It does a full check at most once a day and uses the cached dump otherwise.
- Completion uses a selection menu (`menu select`).

## Tool Integrations

| Tool | Integration |
|------|-------------|
| [mise](https://mise.jdx.dev) | `mise activate zsh` puts the runtimes from `~/.config/mise/config.toml` (and project files) on `PATH` |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `z <part of a path>` jumps to a frequent directory; `zi` picks one with fzf |
| [Starship](https://starship.rs) | prompt; config in `~/.config/starship.toml` |
| [pay-respects](https://github.com/iffse/pay-respects) | `f` corrects the previous command |
| [broot](https://dystroy.org/broot) | `br`, if the broot launcher exists in `~/.config/broot/launcher/bash/br` |
| [atuin](https://atuin.sh) | history search on `Ctrl-R` and the up arrow; loaded last |

### fzf

`~/.config/zsh/fzf.zsh` configures fzf:

- `fd` lists files and directories, including hidden ones, but not `.git`.
- Colors are Catppuccin Mocha.
- `Ctrl-T` (files) previews with `bat`, or with `eza --tree` for directories. `Alt-c` (directories) previews with `eza --tree`.
- `**<Tab>` completion uses the same previews. After `cd` it previews trees, after `export`/`unset` it shows the value, after `ssh` it runs `dig`.

`fzf-git.sh` adds Git pickers. Press `Ctrl-G`, then a second key:

| Keys | Picker |
|------|--------|
| `Ctrl-G Ctrl-F` | files |
| `Ctrl-G Ctrl-B` | branches |
| `Ctrl-G Ctrl-T` | tags |
| `Ctrl-G Ctrl-R` | remotes |
| `Ctrl-G Ctrl-H` | commit hashes |
| `Ctrl-G Ctrl-S` | stashes |
| `Ctrl-G Ctrl-L` | reflog |
| `Ctrl-G Ctrl-E` | each ref |
| `Ctrl-G Ctrl-W` | worktrees |

`Alt-s` opens a sesh session picker (the `sesh-sessions` function).

## Aliases and Functions

Some of the aliases in `aliases.zsh` and functions in `functions.zsh`:

| Group | Examples |
|-------|----------|
| Shell | `reload` (`exec zsh`), `c` (clear), `md` (`mkdir -p`), `clip`/`paste` (pbcopy/pbpaste), `update` (installer) |
| Editors | `n`, `v`, `vi`, `vim` all run `nvim` |
| Modern CLI | `cat` → `bat`, `ls` → `eza --icons=always`, `ll`, `la`, `tree`, `top` → `btop`, `du` → `ncdu` |
| File operations | `cp`, `mv`, `rm`, `mkdir`, `rmdir`, `chmod`, `chown`, `chgrp` print what they do (`-v`) |
| Navigation | `dev` (`~/Codes`), `dots` (`$DOTFILES_DIR`), `dl`, `docs`, `desk`; functions `take <dir>`, `up [n]`, `yy` (Yazi, then `cd` to its last directory) |
| Git | `gs`, `gd`, `gaa`, `gc` (`git commit -am`), `gp`, `gpl`; function `gcl` (clone, then `cd`). See [Git](/guide/git#shell-aliases). |
| Python | `pip` → `uv pip`; `activate` finds the nearest `.venv` or `venv` above the current directory |
| pnpm | `pn`, `pna`, `pnr`, `pni` |
| tmux | `ix` (kill this session), `ik` (kill the server), `iswitch`, `ipop` (scratch popup) |

For the full list:

```bash
aliases              # all aliases, by category
aliases -s git       # one category: git, files, nav, term, pkg, sys, gnu, fn
aliases -d gcl       # describe one alias or function
aliases --tui        # interactive browser
```

The `aliases` command reads `aliases.zsh` and `functions.zsh` directly, so it always matches the shell. See also the [Aliases Reference](/reference/aliases).

## Secrets

Keep secrets in a `.env` file. Values can be 1Password references (`op://...`). The global Git ignore excludes `.env` and `.env.*`, except `.env.example` and `.env.sample`.

| Function | Effect |
|----------|--------|
| `envrun <command>` | Runs one command with `.env` loaded through `op run --env-file=.env`. 1Password resolves `op://` references. The secrets do not stay in your shell. |
| `setenv [--key]` | Exports every variable from `.env` into the current shell. `--key` resolves `op://` values with `op read`. Skips invalid names and protected ones such as `PATH` and `HOME`. |
| `unsetenv` | Unsets the variables named in `.env`. |

::: tip
Prefer `envrun`. With `setenv`, the secrets stay in the shell and every process it starts.
:::

## Machine-Local Settings

`~/.zshrc` sources `~/.zshrc.local` last, and `~/.zprofile` sources `~/.zprofile.local`. Neither file is tracked. Use them for settings that belong to one machine.

When a third-party installer appends lines to `~/.zshrc`, it edits the tracked file in the repository. Move those lines to `~/.zshrc.local`. `update --doctor` reports uncommitted changes in the repository, so you notice such edits.
