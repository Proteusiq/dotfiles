-- Python: ty (type checking) + ruff (lint, format), both from Homebrew.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ty = { mason = false },
        ruff = { mason = false },
      },
    },
  },
  -- OpenTofu formats Terraform files; the terraform binary is not installed.
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        terraform = { "tofu_fmt" },
        tf = { "tofu_fmt" },
        ["terraform-vars"] = { "tofu_fmt" },
      },
    },
  },
}
