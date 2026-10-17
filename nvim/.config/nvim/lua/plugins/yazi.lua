---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  keys = {
    {
      "<leader>fy",
      function()
        require("yazi").yazi()
      end,
      desc = "Yazi (current file)",
    },
    {
      "<leader>fY",
      function()
        require("yazi").yazi(nil, vim.fn.getcwd())
      end,
      desc = "Yazi (cwd)",
    },
  },
  ---@type YaziConfig
  opts = {
    open_for_directories = false,
  },
}
