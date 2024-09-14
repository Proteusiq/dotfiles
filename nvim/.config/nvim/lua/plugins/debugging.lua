
return {
  "mfussenegger/nvim-dap-python",
  keys = {
    -- Existing key mapping for debugging tests
    {
      mode = "n",
      "<leader>df",
      function()
        require("dap-python").test_method()
      end,
      desc = "Debug Python Test Method",
    },
    -- New key mapping to debug the current method (function) under the cursor
    {
      mode = "n",
      "<leader>dm",
      function()
        require("dap-python").debug_method()
      end,
      desc = "Debug Python Method",
    },
    -- New key mapping to debug the current class under the cursor
    {
      mode = "n",
      "<leader>dc",
      function()
        require("dap-python").debug_class()
      end,
      desc = "Debug Python Class",
    },
  },
  config = function()
    require("dap-python").setup(vim.g.python3_host_prog)
    require("dap-python").test_runner = "pytest"
  end,
}

