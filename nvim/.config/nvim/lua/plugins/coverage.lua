return {
    {
        "andythigpen/nvim-coverage",
        lazy = true,
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("coverage").setup({
                auto_reload = true,
                lang = {
                    go = {
                        coverage_file = vim.fn.getcwd() .. "/coverage.out",
                    },
                },
            })
        end,
    },
}
