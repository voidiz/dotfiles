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
    ---@type nvim_tree.config
    opts = {
        -- Used for workspaces.lua logic where we switch between sessions and
        -- therefore working directories. Not using this flag means that
        -- nvim-tree falls out of sync with the session cwd.
        sync_root_with_cwd = true,
        update_focused_file = {
            enable = true,
        },
        view = {
            width = {
                min = 30,
                max = get_view_width_max,
            },
        },
        filters = {
            git_ignored = false,
        },
        experimental = {
            -- TODO: Uncomment and remove restore call in workspaces.lua
            -- when updated to nvim 0.13.
            --
            -- nvim-tree buffers are not restored correctly when switching
            -- between sessions. This is an experimental workaround for it.
            -- session_restore_nvim = true,
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
