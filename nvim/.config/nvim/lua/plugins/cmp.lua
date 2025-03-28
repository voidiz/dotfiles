local M = {
    -- Auto completion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",

        -- Collection of snippets
        "rafamadriz/friendly-snippets",

        -- LuaSnip completion source for nvim-cmp
        "saadparwaiz1/cmp_luasnip",
    },
}

function M.config()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = {
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    -- Next completion item
                    cmp.select_next_item()
                elseif luasnip.jumpable(1) then
                    -- Jump to the next node
                    luasnip.jump(1)
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        },
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "vim-dadbod-completion" },
            {
                name = "lazydev",
                group_index = 0, -- to skip loading LuaLS completions
            },
        }, {
            { name = "buffer" },
        }),
        window = {
            completion = {
                border = "rounded",
            },
            documentation = {
                border = nil,
            },
        },
    })

    require("luasnip.loaders.from_vscode").lazy_load()
end

return M
