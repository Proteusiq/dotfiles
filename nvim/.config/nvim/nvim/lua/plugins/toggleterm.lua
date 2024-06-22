return {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    config = function()
        require("toggleterm").setup()

        local Terminal = require("toggleterm.terminal").Terminal
        local colors = require("config.colors").colors
        local defaults = {
            direction = "float",
            float_opts = {
                border = "single",
            },
            shade_terminals = false,
            highlights = {
                Normal = {
                    guibg = colors.grey14,
                },
                FloatBorder = {
                    guibg = colors.grey14,
                    guifg = colors.grey14,
                },
            },
        }

        local lazydocker = Terminal:new(vim.tbl_deep_extend("force", {
            cmd = "lazydocker -ucd ~/.config/lazydocker/",
            dir = "git_dir",
            hidden = true,
        }, defaults))

        function _toggle_lazydocker()
            lazydocker:toggle()
        end

        local irb = Terminal:new(vim.tbl_deep_extend("force", {
            cmd = "irb --noautocomplete",
        }, defaults))

        function _toggle_irb()
            irb:toggle()
        end

        local console = Terminal:new(vim.tbl_deep_extend("force", {
            cmd = "bundle exec rails console",
            dir = "git_dir",
        }, defaults))

        function _toggle_console()
            console:toggle()
        end

        local htop = Terminal:new(vim.tbl_deep_extend("force", {
            cmd = "htop",
        }, defaults))

        function _toggle_htop()
            htop:toggle()
        end
    end,
}
