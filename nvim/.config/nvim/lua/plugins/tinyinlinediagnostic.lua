-- Inline diagnostics replace Neovim's virtual text. Disabled through LazyVim's
-- diagnostics options so LazyVim does not turn virtual text back on.
return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    opts = { diagnostics = { virtual_text = false } },
  },
}
