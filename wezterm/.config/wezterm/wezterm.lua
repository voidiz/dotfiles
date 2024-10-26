local wezterm = require("wezterm")
local act = wezterm.action
local local_config_set, local_config = pcall(require, "wezterm_local")

local config = wezterm.config_builder()
config:set_strict_mode(true)

--- General
config.audible_bell = "Disabled"
config.front_end = "WebGpu"

--- Appearance
local theme = wezterm.plugin.require("https://github.com/neapsix/wezterm").moon
config.line_height = 1.2
config.colors = theme.colors()
config.window_frame = theme.window_frame()
config.window_frame.font = wezterm.font({ family = "Roboto Mono" })
config.window_decorations = "RESIZE"
config.window_padding = {
    left = 20,
    right = 20,
    top = 20,
    bottom = 20,
}

-- Show workspace in right status
wezterm.on("update-right-status", function(window, pane)
    local workspace = window:active_workspace()
    window:set_right_status(string.format("%s ", workspace))
end)

--- Keybindings
config.keys = {
    {
        key = "j",
        mods = "ALT",
        action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
        key = "h",
        mods = "ALT",
        action = act.ActivateTabRelative(-1),
    },
    {
        key = "l",
        mods = "ALT",
        action = act.ActivateTabRelative(1),
    },
    {
        key = "h",
        mods = "SHIFT|ALT",
        action = act.MoveTabRelative(-1),
    },
    {
        key = "l",
        mods = "SHIFT|ALT",
        action = act.MoveTabRelative(1),
    },
    {
        key = "N",
        mods = "CTRL|SHIFT",
        action = act.PromptInputLine({
            description = wezterm.format({
                { Attribute = { Intensity = "Bold" } },
                { Foreground = { AnsiColor = "Fuchsia" } },
                { Text = "Enter name for new workspace" },
            }),
            action = wezterm.action_callback(function(window, pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:perform_action(
                        act.SwitchToWorkspace({
                            name = line,
                        }),
                        pane
                    )
                end
            end),
        }),
    },
    {
        key = "O",
        mods = "CTRL|SHIFT",
        action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
    },
}

-- ALT + number to activate that tab
for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = "ALT",
        action = act.ActivateTab(i - 1),
    })
end

if local_config_set then
    local_config.apply_to_config(config)
end

return config
