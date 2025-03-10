return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "c",
                "cpp",
                "dockerfile",
                "python",
                "go",
                "json",
                "javascript",
                "gomod",
                "html",
                "latex",
                "lua",
                "luadoc",
                "make",
                "markdown",
                "php",
                "rust",
                "scss",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
            },
            highlight = {
                enable = true,
            },

            indent = {
                enable = true,
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
    },

    -- Auto close and rename HTML tags
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup({})
        end,
    },
}
