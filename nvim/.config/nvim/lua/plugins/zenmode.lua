return {
    "folke/zen-mode.nvim",
    opts = {
        on_open = function()
            vim.api.nvim_set_hl(0, "ZenBg", { ctermbg = 0 })
        end,
    },
}
