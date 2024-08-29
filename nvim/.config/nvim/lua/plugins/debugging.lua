return {
  "mfussenegger/nvim-dap-python",
  keys = {
    {
      mode = "n",
      "<leader>df",
      function()
        require("dap-python").test_method()
      end,
    },
  },
  config = function()
    require("dap-python").setup(vim.g.python3_host_prog)
    require("dap-python").test_runner = "pytest"
  end,
}
