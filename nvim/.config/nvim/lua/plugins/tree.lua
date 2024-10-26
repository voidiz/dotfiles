return {
    "nvim-tree/nvim-tree.lua",
    keys = {
        { "<C-n>", "<cmd>NvimTreeToggle<CR>" },
    },
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
    end,
}
