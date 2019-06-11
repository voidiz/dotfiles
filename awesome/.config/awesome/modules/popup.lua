local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local popup = {}
local module_dir = os.getenv("HOME") .. "/.config/awesome/modules/"

popup.colors = beautiful.xresources.get_current_theme()
popup.icons = {
    ["vol"] = module_dir .. "icons/speaker.png",
    ["muted"] = module_dir .. "icons/speaker_muted.png",
    ["bl"] = module_dir .. "icons/brightness.png",
}

popup.text = wibox.widget{
    markup = "Placeholder",
    align = "center",
    valign = "center",
    font = "SF Pro Text 12",
    widget = wibox.widget.textbox,
}

popup.icon = wibox.widget({
    widget = wibox.widget.imagebox,
    forced_width = 120,
    image = popup.icons.vol
})

popup.bar = wibox.widget{
    max_value = 1, value = 0,
    forced_height = 10, forced_width = 140, border_width = 0,
    color = popup.colors.color3,
    background_color = "#383838",
    widget = wibox.widget.progressbar,
}

popup.layout = wibox.widget({
	wibox.container.margin(popup.text, 5, 5, 10, 5),
	wibox.container.margin(popup.icon, 40, 40),
	wibox.container.margin(popup.bar, 5, 5, 5, 10),
	layout = wibox.layout.align.vertical,
    forced_height = 200, forced_width = 200,
    expand = "none",
})

popup.wibox = awful.popup({
	placement = awful.placement.centered,
    shape = gears.shape.rounded_rect,
	ontop = true,
	visible = false,
	widget = popup.layout,
    bg = popup.colors.background,
})

local timer = gears.timer({
	timeout = 1,
	callback = function() popup.wibox.visible = false end
})

local show_wibox = function()
	popup.wibox.visible = true
	timer:again()
end

function popup.update_vol()
    awful.spawn.easy_async_with_shell("amixer get Master", function(o) 
        -- Check muted status
        if string.match(o, '%[off%]') == nil then
            popup.text.text = "Volume"
            popup.icon.image = popup.icons.vol
        else
            popup.text.text = "Muted"
            popup.icon.image = popup.icons.muted
        end

        -- Update bar and show wibox
        popup.bar:set_value(tonumber(string.match(o, '%[(%d+)%%%]'))/100)
        show_wibox()
    end)
end 

function popup.update_bl()
    awful.spawn.easy_async_with_shell("xbacklight", function(o)
        -- Update bar and show wibox
        popup.text.text = "Brightness"
        popup.icon.image = popup.icons.bl
        popup.bar:set_value(tonumber(o)/100)
        show_wibox()
    end)
end

return popup
