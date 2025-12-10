return {
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>sr", function() require("spectre").open() end, desc = "Search and Replace (Spectre)" },
    { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Search current word" },
    { "<leader>sf", function() require("spectre").open_file_search({ select_word = true }) end, desc = "Search in current file" },
  },
  opts = {},
}
