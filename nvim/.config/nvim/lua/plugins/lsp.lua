vim.lsp.enable("clangd")
vim.lsp.enable("gopls")
vim.lsp.enable("nixd")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("vtsls")
vim.lsp.enable("lua_ls")

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
