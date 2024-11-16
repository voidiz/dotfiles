return {
    "nvim-tree/nvim-tree.lua",
    keys = {
        {
            "<C-n>",
            function()
                local api = require("nvim-tree.api")

                if api.tree.is_tree_buf(0) then
                    -- Close if current buffer is tree
                    api.tree.close()
                else
                    -- Otherwise open/focus
                    api.tree.open()
                end
            end,
            desc = "Toggle/Focus NvimTree",
        },
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
