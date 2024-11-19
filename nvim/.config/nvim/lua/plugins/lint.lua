return {
    "mfussenegger/nvim-lint",
    config = function()
        local lint = require("lint")
        lint.linters_by_ft = {
            -- javascript = { "eslint_d" },
            -- typescript = { "eslint_d" },
            -- javascriptreact = { "eslint_d" },
            -- typescriptreact = { "eslint_d" },
            markdown = { "markdownlint" },
            -- python = { "ruff" }, -- ruff is an lsp, so not necessary
        }

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                -- Only lint normal buffers
                if vim.o.buftype == "" then
                    lint.try_lint()
                end
            end,
        })
    end,
}
