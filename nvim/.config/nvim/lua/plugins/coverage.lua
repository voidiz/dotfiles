return {
    {
        "andythigpen/nvim-coverage",
        event = "VeryLazy",
        cmd = {
            "Coverage",
            "CoverageLoad",
            "CoverageLoadLcov",
            "CoverageShow",
            "CoverageHide",
            "CoverageToggle",
            "CoverageClear",
            "CoverageSummary",
        },
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
