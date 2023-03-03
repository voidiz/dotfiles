return {
    -- Colorscheme
    {
        "rose-pine/neovim",
        priority = 1000,
        lazy = false,
        config = function()
            require("rose-pine").setup()
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

    -- Highlight colors
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({})
        end,
    },
}
