return {
  'zeybek/camouflage.nvim',
  lazy = false,
  opts = {},
  keys = {
    { '<leader>ct', '<cmd>CamouflageToggle<cr>', desc = 'Toggle Camouflage' },
    { '<leader>cr', '<cmd>CamouflageReveal<cr>', desc = 'Reveal Line' },
    { '<leader>cy', '<cmd>CamouflageYank<cr>', desc = 'Yank Value' },
  },
  config = function(_, opts)
    local camouflage = require('camouflage')
    camouflage.setup(opts)

    local sensitive_patterns = {
      'api[_-]?key',
      'apikey',
      'secret',
      'password',
      'passwd',
      'token',
      'credential',
      'auth',
      'private[_-]?key',
      'access[_-]?key',
      'client[_-]?secret',
      'bearer',
    }

    camouflage.on('variable_detected', function(_, var)
      local key_lower = var.key:lower()
      for _, pattern in ipairs(sensitive_patterns) do
        if key_lower:match(pattern) then
          return true
        end
      end
      return false
    end)
  end,
}
