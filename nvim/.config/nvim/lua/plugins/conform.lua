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
            python = { "black" },
            javascript = { { "prettierd", "prettier" } },
            typescript = { { "prettierd", "prettier" } },
            javascriptreact = { { "prettierd", "prettier" } },
            typescriptreact = { { "prettierd", "prettier" } },
            css = { { "prettierd", "prettier" } },
            html = { { "prettierd", "prettier" } },
            json = { { "prettierd", "prettier" } },
            yaml = { { "prettierd", "prettier" } },
            markdown = { { "prettierd", "prettier" } },
            c = { "clang-format" },
            cpp = { "clang-format" }
        },
        -- Set up format-on-save
        -- format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
        -- Customize formatters
        formatters = {
            stylua = {
                prepend_args = { "--indent-type", "Spaces" },
            },
            black = {
                prepend_args = { "--line-length", "79" },
            },
        },
    },
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
