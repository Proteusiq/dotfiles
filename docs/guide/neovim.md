# Neovim

Neovim uses [LazyVim](https://lazyvim.org) as its base. The configuration adds language extras, a few plugins and some options. Everything else is LazyVim's default.

## Files

```
nvim/.config/nvim/
├── init.lua              # loads config/lazy.lua
├── lazyvim.json          # LazyVim extras (the only list)
├── lazy-lock.json        # plugin versions (tracked)
└── lua/
    ├── config/
    │   ├── lazy.lua      # lazy.nvim setup
    │   ├── options.lua   # options, Python provider, auto-normal mode
    │   ├── autocmds.lua  # autosave
    │   └── keymaps.lua   # empty: LazyVim defaults
    └── plugins/          # one file per plugin or override
```

`lazy.lua` loads LazyVim, then every file in `lua/plugins/`. Custom plugins are not lazy-loaded unless their spec says so. lazy.nvim checks for plugin updates in the background and does not notify.

## Extras

`lazyvim.json` enables these LazyVim extras:

| Group | Extras |
|-------|--------|
| Coding | `coding.yanky` |
| Debugging and tests | `dap.core`, `test.core` |
| Editor | `editor.leap`, `editor.neo-tree` |
| Languages | `lang.docker`, `lang.git`, `lang.go`, `lang.json`, `lang.markdown`, `lang.python`, `lang.rust`, `lang.sql`, `lang.terraform`, `lang.toml`, `lang.typescript`, `lang.yaml` |
| UI | `ui.mini-animate` |
| Utilities | `util.dot`, `util.octo` |

Change extras with `:LazyExtras`. It writes `lazyvim.json`.

LazyVim's defaults apply: blink.cmp for completion, the snacks picker, and lazygit through snacks (`<leader>gg`).

## Custom Plugins

| Plugin | Purpose | Keys |
|--------|---------|------|
| [harpoon](https://github.com/ThePrimeagen/harpoon) (harpoon2) | Pin files and jump to them | `<leader>a` add, `<C-e>` menu, `<leader>1`…`<leader>4` jump, `<C-S-P>`/`<C-S-N>` previous/next |
| [multicursor.nvim](https://github.com/jake-stewart/multicursor.nvim) | Multiple cursors | see [below](#multiple-cursors) |
| [camouflage.nvim](https://github.com/zeybek/camouflage.nvim) | Masks secret values in `.env` and similar files | `<leader>ct` toggle, `<leader>cv` reveal line, `<leader>cy` yank value |
| [yazi.nvim](https://github.com/mikavilpas/yazi.nvim) | Yazi in a floating window | `<leader>fy` at current file, `<leader>fY` in working directory |
| [nvim-navbuddy](https://github.com/SmiteshP/nvim-navbuddy) | Symbol tree navigation | `<leader>cn` |
| [opencode.nvim](https://github.com/NickvanDyke/opencode.nvim) | opencode AI agent | `<leader>oa` ask, `<leader>os` select prompt, `<leader>o+` add context, `<leader>ot` toggle, `<leader>oc` command, `<leader>on` new session, `<leader>oi` interrupt, `<leader>oA` cycle agent, `<S-C-u>`/`<S-C-d>` scroll messages |
| [atone.nvim](https://github.com/XXiaoA/atone.nvim) | Undo tree | `:Atone` |
| [better-escape.nvim](https://github.com/max397574/better-escape.nvim) | Leave insert mode with a key sequence | plugin defaults |
| [git-conflict.nvim](https://github.com/akinsho/git-conflict.nvim) | Resolve merge conflicts in the buffer | plugin defaults |
| [live-command.nvim](https://github.com/smjonas/live-command.nvim) | Preview commands while you type them | |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Add, change and delete surrounding pairs | plugin defaults |
| [typr](https://github.com/nvzone/typr) | Typing practice | `:Typr`, `:TyprStats` |
| [tiny-inline-diagnostic.nvim](https://github.com/rachartier/tiny-inline-diagnostic.nvim) | Inline diagnostics | Replaces virtual text, which is turned off |

Snacks adds two keys to LazyVim's defaults: `<leader>gH` (Git history of the current file) and `<leader>N` (Neovim news). It also sets a custom dashboard header, enables image previews, and shows notifications for 3 s.

In the navbuddy window, `k` and `i` move to the next and previous sibling, `j` to the parent, `l` to the children. `q` or `<Esc>` closes it.

### Multiple Cursors

| Keys | Action |
|------|--------|
| `<Up>` / `<Down>` | Add a cursor above / below |
| `<leader><Up>` / `<leader><Down>` | Skip a line above / below |
| `<leader>mn` / `<leader>mN` | Add a cursor at the next / previous match |
| `<leader>ms` / `<leader>mS` | Skip the next / previous match |
| `<C-q>` | Turn cursors on or off |
| `<C-LeftMouse>` | Add or remove a cursor |

With more than one cursor:

| Keys | Action |
|------|--------|
| `<Left>` / `<Right>` | Select the previous / next cursor as the main one |
| `<leader>x` | Delete the main cursor |
| `<Esc>` | Turn cursors back on, or clear them |

## Languages

### Python

| Part | Source |
|------|--------|
| Type checking | [ty](https://github.com/astral-sh/ty) (`vim.g.lazyvim_python_lsp = "ty"`) |
| Lint and format | [ruff](https://github.com/astral-sh/ruff) (`vim.g.lazyvim_python_ruff = "ruff"`) |
| Python provider | `~/.virtualenvs/neovim/bin/python` with `pynvim` |

ty and ruff come from Homebrew, so Mason does not install them (`mason = false` in `lua/plugins/lsp.lua`). The installer creates the provider environment; rebuild it with `update --only venv`.

Debugging uses `dap.core` and the Python extra. To debug the test under the cursor:

| Keys | Action |
|------|--------|
| `<leader>dPt` | Debug the test method |
| `<leader>dPc` | Debug the test class |

### Rust

Diagnostics come from rust-analyzer (`vim.g.lazyvim_rust_diagnostics = "rust-analyzer"`).

### Terraform

Terraform files are formatted with OpenTofu (`tofu fmt`, through conform.nvim). The `terraform` binary is not installed.

### Tree-sitter

`lua/plugins/treesitter.lua` adds parsers that the extras do not install: bicep, c, css, html, latex, scss, svelte, typst and vue.

### Mason

Language servers and formatters come from the language extras. `lua/plugins/mason.lua` adds `actionlint` and `shellcheck`. Open `:Mason` to see what is installed.

## Theme

The colorscheme is [Catppuccin](https://github.com/catppuccin/nvim), flavour Mocha, set in `lua/plugins/catppucin.lua`.

## Editing Behaviour

These come from `lua/config/`:

- **Autosave.** A modified buffer is written when you leave it, when Neovim loses focus, or when you leave insert mode. Only normal buffers whose file exists on disk are written.
- **Auto normal mode.** After 5 seconds without input in insert mode, Neovim returns to normal mode, and autosave writes the file. Outside insert mode, `updatetime` keeps its usual value.
- **Global statusline** (`laststatus = 3`).
- **`startofline`** is on: `gg` and `G` move to the first non-blank character.

## Updating

```vim
:Lazy sync
```

This updates the plugins and writes `lazy-lock.json`. The lock file is tracked, so commit it to keep machines on the same versions.

Other checks:

```vim
:Lazy         " plugin status
:Mason        " installed tools
:checkhealth  " Neovim health checks
```

For more keys, see the [Keybindings Reference](/reference/keybindings). LazyVim's own keys are listed at [lazyvim.org/keymaps](https://www.lazyvim.org/keymaps).
