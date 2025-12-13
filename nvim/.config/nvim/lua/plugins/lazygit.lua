-- lazygit.nvim - standalone lazygit plugin with telescope integration
-- Provides telescope extension to track all git repos visited in a session
return {
  "kdheepak/lazygit.nvim",
  lazy = false, -- required for telescope extension tracking
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("telescope").load_extension("lazygit")
  end,
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    { "<leader>gG", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit (current file)" },
    {
      "<leader>gL",
      function()
        require("telescope").extensions.lazygit.lazygit()
      end,
      desc = "LazyGit Repos (Telescope)",
    },
  },
}
