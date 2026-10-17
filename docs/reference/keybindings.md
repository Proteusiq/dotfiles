# Keybindings Reference

Keybindings configured in this repository, plus the most used defaults of the tools they build on. Each section names the file it comes from.

Notation: `prefix` is the tmux prefix, `<leader>` is `Space` in Neovim, `C-x` is Ctrl+x, `M-x`/`Alt+x` is Option+x.

::: tip Alt in Ghostty
Ghostty sets `macos-option-as-alt = left`, so only the **left** Option key works as Alt.
:::

## tmux

Source: `tmux/.tmux.conf`. The prefix is tmux's default **`C-b`** (not overridden). tmux's built-in bindings that are not listed here (detach, zoom, window switching, ...) are unchanged.

### Panes and windows

| Key | Action |
|-----|--------|
| `prefix i` | Split right (side by side), in the current directory |
| `prefix -` | Split down (stacked), in the current directory |
| `C-h` / `C-j` / `C-k` / `C-l` | Move to the pane left / down / up / right. **No prefix.** In a pane running Neovim the key is passed to Neovim, which moves between its own windows |
| `prefix h` / `j` / `k` / `l` | Resize pane by 10 cells left / down / up / right (repeatable) |
| `prefix x` | Kill pane (no confirmation) |
| `prefix c` | New window in the current directory |
| `prefix <` / `prefix >` | Swap window with the previous / next one (repeatable) |
| `prefix C-s` | Toggle synchronize-panes |
| `prefix r` | Reload `~/.tmux.conf` |

### Popups and session pickers

| Key | Action |
|-----|--------|
| `prefix g` | lazygit in a full-screen popup, in the pane's directory |
| `prefix D` | lazydocker in a full-screen popup |
| `prefix K` | sesh session picker with gum |
| `prefix T` | sesh session picker with fzf (see below) |
| `Alt+e` | tmux.expose: grid of live session previews. **No prefix** |

Inside the `prefix T` picker:

| Key | Action |
|-----|--------|
| `Tab` / `Shift+Tab` | Down / up |
| `C-a` | All sessions |
| `C-t` | tmux sessions |
| `C-g` | sesh configs |
| `C-x` | zoxide directories |
| `C-f` | Find directories under `~` (depth 2) |
| `C-d` | Kill the selected tmux session |

sesh sessions defined in `sesh/.config/sesh/sesh.toml`: `Downloads 📥` (opens yazi), `dotfiles` (opens nvim), `tmux config` (opens `.tmux.conf` in nvim).

### Copy mode (vi keys)

| Key | Action |
|-----|--------|
| `v` | Begin selection |
| `y` | Copy selection and leave copy mode |
| `r` | Toggle rectangle selection |
| `prefix P` | Paste buffer |

Key bindings in `.tmux.conf` come after tpm, so they override plugin defaults: `prefix P` pastes (not the tmux-floax menu) and `prefix C-s` toggles synchronized panes (not tmux-resurrect save).

### Plugin default keys

Not set in `.tmux.conf`; these are each plugin's defaults (from the plugin source under `~/.tmux/plugins/`).

| Key | Plugin | Action |
|-----|--------|--------|
| `prefix O` | tmux-sessionx | Session manager popup |
| `prefix p` | tmux-floax | Floating pane |
| `prefix Space` | tmux-thumbs | Pick text on screen by hint and copy it |
| `prefix u` | tmux-fzf-url | Open a URL from the pane |
| `prefix F` | tmux-fzf | tmux-fzf menu |
| `prefix I` | tpm | Install plugins |

## Ghostty

Source: `ghostty/.config/ghostty/config`. All custom bindings are sequences starting with `Cmd+b`. Ghostty starts tmux automatically (see `zsh/.zshrc`), so these are mostly useful outside tmux.

| Key | Action |
|-----|--------|
| `Cmd+b` `r` | Reload config |
| `Cmd+b` `x` | Close window |
| `Cmd+b` `n` | New window |
| `Cmd+b` `i` | New split to the right |
| `Cmd+b` `-` | New split below |
| `Cmd+b` `h` / `j` / `k` / `l` | Go to split left / bottom / top / right |
| `Cmd+b` `z` | Toggle split zoom |
| `Cmd+b` `e` | Equalize splits |

`copy-on-select = clipboard`: selecting text copies it.

## Zsh

Sources: `zsh/.zshrc`, `zsh/.config/zsh/fzf.zsh`, `zsh/.config/zsh/functions.zsh`.

| Key | Action | Provided by |
|-----|--------|-------------|
| `C-r` | Search shell history | atuin (loaded last, so it owns `C-r`) |
| `Up` | History search | atuin |
| `C-t` | Insert a file path (fd list, bat/eza preview) | fzf |
| `Alt+c` | cd into a directory (fd list, eza tree preview) | fzf |
| `<cmd> **<Tab>` | fzf completion, with previews per command | fzf |
| `Alt+s` | Pick a tmux session with sesh + fzf (`sesh-sessions`) | functions.zsh |
| `C-g` then `f` / `b` / `t` / `r` / `h` / `s` / `l` / `e` / `w` | fzf-git: files, branches, tags, remotes, hashes (commits), stashes, reflogs, each-ref, worktrees | fzf-git.sh |

Atuin runs the selected command on Enter (`enter_accept = true` in `atuin/.config/atuin/config.toml`).

## Neovim

Neovim runs LazyVim. Leader is `Space`. Press `<leader>` and wait for which-key to list everything; `<leader>sk` searches all keymaps.

### Custom keys

Source: `nvim/.config/nvim/lua/plugins/*.lua`. Everything not listed here is a LazyVim default.

**Harpoon** (`harpoon.lua`)

| Key | Action |
|-----|--------|
| `<leader>a` | Add file to Harpoon |
| `C-e` | Harpoon menu |
| `<leader>1` … `<leader>4` | Jump to Harpoon file 1–4 |
| `C-S-p` / `C-S-n` | Previous / next Harpoon file |

**Multicursor** (`multicursor.lua`)

| Key | Action |
|-----|--------|
| `Up` / `Down` | Add a cursor on the line above / below |
| `<leader>Up` / `<leader>Down` | Skip the line above / below |
| `<leader>mn` / `<leader>mN` | Add a cursor at the next / previous match |
| `<leader>ms` / `<leader>mS` | Skip the next / previous match |
| `C-LeftMouse` | Add or remove a cursor with the mouse |
| `C-q` | Disable / enable cursors |

With several cursors active:

| Key | Action |
|-----|--------|
| `Left` / `Right` | Make the previous / next cursor the main one |
| `<leader>x` | Delete the main cursor |
| `Esc` | Enable cursors if disabled, otherwise clear them |

**Other plugins**

| Key | Action | Plugin |
|-----|--------|--------|
| `<leader>fy` | Yazi at the current file | yazi.nvim |
| `<leader>fY` | Yazi in the working directory | yazi.nvim |
| `<leader>cn` | Navbuddy symbol tree | nvim-navbuddy |
| `<leader>ct` | Toggle masking of secrets | camouflage.nvim |
| `<leader>cv` | Reveal the secret on this line | camouflage.nvim |
| `<leader>cy` | Yank the secret value | camouflage.nvim |
| `<leader>gH` | Git history of the current file (snacks picker) | snacks.nvim |
| `<leader>N` | Neovim news (`doc/news.txt`) | snacks.nvim |

Inside Navbuddy (`navbuddy.lua`): `k` next sibling, `i` previous sibling, `j` parent, `l` children, `q`/`Esc` close.

**opencode** (`opencode.lua`)

| Key | Action |
|-----|--------|
| `<leader>oa` | Ask about this (`@this`) |
| `<leader>os` | Select prompt |
| `<leader>o+` | Add this to the prompt |
| `<leader>ot` | Toggle embedded opencode |
| `<leader>oc` | Select command |
| `<leader>on` | New session |
| `<leader>oi` | Interrupt session |
| `<leader>oA` | Cycle agent |
| `C-S-u` / `C-S-d` | Scroll opencode messages half a page up / down |

**Plugin defaults** (plugins added in `lua/plugins/`, keys are the plugins' own defaults)

| Key | Action | Plugin |
|-----|--------|--------|
| `ys{motion}{char}` / `ds{char}` / `cs{old}{new}` | Add / delete / change surround | nvim-surround |
| `co` / `ct` / `cb` / `c0` | Conflict: choose ours / theirs / both / none | git-conflict.nvim |
| `]x` / `[x` | Next / previous conflict | git-conflict.nvim |
| `:Atone` | Undo tree | atone.nvim |
| `:Typr` | Typing practice | typr |

### LazyVim defaults (most used)

Verified against the installed LazyVim source (`config/keymaps.lua`, `plugins/`, and the extras enabled in `lazyvim.json`). The picker is snacks, the explorer is neo-tree (`editor.neo-tree` extra).

**Files and search**

| Key | Action |
|-----|--------|
| `<leader><space>` / `<leader>ff` | Find files (root dir) |
| `<leader>fg` | Find git files |
| `<leader>fr` | Recent files |
| `<leader>fc` | Find config file |
| `<leader>,` / `<leader>fb` | Buffers |
| `<leader>/` / `<leader>sg` | Grep (root dir) |
| `<leader>sw` | Grep word or selection |
| `<leader>sh` | Help pages |
| `<leader>sk` | Keymaps |
| `<leader>e` / `<leader>E` | Neo-tree explorer (root dir / cwd) |
| `<leader>fn` | New file |
| `C-s` | Save file |
| `<leader>.` | Toggle scratch buffer |
| `<leader>qq` | Quit all |

**Windows and buffers**

| Key | Action |
|-----|--------|
| `C-h` / `C-j` / `C-k` / `C-l` | Go to window left / down / up / right |
| `<leader>-` / `<leader>\|` | Split window below / right |
| `<leader>wd` | Delete window |
| `S-h` / `S-l` | Previous / next buffer |
| `<leader>bb` | Switch to other buffer |
| `<leader>bd` | Delete buffer |

**Code and LSP**

| Key | Action |
|-----|--------|
| `gd` / `gr` / `gI` / `gy` | Definition / references / implementation / type definition |
| `gD` | Declaration |
| `K` / `gK` | Hover / signature help |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cR` | Rename file |
| `<leader>cf` | Format |
| `<leader>cd` | Line diagnostics |
| `]d` / `[d` | Next / previous diagnostic |
| `<leader>ss` / `<leader>sS` | LSP symbols / workspace symbols |
| `<leader>cl` | LSP info |

**Git**

| Key | Action |
|-----|--------|
| `<leader>gg` / `<leader>gG` | lazygit (root dir / cwd), through snacks |
| `<leader>gl` / `<leader>gL` | Git log (root dir / cwd) |
| `<leader>gf` | Current file history |
| `<leader>gb` | Blame line |
| `<leader>gB` | Open in browser |
| `]h` / `[h` | Next / previous hunk |
| `<leader>ghs` / `<leader>ghr` | Stage / reset hunk |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` | Blame line (full) |

**Tests** (`test.core` extra)

| Key | Action |
|-----|--------|
| `<leader>tr` | Run nearest test |
| `<leader>tt` | Run file |
| `<leader>tT` | Run all test files |
| `<leader>tl` | Run last |
| `<leader>ts` | Toggle summary |
| `<leader>to` | Show output |
| `<leader>tS` | Stop |
| `<leader>td` | Debug nearest |

**Debugging** (`dap.core` and `lang.python` extras)

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Run / continue |
| `<leader>di` / `<leader>dO` / `<leader>do` | Step into / over / out |
| `<leader>du` | Toggle DAP UI |
| `<leader>dt` | Terminate |
| `<leader>dPt` | Debug Python test method |
| `<leader>dPc` | Debug Python test class |

**Motion and yank** (`editor.leap`, `coding.yanky` extras)

| Key | Action |
|-----|--------|
| `s` / `S` | Leap forward / backward |
| `gs` | Leap to other windows |
| `[y` / `]y` | Cycle through yank history after a put |
| `<leader>p` | Yank history picker |

**UI toggles**

| Key | Action |
|-----|--------|
| `<leader>us` | Spelling |
| `<leader>uw` | Wrap |
| `<leader>ul` / `<leader>uL` | Line numbers / relative numbers |
| `<leader>ud` | Diagnostics |
| `<leader>uh` | Inlay hints |
| `<leader>ub` | Dark / light background |
| `<leader>uT` | Treesitter highlighting |
| `<leader>uC` | Colorscheme picker |
| `<leader>n` | Notification history |
| `<leader>l` | Lazy (plugin manager) |
| `<leader>L` | LazyVim changelog |

## Yazi

Source: `yazi/.config/yazi/keymap.toml`. These are **prepended** to Yazi's defaults: a listed key replaces the default action of that key; keys not listed keep their default.

Navigation uses a Colemak-style `u`/`e`/`n`/`i` layout instead of `k`/`j`/`h`/`l`.

### File manager

| Key | Action |
|-----|--------|
| `u` / `e` | Up / down |
| `U` / `E` | Up / down 5 |
| `n` | Parent directory (leave) |
| `i` | Enter directory or open file (smart-enter plugin) |
| `N` / `I` | Back / forward in history |
| `C-u` / `C-e` | Scroll preview up / down 5 |
| `l` | Symlink the yanked files |
| `L` | Symlink the yanked files (relative path) |
| `-` / `=` | Next / previous find match |
| `w` | Open a shell here |
| `W` | Show tasks |

Tasks view: `W` closes it, `u`/`e` move. Select and help views: `u`/`e` move, `U`/`E` move 5. Completion menu: `C-u`/`C-e` move.

### Text input

| Key | Action |
|-----|--------|
| `k` | Insert mode |
| `C-n` / `C-i` | Insert at start / append at end |
| `n` / `i` | Cursor left / right |
| `N` / `I` | Start / end of line |
| `h` | Forward to end of word |
| `x` | Delete character |
| `l` / `L` | Undo / redo |

Shell function `yy` opens yazi and, on exit, changes the shell to the directory you were in.

## AeroSpace

Source: `aerospace/.config/aerospace/aerospace.toml` (AeroSpace's default template; `start-at-login = false`).

| Key | Action |
|-----|--------|
| `Alt+h/j/k/l` | Focus window left / down / up / right |
| `Alt+Shift+h/j/k/l` | Move window |
| `Alt+1`…`9`, `Alt+a`…`z` | Switch to workspace (letters: A–G, I, M–Z) |
| `Alt+Shift+1`…`9`, `Alt+Shift+<letter>` | Move window to workspace |
| `Alt+/` | Tiles layout (toggle horizontal / vertical) |
| `Alt+,` | Accordion layout (toggle horizontal / vertical) |
| `Alt+Shift+-` / `Alt+Shift+=` | Resize smaller / larger |
| `Alt+Tab` | Previous workspace |
| `Alt+Shift+Tab` | Move workspace to the next monitor |
| `Alt+Shift+;` | Service mode |

Service mode: `Esc` reload config, `r` reset layout, `f` toggle floating/tiling, `Backspace` close all windows but the current one, `Alt+Shift+h/j/k/l` join with neighbour.

::: warning Conflicts
AeroSpace's hotkeys are global. While it runs, `Alt+e` (workspace E) and `Alt+s` (workspace S) are taken before the terminal sees them, so tmux.expose (`Alt+e`) and `sesh-sessions` (`Alt+s`) do not fire.
:::
