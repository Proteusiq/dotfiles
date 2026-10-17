# Terminal

The terminal stack is Ghostty, tmux and sesh, with Yazi for files and AeroSpace for windows. When Ghostty opens a shell, the shell starts tmux (see [Shell](/guide/shell#automatic-tmux)).

## Ghostty

Config: `~/.config/ghostty/config` (from `ghostty/.config/ghostty/config`).

| Setting | Value |
|---------|-------|
| `theme` | `Catppuccin Mocha` |
| `background` | `1C2021` (overrides the theme background) |
| `font-size` | `13` |
| `adjust-cell-height` | `35%` |
| `cursor-style` | `block` |
| `shell-integration-features` | `no-title` |
| `mouse-hide-while-typing` | `true` |
| `mouse-scroll-multiplier` | `2` |
| `copy-on-select` | `clipboard` |
| `window-save-state` | `always` |
| `window-inherit-working-directory` | `true` |
| `window-colorspace` | `display-p3` |
| `window-decoration`, `macos-titlebar-style` | `false`, `hidden` |
| `macos-option-as-alt` | `left` |
| `quit-after-last-window-closed` | `true` |
| `confirm-close-surface` | `false` |

`macos-option-as-alt = left` makes the left Option key send Alt, which the `Alt-s`, `Alt-c` and `Alt-e` bindings need.

### Keybindings

All Ghostty bindings use the `cmd+b` leader: press `Cmd+B`, release, then the key.

| Keys | Action |
|------|--------|
| `Cmd+B r` | Reload config |
| `Cmd+B n` | New window |
| `Cmd+B x` | Close window |
| `Cmd+B i` | Split right |
| `Cmd+B -` | Split down |
| `Cmd+B h` / `j` / `k` / `l` | Go to the split left / below / above / right |
| `Cmd+B z` | Zoom the split |
| `Cmd+B e` | Make splits equal |

Check the config with `ghostty +validate-config`. `update --doctor` runs it too.

## tmux

Config: `~/.tmux.conf` (from `tmux/.tmux.conf`). The prefix is the default `Ctrl-b`.

### Keybindings

| Keys | Action |
|------|--------|
| `prefix c` | New window in the current directory |
| `prefix i` | Split right, in the current directory |
| `prefix -` | Split down, in the current directory |
| `Ctrl-h` / `j` / `k` / `l` | Move between panes, and between Neovim splits (no prefix) |
| `prefix h` / `j` / `k` / `l` | Resize the pane by 10 cells (repeatable) |
| `prefix <` / `>` | Swap the window with the previous / next one |
| `prefix x` | Kill the pane, without a prompt |
| `prefix Ctrl-s` | Toggle synchronized input to all panes |
| `prefix r` | Reload `~/.tmux.conf` |
| `prefix g` | lazygit in a full-screen popup, in the pane's directory |
| `prefix D` | lazydocker in a full-screen popup |
| `prefix K` | sesh picker with gum |
| `prefix T` | sesh picker with fzf |
| `prefix P` | Paste the buffer |

Copy mode uses vi keys: `v` starts a selection, `y` copies and exits, `r` toggles a rectangle selection.

### Settings

- Windows and panes start at 1. Windows are renumbered when one closes.
- Mouse support is on. History keeps 50000 lines.
- `escape-time` is 0, so `Esc` reaches Neovim without delay.
- `default-terminal` is `tmux-256color`, with RGB and clipboard features.
- `allow-passthrough` is on, so Yazi can show image previews inside tmux.
- The status bar is at the bottom.

### Plugins

[tpm](https://github.com/tmux-plugins/tpm) manages the plugins. It runs after every option is set, and before the key bindings, so your bindings win over plugin defaults (for example `prefix C-s` and `prefix P`).

| Plugin | Purpose |
|--------|---------|
| tmux-resurrect | Saves and restores sessions, including pane contents and Neovim sessions |
| tmux-continuum | Saves every 5 minutes and restores the last session when tmux starts |
| vim-tmux-navigator | Shared `Ctrl-h/j/k/l` navigation with Neovim |
| tmux-yank | Clipboard support |
| tmux-sensible | Basic defaults |
| catppuccin-tmux (dreamsofcode-io) | Theme, flavour Mocha |
| tmux-sessionx | Session manager |
| tmux-floax | Floating panes |
| tmux-thumbs | Copy text with hints |
| tmux-fzf | fzf for tmux commands |
| tmux-fzf-url | Open URLs from the pane |
| tmux.expose | Session switcher on `Alt-e` |

The installer installs the plugins (`update --only tmux`). `update --all` updates them.

## sesh

[sesh](https://github.com/joshmedeski/sesh) creates and switches tmux sessions. Configured sessions (`~/.config/sesh/sesh.toml`):

| Session | Directory | Starts |
|---------|-----------|--------|
| `Downloads 📥` | `~/Downloads` | `yazi` |
| `dotfiles` | `~/dotfiles` | `nvim` |
| `tmux config` | `~/dotfiles/tmux` | `nvim .tmux.conf` |

Three pickers:

| Keys | Picker |
|------|--------|
| `prefix T` | fzf popup with all sources |
| `prefix K` | gum filter |
| `Alt-s` (in zsh) | fzf list of tmux sessions and configured sessions |

Keys in the `prefix T` picker:

| Keys | Shows |
|------|-------|
| `Ctrl-a` | everything |
| `Ctrl-t` | tmux sessions |
| `Ctrl-g` | configured sessions |
| `Ctrl-x` | zoxide directories |
| `Ctrl-f` | directories in `~`, two levels deep |
| `Ctrl-d` | kills the selected tmux session |
| `Tab` / `Shift-Tab` | move down / up |

## Yazi

[Yazi](https://yazi-rs.github.io) is the terminal file manager. Run `yy` to open it and `cd` to its last directory on exit. In Neovim, use `<leader>fy`.

Config: `~/.config/yazi/` (from `yazi/.config/yazi/`).

| File | Content |
|------|---------|
| `yazi.toml` | Shows hidden files, natural sort, sizes in the line mode. Openers and open rules. |
| `keymap.toml` | Remapped navigation keys |
| `theme.toml` | Flavor `catppuccin-mocha` (dark) and `catppuccin-latte` (light) |
| `plugins/smart-enter.yazi` | Enters a directory or opens a file |

Open rules:

| Match | Openers |
|-------|---------|
| Directories, `text/*`, empty files, JSON, JavaScript | `edit` (`$EDITOR`, default `nvim`), then reveal |
| Audio and video | `play` (macOS `open`), then reveal |

Navigation keys (prepended to Yazi's defaults):

| Keys | Action |
|------|--------|
| `u` / `e` | Up / down |
| `U` / `E` | Up / down by 5 |
| `n` | Parent directory |
| `i` | Enter the directory or open the file (smart-enter) |
| `N` / `I` | Back / forward |
| `Ctrl-u` / `Ctrl-e` | Scroll the preview |
| `w` | Shell in the current directory |
| `W` | Task list |
| `l` / `L` | Link / relative link |
| `-` / `=` | Next / previous find match |

The flavors come from [yazi-rs/flavors](https://github.com/yazi-rs/flavors), cloned into `~/.config/yazi/flavors` by `update --only yazi`.

## AeroSpace

[AeroSpace](https://github.com/nikitabobko/AeroSpace) is a tiling window manager. Its config is `~/.config/aerospace/aerospace.toml`. The content is AeroSpace's default template, with `start-at-login = false`.

| Keys | Action |
|------|--------|
| `Alt-h` / `j` / `k` / `l` | Focus the window left / down / up / right |
| `Alt-Shift-h` / `j` / `k` / `l` | Move the window |
| `Alt-1`…`9`, `Alt-<letter>` | Go to a workspace (every letter except h, j, k, l) |
| `Alt-Shift-1`…`9`, `Alt-Shift-<letter>` | Move the window to a workspace |
| `Alt-Shift--` / `Alt-Shift-=` | Shrink / grow the window |
| `Alt-Tab` | Previous workspace |
| `Alt-/` / `Alt-,` | Tiles / accordion layout |
| `Alt-Shift-;` | Service mode (`Esc` reloads the config) |

::: warning
The template binds `Alt-c`, `Alt-e` and `Alt-s` to workspaces. While AeroSpace runs, these keys do not reach the terminal, so fzf's `Alt-c`, tmux.expose (`Alt-e`) and the zsh sesh picker (`Alt-s`) do not work. Remove the workspace bindings you do not need from `aerospace.toml`.
:::

## Starship

[Starship](https://starship.rs) reads `~/.config/starship.toml`, its default location. The config only changes the prompt character to `λ`: green after success, red after an error.
