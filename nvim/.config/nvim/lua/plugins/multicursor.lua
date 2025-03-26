return {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    keys = {
        {
            "<C-j>",
            function()
                -- Autopairs doesn't work with multiple cursors
                require("nvim-autopairs").disable()
                require("multicursor-nvim").matchAddCursor(1)
            end,
            desc = "Add multicursor by matching next word/selection",
            mode = { "n", "v" },
        },
        {
            "<C-k>",
            function()
                require("nvim-autopairs").disable()
                require("multicursor-nvim").matchAddCursor(-1)
            end,
            desc = "Add multicursor by matching previous word/selection",
            mode = { "n", "v" },
        },
        {
            "<C-S-J>",
            function()
                require("multicursor-nvim").matchSkipCursor(1)
            end,
            desc = "Skip multicursor and go to next word/selection",
            mode = { "n", "v" },
        },
        {
            "<C-S-K>",
            function()
                require("multicursor-nvim").matchSkipCursor(-1)
            end,
            desc = "Skip multicursor and go to previous word/selection",
            mode = { "n", "v" },
        },
        {
            "<leader>cc",
            function()
                require("multicursor-nvim").toggleCursor()
            end,
            desc = "Toggle multicursor at current position",
            mode = { "n", "v" },
        },
        {
            "<leader>cf",
            function()
                require("nvim-autopairs").disable()
                require("multicursor-nvim").matchAllAddCursors()
            end,
            desc = "Add multicursors at all locations matching word/selection in file",
            mode = { "n", "v" },
        },
        {
            "<Esc>",
            function()
                local mc = require("multicursor-nvim")
                local ap = require("nvim-autopairs")
                if not mc.cursorsEnabled() then
                    ap.disable()
                    mc.enableCursors()
                elseif mc.hasCursors() then
                    ap.enable()
                    mc.clearCursors()
                else
                    ap.enable()
                end
            end,
            desc = "Enable or remove multicursors",
        },
    },
    opts = {},
}
