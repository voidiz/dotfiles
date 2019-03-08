local awful = require("awful")
local wibox = require("wibox")

local brightness_widget = wibox.widget{
    text = "50%",
    widget = wibox.widget.textbox
}

function brightness_widget.inc()
    awful.spawn("xbacklight -inc 1")
    brightness_widget.update_widget()
end

function brightness_widget.dec()
    awful.spawn("xbacklight -dec 1")
    brightness_widget.update_widget()
end

function brightness_widget.update_widget()
    awful.spawn.easy_async_with_shell("xbacklight -get", function(out)
        local value = math.floor(out + 0.5)
        brightness_widget.text = "bck " .. value .. "%"
    end)
end

brightness_widget.update_widget()

return brightness_widget
