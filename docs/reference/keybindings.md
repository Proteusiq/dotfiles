# Keybindings Reference

Quick reference for all keybindings across tools.

## Neovim

Leader key: `<Space>`

### Navigation

| Key | Action |
|-----|--------|
| `h/j/k/l` | Move cursor |
| `w/b` | Word forward/back |
| `0/$` | Line start/end |
| `gg/G` | File start/end |
| `Ctrl+d/u` | Half page down/up |
| `%` | Jump to matching bracket |
| `*/#` | Search word under cursor |

### File Explorer

| Key | Action |
|-----|--------|
| `<Space>e` | Toggle explorer |
| `a` | Add file |
| `d` | Delete |
| `r` | Rename |
| `c` | Copy |
| `m` | Move |

### Search & Find

| Key | Action |
|-----|--------|
| `<Space>ff` | Find files |
| `<Space>fg` | Live grep |
| `<Space>fb` | Buffers |
| `<Space>fr` | Recent files |
| `<Space>fh` | Help tags |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover docs |
| `<Space>ca` | Code actions |
| `<Space>cr` | Rename |
| `<Space>cf` | Format |

### Git

| Key | Action |
|-----|--------|
| `<Space>gg` | Lazygit |
| `]h/[h` | Next/prev hunk |
| `<Space>hp` | Preview hunk |
| `<Space>hs` | Stage hunk |

### Windows

| Key | Action |
|-----|--------|
| `Ctrl+h/j/k/l` | Navigate |
| `<Space>-` | Split horizontal |
| `<Space>\|` | Split vertical |
| `<Space>wd` | Close window |

### Buffers

| Key | Action |
|-----|--------|
| `Shift+h/l` | Prev/next buffer |
| `<Space>bd` | Delete buffer |
| `<Space>bb` | Switch buffer |

## tmux

Prefix: `Ctrl+a`

### Sessions

| Key | Action |
|-----|--------|
| `Ctrl+a s` | List sessions |
| `Ctrl+a $` | Rename session |
| `Ctrl+a d` | Detach |
| `Ctrl+a (/)` | Prev/next session |

### Windows

| Key | Action |
|-----|--------|
| `Ctrl+a c` | New window |
| `Ctrl+a n/p` | Next/prev window |
| `Ctrl+a 1-9` | Go to window |
| `Ctrl+a ,` | Rename window |
| `Ctrl+a &` | Kill window |

### Panes

| Key | Action |
|-----|--------|
| `Ctrl+a \|` | Split vertical |
| `Ctrl+a -` | Split horizontal |
| `Ctrl+a h/j/k/l` | Navigate panes |
| `Ctrl+a H/J/K/L` | Resize panes |
| `Ctrl+a z` | Zoom pane |
| `Ctrl+a x` | Kill pane |

### Copy Mode

| Key | Action |
|-----|--------|
| `Ctrl+a [` | Enter copy mode |
| `v` | Begin selection |
| `y` | Copy |
| `q` | Exit |

### Custom

| Key | Action |
|-----|--------|
| `Ctrl+a T` | sesh picker |
| `Ctrl+a I` | Install plugins |

## FZF

### Shell Integration

| Key | Action |
|-----|--------|
| `Ctrl+r` | Search history |
| `Ctrl+t` | Find files |
| `Alt+c` | Change directory |

### In FZF

| Key | Action |
|-----|--------|
| `Ctrl+j/k` | Move down/up |
| `Enter` | Select |
| `Tab` | Multi-select |
| `Ctrl+/` | Toggle preview |
| `Ctrl+y` | Copy to clipboard |

## Yazi

### Navigation

| Key | Action |
|-----|--------|
| `h/j/k/l` | Navigate |
| `gg/G` | Top/bottom |
| `Enter` | Open |
| `q` | Quit |
| `~` | Go home |

### Operations

| Key | Action |
|-----|--------|
| `a` | Create file |
| `A` | Create directory |
| `r` | Rename |
| `d` | Trash |
| `D` | Permanent delete |
| `y` | Yank (copy) |
| `x` | Cut |
| `p` | Paste |

### Selection

| Key | Action |
|-----|--------|
| `Space` | Toggle select |
| `v` | Visual mode |
| `V` | Select all |

### View

| Key | Action |
|-----|--------|
| `.` | Toggle hidden |
| `/` | Search |
| `z` | Jump (zoxide) |

## Lazygit

| Key | Action |
|-----|--------|
| `j/k` | Navigate |
| `Enter` | Expand/action |
| `Space` | Stage/unstage |
| `c` | Commit |
| `p` | Push |
| `P` | Pull |
| `b` | Branch |
| `m` | Merge |
| `r` | Rebase |
| `z` | Stash |
| `?` | Help |

## AeroSpace (Window Manager)

| Key | Action |
|-----|--------|
| `Alt+h/j/k/l` | Focus window |
| `Alt+Shift+h/j/k/l` | Move window |
| `Alt+1-9` | Switch workspace |
| `Alt+Shift+1-9` | Move to workspace |
| `Alt+f` | Toggle fullscreen |
| `Alt+Shift+Space` | Toggle float |
| `Alt+Enter` | New terminal |

## Quick Reference Card

```
┌─────────────────────────────────────────────────────┐
│                    NEOVIM                           │
│  <Space>e  explorer    <Space>ff  find files       │
│  <Space>fg grep        <Space>gg  lazygit          │
│  gd        definition  K          hover            │
├─────────────────────────────────────────────────────┤
│                    TMUX (Ctrl+a)                    │
│  c  new window    |/-  split     h/j/k/l  navigate │
│  n/p  next/prev   z    zoom      d        detach   │
├─────────────────────────────────────────────────────┤
│                    FZF                              │
│  Ctrl+r  history  Ctrl+t  files  Alt+c  cd         │
├─────────────────────────────────────────────────────┤
│                    YAZI                             │
│  h/j/k/l  navigate    a  create    d  delete       │
│  y  copy     x  cut   p  paste    .  hidden        │
└─────────────────────────────────────────────────────┘
```
