

return {
  "mfussenegger/nvim-dap-python",
  keys = {
    -- Key mapping for debugging the current test method
    {
      mode = "n",
      "<leader>df",
      function()
        require("dap-python").test_method()
      end,
      desc = "Debug Python Test Method",
    },
    -- Key mapping for debugging the current test class
    {
      mode = "n",
      "<leader>dc",
      function()
        require("dap-python").test_class()
      end,
      desc = "Debug Python Test Class",
    },
    -- Key mapping for testing the current file (module)
    {
      mode = "n",
      "<leader>dm",
      function()
        require("dap-python").test_module()
      end,
      desc = "Debug Python Test Module",
    },
    -- Key mapping for debugging the entire file (non-test code)
    {
      mode = "n",
      "<leader>dr",
      function()
        require("dap-python").debug_file()
      end,
      desc = "Debug Python File",
    },
    -- Custom key mapping to debug the function under the cursor (non-test code)
    {
      mode = "n",
      "<leader>dfn",
      function()
        local dap = require("dap")
        local python = require("dap-python")
        local utils = require("dap-python.utils")
        local file_path = vim.fn.expand("%:p")
        local line_num = vim.fn.line(".")
        local func_name = utils.get_func_name_at_line(file_path, line_num)
        if func_name then
          python.debug_at_point()
        else
          print("No function found under cursor.")
        end
      end,
      desc = "Debug Function Under Cursor",
    },
  },
  config = function()
    require("dap-python").setup(vim.g.python3_host_prog)
    require("dap-python").test_runner = "pytest"
  end,
}

