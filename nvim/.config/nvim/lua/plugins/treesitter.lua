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
                "make",
                "php",
                "rust",
                "scss",
                "tsx",
                "typescript",
                "vim",
                "yaml",
            },
            highlight = {
                enable = true,
            },

            -- Auto-close and rename HTML tags
            autotag = {
                enable = true,
            },

            -- Detect comment style at cursor
            context_commentstring = {
                enable = true,
            },

            indent = {
                enable = true,
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    -- Auto close and rename HTML tags
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup({})
        end,
    },
}
