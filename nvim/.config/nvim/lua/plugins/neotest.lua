return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                "fredrikaverpil/neotest-golang",
                version = "*",
                dependencies = {
                    "andythigpen/nvim-coverage",
                },
            },
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-golang")({
                        runner = "go",
                        go_test_args = {
                            "-v",
                            "-race",
                            "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
                        },
                    }),
                    require("rustaceanvim.neotest"),
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
                "<leader>ts",
                function()
                    require("neotest").summary.toggle()
                end,
                desc = "Toggle Summary",
            },
            {
                "<leader>ta",
                function()
                    ---@diagnostic disable-next-line: undefined-field
                    require("neotest").run.run(vim.uv.cwd())
                end,
                desc = "Test All",
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
