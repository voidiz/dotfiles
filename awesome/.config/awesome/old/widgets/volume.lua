local awful = require("awful")
local wibox = require("wibox")

local volume_widget = wibox.widget{
    text = "50%",
    widget = wibox.widget.textbox
}

function volume_widget.inc()
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
    volume_widget.update_widget()
end

function volume_widget.dec()
    awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
    volume_widget.update_widget()
end

function volume_widget.mute()
    awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
    volume_widget.update_widget()
end

function volume_widget.update_widget()
    awful.spawn.easy_async_with_shell("pactl list sinks", function (out)
        local value = ""

        if (string.match(out, 'Mute: yes')) then
            value = "muted"
        else
            value = string.match(out, 'Volume: front%-left: %d+ %/%s+(%d+%%)')
        end

        volume_widget.text = "vol " .. value 
    end)
end

volume_widget.update_widget()

return volume_widget
