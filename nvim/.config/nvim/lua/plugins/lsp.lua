vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
    },
})

local on_attach = function(client, bufnr)
    -- Mappings
    local opts = { noremap = true, silent = true, buffer = bufnr }
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

vim.lsp.config("*", {
    on_attach = on_attach,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

return {
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonLog", "MasonUninstall", "MasonUninstallAll" },
        opts = {},
    },
    {
        -- LSP server helpers
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                automatic_enable = {
                    -- rust_analyzer will be loaded by rustaceanvim
                    exclude = { "rust_analyzer" },
                },
            })
        end,
    },
    {
        -- Rust analyzer, debugger, inlay hints, etc. setup.
        "mrcjkb/rustaceanvim",
        version = "^6", -- Recommended
        lazy = false, -- This plugin is already lazy
        init = function()
            --- @type rustaceanvim.Opts
            vim.g.rustaceanvim = {
                server = {
                    on_attach = on_attach,
                },
            }
        end,
    },
    {
        -- Neovim lua autocompletion
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "snacks.nvim", words = { "Snacks" } },
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Project-local settings
            { "folke/neoconf.nvim", cmd = "Neoconf", opts = {} },
        },
    },
}
