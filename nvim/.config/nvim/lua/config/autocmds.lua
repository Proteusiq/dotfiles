-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-save on focus lost or leaving insert/normal mode
local autosave_group = vim.api.nvim_create_augroup("AutoSave", { clear = true })

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertLeave" }, {
  group = autosave_group,
  callback = function(event)
    local buf = event.buf
    -- Only save if buffer is modified, has a name, and is a normal buffer
    if
      vim.bo[buf].modified
      and vim.bo[buf].buftype == ""
      and vim.fn.bufname(buf) ~= ""
      and vim.fn.filereadable(vim.fn.bufname(buf)) == 1
    then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("silent! write")
      end)
    end
  end,
  desc = "Auto-save on focus lost or mode change",
})
