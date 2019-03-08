local awful = require("awful")
local wibox = require("wibox")

local update_interval = 30

local GET_BAT_CMD = "cat /sys/class/power_supply/BAT0/capacity"

local battery_widget = wibox.widget{
    text = '50%',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local function update_widget(bat_value)
    battery_widget.text = "bat " .. bat_value .. "%"
end

awful.widget.watch(GET_BAT_CMD, update_interval, function(widget, stdout)
    -- Trim whitespace
    local value = string.gsub(stdout, '^%s*(.-)%s*$', '%1')
    update_widget(value)
end)

return battery_widget
