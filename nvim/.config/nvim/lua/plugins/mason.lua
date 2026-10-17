-- Extra Mason tools. Language servers and formatters come from the LazyVim
-- language extras in lazyvim.json; tools installed by Homebrew (ruff, ty) are not listed.
return {
  "mason-org/mason.nvim",
  opts = {
    ensure_installed = {
      "actionlint",
      "shellcheck",
    },
  },
}
