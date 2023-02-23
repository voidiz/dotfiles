return {
    -- Various colorschemes
    "flazz/vim-colorschemes",
    "w0ng/vim-hybrid",
    {
        "ayu-theme/ayu-vim",
        priority = 1000,
        lazy = false,
        config = function()
            vim.cmd([[colorscheme ayu]])

            -- Colorscheme overrides
            -- Group names can be found with ':so $VIMRUNTIME/syntax/hitest.vim'
            vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
            vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })
            vim.api.nvim_set_hl(0, "LineNr", { fg = "#E6B673" })
            vim.api.nvim_set_hl(0, "Directory", { fg = "#E6B673" })
        end,
    },
    "sainnhe/sonokai",

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
