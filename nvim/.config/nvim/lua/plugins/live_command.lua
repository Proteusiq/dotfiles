return {
  "smjonas/live-command.nvim",
  -- live-command supports semantic versioning via Git tags
  -- tag = "2.*",
  config = function()
    require("live-command").setup()
  end,
}
