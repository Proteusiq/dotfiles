# Neovim Configuration

This setup uses [LazyVim](https://lazyvim.org) as a base with custom plugins and keybindings optimized for Python, Rust, and web development.

## Quick Start

```bash
# Open Neovim
nvim

# Or use the alias
n
```

On first launch, LazyVim will automatically install all plugins.

## Structure

```
nvim/.config/nvim/
├── init.lua              # Entry point
├── lazyvim.json          # LazyVim configuration
└── lua/
    ├── config/
    │   ├── autocmds.lua  # Auto commands
    │   ├── keymaps.lua   # Custom keybindings
    │   ├── lazy.lua      # Plugin manager setup
    │   └── options.lua   # Editor options
    └── plugins/
        ├── coding.lua    # Completion, snippets
        ├── colorscheme.lua
        ├── editor.lua    # File explorer, search
        ├── lsp.lua       # Language servers
        └── ui.lua        # UI enhancements
```

## Key Mappings

Leader key is `<Space>`.

### General

| Key | Action |
|-----|--------|
| `<Space>` | Show which-key menu |
| `<Space>e` | Toggle file explorer |
| `<Space>ff` | Find files |
| `<Space>fg` | Live grep |
| `<Space>fb` | Browse buffers |
| `<Space>fr` | Recent files |

### File Explorer (Neo-tree)

| Key | Action |
|-----|--------|
| `<Space>e` | Toggle explorer |
| `a` | Add file/directory |
| `d` | Delete |
| `r` | Rename |
| `c` | Copy |
| `m` | Move |
| `y` | Copy path |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<Space>ca` | Code actions |
| `<Space>cr` | Rename symbol |
| `<Space>cf` | Format document |
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |

### Git

| Key | Action |
|-----|--------|
| `<Space>gg` | Open lazygit |
| `<Space>gf` | Git file history |
| `<Space>gb` | Git blame |
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<Space>hp` | Preview hunk |
| `<Space>hs` | Stage hunk |
| `<Space>hr` | Reset hunk |

### Windows & Buffers

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate windows |
| `<Space>-` | Split horizontal |
| `<Space>\|` | Split vertical |
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<Space>bd` | Delete buffer |

### Terminal

| Key | Action |
|-----|--------|
| `<C-/>` | Toggle terminal |
| `<Space>ft` | Float terminal |
| `<Esc><Esc>` | Exit terminal mode |

## Plugins

### UI & Navigation

| Plugin | Purpose |
|--------|---------|
| [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer |
| [telescope](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [which-key](https://github.com/folke/which-key.nvim) | Keybinding hints |
| [bufferline](https://github.com/akinsho/bufferline.nvim) | Buffer tabs |
| [lualine](https://github.com/nvim-lualine/lualine.nvim) | Status line |

### Coding

| Plugin | Purpose |
|--------|---------|
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Completion engine |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippets |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto brackets |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Smart comments |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Surround text |

### LSP & Diagnostics

| Plugin | Purpose |
|--------|---------|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configuration |
| [mason](https://github.com/williamboman/mason.nvim) | LSP installer |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatting |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | Linting |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Diagnostics panel |

### Git

| Plugin | Purpose |
|--------|---------|
| [gitsigns](https://github.com/lewis6991/gitsigns.nvim) | Git decorations |
| [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) | Lazygit integration |
| [diffview](https://github.com/sindrets/diffview.nvim) | Diff viewer |

## Language Support

### Python

- LSP: `pyright`
- Formatter: `ruff`
- Linter: `ruff`
- Debugger: `debugpy`

```lua
-- Auto-activate virtual environments
vim.g.python3_host_prog = "~/.virtualenvs/neovim/bin/python"
```

### Rust

- LSP: `rust-analyzer`
- Formatter: `rustfmt`

### TypeScript/JavaScript

- LSP: `typescript-language-server`
- Formatter: `biome` or `prettier`
- Linter: `biome` or `eslint`

### Go

- LSP: `gopls`
- Formatter: `gofmt`

## Colorscheme

Uses [Catppuccin Mocha](https://github.com/catppuccin/nvim) for a consistent look across all tools.

```lua
-- lua/plugins/colorscheme.lua
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    flavour = "mocha",
    transparent_background = false,
    integrations = {
      cmp = true,
      gitsigns = true,
      neo_tree = true,
      telescope = true,
      treesitter = true,
      which_key = true,
    },
  },
}
```

## Tips

### Update Plugins

```vim
:Lazy update
```

### Check Health

```vim
:checkhealth
```

### Mason (LSP Manager)

```vim
:Mason
```

### Telescope Commands

```vim
:Telescope keymaps       " Search keybindings
:Telescope help_tags     " Search help
:Telescope commands      " Search commands
```
