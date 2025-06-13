local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

-- Recreate wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) but
-- with M.switch_workspace to store the previous workspace when switching.
M.workspace_picker = function(window, pane)
    local entries = {}
    for _, workspace in ipairs(wezterm.mux.get_workspace_names()) do
        if workspace ~= window:active_workspace() then
            table.insert(entries, {
                id = workspace,
                label = string.format("Switch to workspace `%s`", workspace),
            })
        end
    end

    window:perform_action(
        act.InputSelector({
            action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
                if not id and not label then
                    return
                end

                M.switch_workspace(inner_window, inner_pane, id)
            end),
            title = "Choose Workspace",
            choices = entries,
            fuzzy = true,
            fuzzy_description = "Fuzzy matching: ",
        }),
        pane
    )
end

-- Switch workspace and save the previous workspace.
M.switch_workspace = function(window, pane, workspace)
    local current_workspace = window:active_workspace()
    -- workspace will be `nil` if we hit escape without entering anything, an
    -- empty string if we just hit enter, or the actual line of text we wrote
    if current_workspace == workspace or not workspace then
        return
    end

    window:perform_action(
        act.SwitchToWorkspace({
            name = workspace,
        }),
        pane
    )
    wezterm.GLOBAL.previous_workspace = current_workspace
end

-- Switch to the previous workspace (stored by M.switch_workspace).
M.switch_to_previous_workspace = function(window, pane)
    local current_workspace = window:active_workspace()
    local workspace = wezterm.GLOBAL.previous_workspace

    if current_workspace == workspace or wezterm.GLOBAL.previous_workspace == nil then
        return
    end

    M.switch_workspace(window, pane, workspace)
end

return M
