-- Mask secret values in .env and similar files until revealed.
local SENSITIVE_KEY_PATTERNS = {
  "api[_-]?key",
  "apikey",
  "secret",
  "password",
  "passwd",
  "token",
  "credential",
  "auth",
  "private[_-]?key",
  "access[_-]?key",
  "client[_-]?secret",
  "bearer",
}

return {
  "zeybek/camouflage.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
  keys = {
    { "<leader>ct", "<cmd>CamouflageToggle<cr>", desc = "Toggle Camouflage" },
    { "<leader>cv", "<cmd>CamouflageReveal<cr>", desc = "Reveal secret on line" },
    { "<leader>cy", "<cmd>CamouflageYank<cr>", desc = "Yank secret value" },
  },
  config = function(_, opts)
    local camouflage = require("camouflage")
    camouflage.setup(opts)
    camouflage.on("variable_detected", function(_, var)
      local key_lower = var.key:lower()
      for _, pattern in ipairs(SENSITIVE_KEY_PATTERNS) do
        if key_lower:match(pattern) then
          return true
        end
      end
      return false
    end)
  end,
}
