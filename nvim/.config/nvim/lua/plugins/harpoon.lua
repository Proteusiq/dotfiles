-- Harpoon: pin up to four files and jump to them with <leader>1..4.
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = function()
    local function harpoon()
      return require("harpoon")
    end
    local keys = {
      {
        "<leader>a",
        function()
          harpoon():list():add()
        end,
        desc = "Harpoon add file",
      },
      {
        "<C-e>",
        function()
          harpoon().ui:toggle_quick_menu(harpoon():list())
        end,
        desc = "Harpoon menu",
      },
      {
        "<C-S-P>",
        function()
          harpoon():list():prev()
        end,
        desc = "Harpoon previous",
      },
      {
        "<C-S-N>",
        function()
          harpoon():list():next()
        end,
        desc = "Harpoon next",
      },
    }
    for index = 1, 4 do
      table.insert(keys, {
        "<leader>" .. index,
        function()
          harpoon():list():select(index)
        end,
        desc = "Harpoon file " .. index,
      })
    end
    return keys
  end,
  opts = {},
  config = function(_, opts)
    require("harpoon"):setup(opts)
  end,
}
