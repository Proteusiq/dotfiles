-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Python debugging
vim.g.python3_host_prog = "~/.virtualenvs/debugpy/bin/python"

vim.g.lazyvim_python_lsp = "pyright"
-- Set to "ruff_lsp" to use the old LSP implementation version.
vim.g.lazyvim_python_ruff = "ruff"

-- Auto Normal Mode
-- Automatically leave insert mode after 'updatetime' milliseconds of inactivity
vim.api.nvim_create_autocmd("CursorHoldI", {
  pattern = "*",
  callback = function()
    -- Check if still in insert mode before executing stopinsert
    if vim.fn.mode() == "i" then
      vim.cmd("stopinsert")
    end
  end,
})

-- Set 'updatetime' to 5 seconds (5000 ms) when entering insert mode
local original_updatetime -- Declare a variable to store the original updatetime

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    -- Save the current 'updatetime' only when entering insert mode
    original_updatetime = vim.o.updatetime -- Get the current 'updatetime' value
    vim.o.updatetime = 5000 -- Set to 5 seconds
  end,
})

-- Restore the original 'updatetime' when leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    if original_updatetime then
      vim.o.updatetime = original_updatetime -- Restore the original 'updatetime'
    end
  end,
})

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

