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
