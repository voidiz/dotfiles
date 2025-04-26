local VIEW_WIDTH_FIXED = 30
local view_width_max = -1 -- Adaptive by default

local function get_view_width_max()
    return view_width_max
end

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
        {
            "<leader>tw",
            function()
                if view_width_max == -1 then
                    view_width_max = VIEW_WIDTH_FIXED
                else
                    view_width_max = -1
                end

                require("nvim-tree.api").tree.reload()
            end,
            desc = "Toggle Tree Adaptive Width",
        },
    },
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        update_focused_file = {
            enable = true,
        },
        view = {
            width = {
                min = 30,
                max = get_view_width_max,
            },
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
