--- Modify a highlight group by merging new options into the existing definition.
--- @param group string                     Name of the highlight group (e.g., "DiffAdd")
--- @param opts vim.api.keyset.highlight    Table of highlight options to override (e.g., { fg = "#ff0000" })
local function merge_hl(group, opts)
    local current = vim.api.nvim_get_hl(0, { name = group })
    vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", current, opts))
end

return {
    -- Colorscheme
    {
        "rose-pine/neovim",
        priority = 1000,
        lazy = false,
        config = function()
            require("rose-pine").setup({
                variant = "auto",
                dark_variant = "moon",
                highlight_groups = {
                    StatusLine = { fg = "love", bg = "love", blend = 10 },
                    StatusLineNC = { fg = "subtle", bg = "surface" },
                },
            })
            vim.cmd([[colorscheme rose-pine]])

            -- Override diffview colors (use :Inspect and :filter /Diffview/
            -- highlight to find the highlight groups)
            merge_hl("DiffviewDiffDelete", { fg = "#2d2b47" })
            merge_hl("DiffviewFilePanelDeletions", { fg = "#872944", bg = "NONE" })
            merge_hl("DiffviewFilePanelInsertions", { fg = "#58bea3", bg = "NONE" })
            merge_hl("DiffviewStatusModified", { fg = "#8cbac3", bg = "NONE" })
            merge_hl("DiffviewStatusAdded", { fg = "#8cbac3", bg = "NONE" })
            merge_hl("DiffviewStatusBroken", { fg = "#872944", bg = "NONE" })
            merge_hl("DiffviewStatusDeleted", { fg = "#872944", bg = "NONE" })
            merge_hl("DiffviewStatusUnknown", { fg = "#872944", bg = "NONE" })
        end,
    },

    -- Emmet
    "mattn/emmet-vim",

    -- Commenting
    "tpope/vim-commentary",

    -- Change surrounding symbols
    "tpope/vim-surround",

    -- Detect indentation
    "tpope/vim-sleuth",

    -- Git stuff
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",
}
