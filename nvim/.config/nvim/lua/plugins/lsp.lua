-- Setup statusline with labels
local kind_labels_mt = {
    __index = function(_, k)
        return k
    end,
}
local kind_labels = {}
setmetatable(kind_labels, kind_labels_mt)

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- Mappings.
    local opts = { noremap = true, silent = true }
    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    buf_set_keymap("n", "[g", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]g", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
    buf_set_keymap("n", "<M-S-F>", "<cmd>lua vim.lsp.buf.format{ async = true }<CR>", opts)
    buf_set_keymap("x", "<leader>fo", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)

    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.document_highlight then
        vim.api.nvim_exec(
            [[
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
            ]],
            false
        )
    end
end

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Rust analyzer, debugger, inlay hints, etc. setup
        "simrat39/rust-tools.nvim",
        {
            -- Neovim lua autocompletion
            "folke/neodev.nvim",
            config = function()
                require("neodev").setup({})
            end,
        },
        {
            -- Handle LSP servers, linters, formatters, debuggers
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup({})
            end,
            dependencies = {
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
                            require("rust-tools").setup({
                                server = {
                                    on_attach = on_attach,
                                    capabilities = capabilities,
                                },
                            })
                        end,
                        ["texlab"] = function()
                            require("lspconfig")["texlab"].setup({
                                on_attach = on_attach,
                                capabilities = capabilities,
                                settings = {
                                    texlab = {
                                        build = {
                                            args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '--shell-escape', '%f' },
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
        },
        {
            -- LSP server for formatters, etc.
            "jose-elias-alvarez/null-ls.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function()
                local null_ls = require("null-ls")
                null_ls.setup({
                    on_attach = on_attach,
                    sources = {
                        null_ls.builtins.formatting.prettierd,
                        null_ls.builtins.formatting.black.with({
                            extra_args = { "--line-length", "79" },
                        }),
                        null_ls.builtins.formatting.stylua.with({ extra_args = { "--indent-type", "Spaces" } }),
                    },
                })
            end,
        },
    },
}
