-- Empty theme, we're using the StatusLine highlight group
-- which has support for blend. (See the rose-pine setup).
local theme = {
    normal = {
        a = { bg = nil, fg = nil },
    },
}

return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "meuter/lualine-so-fancy.nvim",
    },
    event = { "ColorScheme" },
    opts = {
        options = {
            theme = theme,
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = {
                "NvimTree",
                "TelescopePrompt",
                "qf",
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            },
        },
        sections = {
            lualine_a = { { "filename", color = "StatusLine", padding = { left = 2 } } },
            lualine_b = { { "diagnostics", color = "StatusLine" } },
            lualine_c = {},
            lualine_x = {
                { "fancy_macro", color = "StatusLine" },
                { "fancy_searchcount", color = "StatusLine" },
                { "fancy_location", color = "StatusLine" },
            },
            lualine_y = {},
            lualine_z = {},
        },
        inactive_sections = {
            lualine_a = { { "filename", color = "StatusLineNC", padding = { left = 2 } } },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
    },
}
