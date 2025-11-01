return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        branch = "main",
        event = "BufRead",
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
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
    },

    -- Auto close and rename HTML tags
    {
        "windwp/nvim-ts-autotag",
        event = "BufRead",
        config = function()
            require("nvim-ts-autotag").setup({})
        end,
    },

    -- Show current context at the top of the buffer (e.g., which function or
    -- which json key the cursor is in)
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "FileType",
        main = "treesitter-context",

        opts = {
            max_lines = 3,
            on_attach = function(buf)
                local current_filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
                local allowed_filetypes = {
                    "yaml",
                    "json",
                }

                if vim.tbl_contains(allowed_filetypes, current_filetype) then
                    -- Jump to start of context
                    vim.keymap.set("n", "[c", function()
                        require("treesitter-context").go_to_context(vim.v.count1)
                    end, { silent = true, desc = "Jump to Start of Tree-sitter Context" })

                    return true
                end

                return false
            end,
        },
    },
}
