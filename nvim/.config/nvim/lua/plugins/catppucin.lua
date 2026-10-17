-- Catppuccin Mocha everywhere: Ghostty, tmux, fzf, delta and Neovim.
return {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, opts = { flavour = "mocha" } },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },
}
