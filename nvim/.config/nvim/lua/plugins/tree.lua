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

        -- Trigger LSP rename when renaming a file through nvim-tree.
        -- Requires snacks.nvim.
        local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
        local events = require("nvim-tree.api").events
        events.subscribe(events.Event.NodeRenamed, function(data)
            if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
                prev = data
                Snacks.rename.on_rename_file(data.old_name, data.new_name)
            end
        end)
    end,
}
