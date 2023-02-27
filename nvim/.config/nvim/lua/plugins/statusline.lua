local M = {
    -- Statusline
    "freddiehaddad/feline.nvim",
}

function M.config()
    local vi_mode_utils = require("feline.providers.vi_mode")

    local colors = {
        fg = "#E6B673",
        bg = "#1f2430",
    }

    local components = {
        active = {},
        inactive = {},
    }

    components.active[1] = {
        {
            -- provider = '▊ ',
            provider = " ",
            hl = {
                fg = "black",
            },
        },
        {
            provider = "vi_mode",
            icon = "",
            right_sep = " ",
            hl = function()
                return {
                    name = vi_mode_utils.get_mode_highlight_name(),
                    fg = vi_mode_utils.get_mode_color(),
                    style = "bold",
                }
            end,
        },
        {
            provider = "file_info",
            hl = {
                fg = "bg",
                bg = "fg",
                style = "bold",
            },
            left_sep = {
                "left_rounded",
                -- { str = ' ', hl = { bg = 'fg', fg = 'NONE' } },
            },
            right_sep = {
                { str = " ", hl = { bg = "fg", fg = "NONE" } },
                "right_rounded",
                " ",
            },
        },
        {
            provider = "file_size",
            right_sep = {
                " ",
                {
                    str = "slant_left_2_thin",
                    hl = {
                        fg = "fg",
                        bg = "bg",
                    },
                },
            },
        },
        {
            provider = "position",
            left_sep = " ",
            right_sep = {
                " ",
                {
                    str = "slant_right_2_thin",
                    hl = {
                        fg = "fg",
                        bg = "bg",
                    },
                },
            },
        },
        {
            provider = "diagnostic_errors",
            hl = { fg = "red" },
        },
        {
            provider = "diagnostic_warnings",
            hl = { fg = "yellow" },
        },
        {
            provider = "diagnostic_hints",
            hl = { fg = "cyan" },
        },
        {
            provider = "diagnostic_info",
            hl = { fg = "skyblue" },
        },
    }

    components.active[2] = {
        {
            provider = "git_branch",
            hl = {
                fg = "white",
                bg = "black",
                style = "bold",
            },
            right_sep = {
                str = " ",
                hl = {
                    fg = "NONE",
                    bg = "black",
                },
            },
        },
        {
            provider = "git_diff_added",
            hl = {
                fg = "green",
                bg = "black",
            },
        },
        {
            provider = "git_diff_changed",
            hl = {
                fg = "orange",
                bg = "black",
            },
        },
        {
            provider = "git_diff_removed",
            hl = {
                fg = "red",
                bg = "black",
            },
            right_sep = {
                str = " ",
                hl = {
                    fg = "NONE",
                    bg = "black",
                },
            },
        },
        {
            provider = "line_percentage",
            hl = {
                style = "bold",
            },
            left_sep = "  ",
            right_sep = " ",
        },
        {
            provider = "scroll_bar",
            hl = {
                fg = "fg",
                style = "bold",
            },
        },
    }

    components.inactive[1] = {
        {
            provider = "file_type",
            hl = {
                fg = "black",
                bg = "fg",
                style = "bold",
            },
            left_sep = {
                str = " ",
                hl = {
                    fg = "NONE",
                    bg = "fg",
                },
            },
            right_sep = {
                {
                    str = " ",
                    hl = {
                        fg = "NONE",
                        bg = "fg",
                    },
                },
                "slant_right",
            },
        },
        -- Empty component to fix the highlight till the end of the statusline
        {},
    }

    require("feline").setup({
        theme = colors,
        components = components,
        force_inactive = {
            filetypes = {
                "^NvimTree$",
            },
        },
    })
end

return M
