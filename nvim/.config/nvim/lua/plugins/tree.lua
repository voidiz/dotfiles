return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        update_focused_file = {
            enable = true,
        },
    },
    config = function(_, opts)
        require("nvim-tree").setup(opts)
        vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", {})
    end,
}
