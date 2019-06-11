local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local alttab = {}

alttab.popup = awful.popup {
    widget = awful.widget.tasklist {
        screen   = screen[1],
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        style    = {
            shape = gears.shape.rounded_rect,
        },
        layout   = {
            spacing = 5,
            forced_num_rows = 2,
            layout = wibox.layout.grid.horizontal
        },
        widget_template = {
            {
                {
                    id     = 'clienticon',
                    widget = awful.widget.clienticon,
                },
                margins = 4,
                widget  = wibox.container.margin,
            },
            id              = 'background_role',
            forced_width    = 48,
            forced_height   = 48,
            widget          = wibox.container.background,
            create_callback = function(self, c, index, objects) --luacheck: no unused
                self:get_children_by_id('clienticon')[1].client = c
            end,
        },
    },
    border_color = '#777777',
    border_width = 2,
    ontop        = true,
    placement    = awful.placement.centered,
    shape        = gears.shape.rounded_rect
}

local timer = gears.timer({
	timeout = 1,
	callback = function() alttab.popup.visible = false end
})

function alttab.show_popup()
	alttab.popup.visible = true
	timer:again()
end

return alttab
