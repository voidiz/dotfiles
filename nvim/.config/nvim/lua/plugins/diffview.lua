return {
    "sindrets/diffview.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    cmd = {
        "DiffviewOpen",
        "DiffviewClose",
        "DiffviewToggleFiles",
        "DiffviewFocusFiles",
        "DiffviewRefresh",
        "DiffviewFileHistory",
    },
    keys = {
        {
            "<leader>gd",
            "<cmd>DiffviewOpen origin/HEAD...HEAD --imply-local<CR>",
            desc = "View diff against merge base",
        },
    },
    opts = {},
}
