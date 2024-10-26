return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            { "fredrikaverpil/neotest-golang", version = "*" },
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-golang"),
                },
                discovery = {
                    -- Only AST parse the currently opened buffer.
                    enabled = false,
                },
            })
        end,
        keys = {
            {
                "<leader>tt",
                function()
                    require("neotest").output_panel.toggle()
                end,
                desc = "Show Test Output",
            },
            {
                "<leader>tn",
                function()
                    require("neotest").run.run()
                end,
                desc = "Test Nearest",
            },
            {
                "<leader>dn",
                function()
                    require("neotest").run.run({ suite = false, strategy = "dap" })
                end,
                desc = "Debug Nearest",
            },
        },
    },
}
