return {
  "SmiteshP/nvim-navbuddy",
  dependencies = {
    "neovim/nvim-lspconfig",
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>cn", "<cmd>Navbuddy<cr>", desc = "Navbuddy (symbols)" },
  },
  opts = {
    window = { border = "double" },
    lsp = { auto_attach = true },
  },
  config = function(_, opts)
    local actions = require("nvim-navbuddy.actions")
    opts.mappings = {
      ["k"] = actions.next_sibling(),
      ["i"] = actions.previous_sibling(),
      ["j"] = actions.parent(),
      ["l"] = actions.children(),
      ["q"] = actions.close(),
      ["<esc>"] = actions.close(),
    }
    require("nvim-navbuddy").setup(opts)
  end,
}
