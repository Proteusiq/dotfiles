return {
  "MeanderingProgrammer/markdown.nvim",
  name = "render-markdown",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- Mandatory
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("render-markdown").setup({})
  end,
}
