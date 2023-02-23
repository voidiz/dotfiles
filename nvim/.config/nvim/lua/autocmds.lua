local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local keymap_opts = { noremap = true, silent = true }

augroup("ft_python", { clear = true })
autocmd("Filetype", {
    group = "ft_python",
    pattern = { "python" },
    callback = function()
        vim.opt_local.textwidth = 79
        vim.opt_local.colorcolumn = "79"
        vim.keymap.set(
            "n",
            "<leader>ru",
            '<cmd>!for file in *.in; do echo "Input $file:"; python "%:p" < "$file"; echo -e; done<CR>',
            keymap_opts
        )
    end,
})

augroup("ft_asmgo", { clear = true })
autocmd("Filetype", {
    group = "ft_asmgo",
    pattern = { "asm", "go" },
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.softtabstop = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
    end,
})

augroup("ft_web", { clear = true })
autocmd("Filetype", {
    group = "ft_web",
    pattern = {
        "javascript",
        "html",
        "css",
        "htmldjango",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "json",
    },
    callback = function()
        vim.opt_local.softtabstop = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})

augroup("ft_c", { clear = true })
autocmd("Filetype", {
    group = "ft_c",
    pattern = { "c", "cpp" },
    callback = function()
        vim.opt_local.softtabstop = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.keymap.set(
            "n",
            "<leader>ru",
            '<cmd>!g++ -std=c++17 -g -O2 -Wall -pedantic %:p && for file in *.in; do echo "Input $file:"; ./a.out < "$file"; echo -e; done<CR>',
            keymap_opts
        )
    end,
})
