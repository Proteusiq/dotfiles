return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "isak102/telescope-git-file-history.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "tpope/vim-fugitive",
      },
    },
  },
  config = function()
    local builtin = require("telescope.builtin")
    require("telescope").load_extension("git_file_history")

    -- Telescope keymaps
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
  end,
}
