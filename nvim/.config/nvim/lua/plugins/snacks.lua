return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
        {
            "<C-p>",
            function()
                Snacks.picker.smart()
            end,
            desc = "Smart Find Files",
        },
        {
            "<leader>fi",
            function()
                Snacks.picker.grep({
                    layout = { preset = "default" },
                })
            end,
            desc = "Grep",
        },
        {
            "<leader>fb",
            function()
                Snacks.picker.lines({
                    layout = { preset = "select" },
                })
            end,
            desc = "Buffer Lines",
        },
        {
            "<leader>ff",
            function()
                Snacks.picker.resume()
            end,
            desc = "Resume",
        },
    },
    --- @type snacks.Config
    opts = {
        -- Automatically set ft=bigfile for large files and files with long
        -- lines to avoid LSP and TS attaching to the buffer
        bigfile = { enabled = true },

        -- Telescope replacement
        picker = { enabled = true },
    },
}
