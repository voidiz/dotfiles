return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<M-S-F>",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    opts = {
        -- Define your formatters
        formatters_by_ft = {
            lua = { "stylua" },
            nix = { "alejandra" },
            python = { "ruff_format" },
            javascript = { "oxfmt" },
            typescript = { "oxfmt" },
            javascriptreact = { "oxfmt" },
            typescriptreact = { "oxfmt" },
            css = { "oxfmt" },
            html = { "oxfmt" },
            json = { "oxfmt" },
            jsonc = { "oxfmt" },
            yaml = { "oxfmt" },
            markdown = { "oxfmt" },
            c = { "clang-format" },
            cpp = { "clang-format" },
        },
        -- Set up format-on-save
        -- format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
        -- Customize formatters
        formatters = {
            stylua = {
                prepend_args = { "--indent-type", "Spaces" },
            },
            ruff_format = {
                append_args = { "--line-length", "79" },
            },
        },
    },
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
