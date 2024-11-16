return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
            {
                "leoluz/nvim-dap-go",
                config = function()
                    require("dap-go").setup()
                end,
            },
        },
        config = function()
            require("dapui").setup()
        end,
        keys = {
            {
                "<leader>dd",
                function()
                    require("dapui").toggle()
                end,
                desc = "Open DAP UI",
            },
            {
                "<leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Toggle Breakpoint",
            },
            {
                "<leader>dc",
                function()
                    require("dap").continue()
                end,
                desc = "Continue",
            },
        },
    },
}
