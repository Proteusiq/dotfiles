-- Snacks options on top of LazyVim's defaults. LazyVim already maps the snacks
-- pickers, lazygit, scratch, notifications and toggles.
return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        header = [[
██╗  ██╗██████╗
██║  ██║╚════██╗
███████║ █████╔╝
╚════██║██╔═══╝
     ██║███████╗
     ╚═╝╚══════╝]],
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
    image = { enabled = true },
    notifier = { timeout = 3000, top_down = true },
    styles = {
      notification = { wo = { wrap = true } },
    },
  },
  keys = {
    {
      "<leader>gH",
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "Git file history",
    },
    {
      "<leader>N",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = { spell = false, wrap = false, signcolumn = "yes", statuscolumn = " ", conceallevel = 3 },
        })
      end,
      desc = "Neovim News",
    },
  },
}
