return {
  "MeanderingProgrammer/markdown.nvim",
  name = "render-markdown",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- Mandatory
    "nvim-tree/nvim-web-devicons", -- Optional but recommended
  },
  config = function()
    require("render-markdown").setup({})
  end,
}
