
return {
  "mfussenegger/nvim-dap-python",
  keys = {
    {
      mode = "n",
      "<leader>df",
      function()
        require("dap").continue()
      end,
      desc = "Debug current file",
    },
    {
      mode = "n",
      "<leader>dm",
      function()
        local dap = require("dap")
        local home = os.getenv("HOME")
        local python_path = home .. "/.virtualenvs/debugpy/bin/python"
        dap.run({
          name = "Debug Method",  -- Added name field
          type = "python",
          request = "launch",
          module = "pytest",
          args = {
            "-v",
            vim.fn.expand("%:p"),
            "--capture=no",
            "--no-header",
            "--no-summary",
            "-k",
            vim.fn.expand("<cword>"),
          },
          pythonPath = python_path,
          cwd = vim.fn.getcwd(),
          env = {
            PYTHONPATH = vim.fn.getcwd(),
          },
        })
      end,
      desc = "Test method under cursor",
    },
    {
      mode = "n",
      "<leader>dc",
      function()
        require("dap-python").test_method()
       end,
      desc = "Debug Test",
    },
    {
      mode = "v",
      "<leader>ds",
      function()
        require("dap-python").debug_selection()
      end,
      desc = "Debug selected code",
    },
  },
  config = function()
    local home = os.getenv("HOME")
    local python_path = home .. "/.virtualenvs/debugpy/bin/python"

    local dap = require("dap")
    local dap_python = require("dap-python")

    -- Set DAP log level to DEBUG
    dap.set_log_level("DEBUG")

    -- Setup dap-python with your Python interpreter
    dap_python.setup(python_path)
    dap_python.test_runner = "pytest"

    -- Configure the DAP adapter for Python
    dap.adapters.python = {
      type = "executable",
      command = python_path,
      args = { "-m", "debugpy.adapter" },
    }

    -- Define configurations for debugging Python files
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
          return python_path
        end,
        cwd = "${workspaceFolder}",
        env = {
          PYTHONPATH = "${workspaceFolder}",
        },
      },
    }
  end,
}

