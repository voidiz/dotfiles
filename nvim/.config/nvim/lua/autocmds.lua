local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local keymap_opts = { noremap = true, silent = true }

---@param buffer integer
local set_keymaps = function(buffer)
    -- Mappings
    local opts = { noremap = true, silent = true, buffer = buffer }
    vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.keymap.set("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    vim.keymap.set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    vim.keymap.set("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    vim.keymap.set("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    vim.keymap.set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    vim.keymap.set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    vim.keymap.set("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    vim.keymap.set("n", "[g", "<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>", opts)
    vim.keymap.set("n", "]g", "<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>", opts)
    vim.keymap.set("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
    vim.keymap.set("x", "<leader>fo", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)

    -- Replaced by glance
    -- vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    -- vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    -- vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)

    -- Replaced by conform
    -- vim.keymap.set("n", "<M-S-F>", "<cmd>lua vim.lsp.buf.format{ async = true }<CR>", opts)
end

augroup("lsp", { clear = true })
autocmd("LspAttach", {
    group = "lsp",
    callback = function(ev)
        set_keymaps(ev.buf)

        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        assert(client ~= nil)
        client.server_capabilities =
            vim.tbl_deep_extend("force", client.server_capabilities, require("cmp_nvim_lsp").default_capabilities())
    end,
})

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

augroup("ft_docs", { clear = true })
autocmd("Filetype", {
    group = "ft_docs",
    pattern = { "tex", "latex", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
    end,
})
