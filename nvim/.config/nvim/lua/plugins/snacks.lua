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
        {
            "<leader>zz",
            function()
                Snacks.zen()
            end,
            desc = "Zen Mode",
        },
    },
    --- @type snacks.Config
    opts = {
        -- Automatically set ft=bigfile for large files and files with long
        -- lines to avoid LSP and TS attaching to the buffer
        bigfile = { enabled = true },

        -- Zen mode
        zen = {
            -- Disable code dimming/twilight
            toggles = {
                dim = false,
            },
            win = {
                -- Uniform background (same as terminal/theme)
                backdrop = {
                    transparent = false,
                    blend = 99,
                },
            },
        },

        -- Telescope replacement
        picker = {
            enabled = true,
            win = {
                list = {
                    on_buf = function(self)
                        self:execute("calculate_file_truncate_width")
                    end,
                },
                preview = {
                    on_buf = function(self)
                        self:execute("calculate_file_truncate_width")
                    end,
                    on_close = function(self)
                        self:execute("calculate_file_truncate_width")
                    end,
                },
            },
            actions = {
                -- Make file truncation consider window width
                -- https://github.com/folke/snacks.nvim/issues/1217#issuecomment-2661465574
                calculate_file_truncate_width = function(self)
                    local width = self.list.win:size().width
                    self.opts.formatters.file.truncate = width - 6
                end,
            },
        },
    },
}
