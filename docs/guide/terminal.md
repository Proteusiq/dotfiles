# Terminal Setup

The terminal stack consists of Ghostty, tmux, and sesh for a powerful, GPU-accelerated terminal experience.

## Ghostty

[Ghostty](https://ghostty.org) is a fast, GPU-accelerated terminal emulator written in Zig.

### Configuration

```bash
# ghostty/.config/ghostty/config
font-family = "Hack Nerd Font"
font-size = 14

theme = catppuccin-mocha

window-padding-x = 10
window-padding-y = 10

cursor-style = block
cursor-style-blink = false

copy-on-select = true
```

### Features

- **GPU Accelerated** - Uses native graphics APIs
- **Sub-millisecond latency** - Feels instant
- **Native macOS** - Integrates with system features
- **Ligature support** - Beautiful code fonts

## tmux

[tmux](https://github.com/tmux/tmux) is a terminal multiplexer for managing sessions, windows, and panes.

### Key Bindings

Prefix key is `Ctrl+a` (remapped from default `Ctrl+b`).

| Key | Action |
|-----|--------|
| `Ctrl+a c` | New window |
| `Ctrl+a n` | Next window |
| `Ctrl+a p` | Previous window |
| `Ctrl+a ,` | Rename window |
| `Ctrl+a &` | Kill window |
| `Ctrl+a \|` | Split vertical |
| `Ctrl+a -` | Split horizontal |
| `Ctrl+a h/j/k/l` | Navigate panes |
| `Ctrl+a H/J/K/L` | Resize panes |
| `Ctrl+a z` | Zoom pane |
| `Ctrl+a d` | Detach session |
| `Ctrl+a s` | List sessions |

### Configuration

```bash
# tmux/.tmux.conf

# Remap prefix
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Start windows and panes at 1
set -g base-index 1
setw -g pane-base-index 1

# Enable mouse
set -g mouse on

# Vi mode
setw -g mode-keys vi

# True color support
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"

# Faster escape time
set -sg escape-time 0

# Increase history
set -g history-limit 50000
```

### Plugins

Managed by [TPM](https://github.com/tmux-plugins/tpm):

| Plugin | Purpose |
|--------|---------|
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sensible defaults |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | Save/restore sessions |
| [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) | Auto-save sessions |
| [catppuccin/tmux](https://github.com/catppuccin/tmux) | Catppuccin theme |

Install plugins with `Ctrl+a I`.

## sesh

[sesh](https://github.com/joshmedeski/sesh) is a smart tmux session manager.

### Usage

```bash
# Interactive session picker
sesh connect

# Connect to specific session
sesh connect myproject

# List sessions
sesh list
```

### Keybinding

Press `Ctrl+a T` to open the sesh picker:

```bash
# In .tmux.conf
bind-key T run-shell "sesh connect $(sesh list | fzf)"
```

### Configuration

```toml
# sesh/.config/sesh/sesh.toml
[[session]]
name = "dotfiles"
path = "~/dotfiles"
startup_command = "nvim"

[[session]]
name = "projects"
path = "~/Codes"
```

## Workflow

### Starting a New Session

```bash
# Start tmux with sesh
sesh connect myproject

# Or manually
tmux new -s myproject
```

### Typical Layout

```
┌─────────────────────────────────────────┐
│ 1:editor │ 2:terminal │ 3:git │ 4:logs │ ← Windows
├─────────────────────────────────────────┤
│                                         │
│              Neovim                      │
│                                         │
├────────────────────┬────────────────────┤
│    Terminal 1      │    Terminal 2      │ ← Panes
└────────────────────┴────────────────────┘
```

### Session Persistence

Sessions are automatically saved every 15 minutes by tmux-continuum.

Restore on tmux start:
```bash
# Sessions restored automatically
tmux
```

## Tips

### Copy Mode

Enter copy mode with `Ctrl+a [`:

| Key | Action |
|-----|--------|
| `v` | Begin selection |
| `y` | Copy selection |
| `q` | Exit copy mode |
| `/` | Search forward |
| `?` | Search backward |

### Quick Navigation

```bash
# Switch sessions
Ctrl+a s    # List and select

# Switch windows
Ctrl+a 1-9  # By number
Ctrl+a n/p  # Next/previous

# Switch panes
Ctrl+a h/j/k/l  # Vim-style
```

### Synchronize Panes

Run the same command in all panes:

```bash
Ctrl+a :setw synchronize-panes on
```
