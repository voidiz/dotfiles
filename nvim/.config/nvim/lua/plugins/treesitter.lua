require'nvim-treesitter.configs'.setup {
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
        "scss",
        "tsx",
        "typescript",
        "vim",
        "yaml"
    },
    highlight = {
        enable = true
    },

    -- Auto-close and rename HTML tags
    autotag = {
        enable = true
    },

    -- Detect comment style at cursor
    context_commentstring = {
        enable = true
    },

    indent = {
        enable = true
    }
}
