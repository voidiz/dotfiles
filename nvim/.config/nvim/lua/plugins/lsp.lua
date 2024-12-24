vim.diagnostic.config({
    update_in_insert = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
})

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- Mappings.
    local opts = { noremap = true, silent = true }
    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    -- buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    -- buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    -- buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    -- buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    buf_set_keymap("n", "[g", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]g", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
    -- buf_set_keymap("n", "<M-S-F>", "<cmd>lua vim.lsp.buf.format{ async = true }<CR>", opts)
    buf_set_keymap("x", "<leader>fo", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
end

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
            local capabilities =
                require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

            require("mason-lspconfig").setup({})
            require("mason-lspconfig").setup_handlers({
                -- Default handler
                function(server)
                    require("lspconfig")[server].setup({ on_attach = on_attach, capabilities = capabilities })
                end,
                ["rust_analyzer"] = function()
                    -- disable since we use rustaceanvim
                end,
                ["texlab"] = function()
                    require("lspconfig")["texlab"].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                        settings = {
                            texlab = {
                                build = {
                                    args = {
                                        "-pdf",
                                        "-interaction=nonstopmode",
                                        "-synctex=1",
                                        "--shell-escape",
                                        "%f",
                                    },
                                    onSave = true,
                                },
                                forwardSearch = {
                                    executable = "zathura",
                                    args = { "--synctex-forward", "%l:1:%f", "%p" },
                                },
                            },
                        },
                    })
                end,
            })
        end,
    },
    {
        -- Rust analyzer, debugger, inlay hints, etc. setup.
        -- Do not use rust-analyzer through mason.nvim with this.
        "mrcjkb/rustaceanvim",
        version = "^5", -- Recommended
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
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Project-local settings
            { "folke/neoconf.nvim", cmd = "Neoconf", opts = {} },
        },
        config = function()
            -- Add custom LSP configs (for LSP configs not in mason-lspconfig and nvim-lspconfig)
            local capabilities =
                require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
            require("lspconfig.configs").spicedb = require("plugins.custom_lsp.spicedb")
            require("lspconfig")["spicedb"].setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
        end,
    },
}
