-- Parsers not already added by LazyVim or its language extras.
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "bicep",
      "c",
      "css",
      "html",
      "latex",
      "scss",
      "svelte",
      "typst",
      "vue",
    },
  },
}
