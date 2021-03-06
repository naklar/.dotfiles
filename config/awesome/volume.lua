local wibox = require("wibox")
local awful = require("awful")
local helpers = require("./helpers")

local widget = {}

-- {{{ Define subwidgets
widget.text = wibox.widget.textbox()
widget.icon = wibox.widget.imagebox()

-- Change the draw method so icons can be drawn smaller
helpers:set_draw_method(widget.icon)
-- }}}

-- {{{ Define interactive behaviour
widget.icon:buttons(awful.util.table.join(
--    awful.button({ }, 1, function () awful.util.spawn("gnome-control-center sound") end)
))
-- }}}

-- {{{ Update method
function widget:update()
    local fd = io.popen("amixer sget Master")
    local status = fd:read("*all")
    fd:close()
 
    local volume = tonumber(string.match(status, "(%d?%d?%d)%%")) or 0
    widget.text:set_markup(volume .. "%")
    print(status)

    local iconpath = "/home/mrzapp/.config/awesome/themes/current/icons/gnome/scalable/status/audio-volume" 

    if string.find(status, "[off]", 1, true) or volume <= 0.0 then
        iconpath = iconpath .. "-muted"

    elseif volume < 25 then
        iconpath = iconpath .. "-low"
    
    elseif volume > 75 then
        iconpath = iconpath .. "-high"

    else
        iconpath = iconpath .. "-medium"

    end

    iconpath = iconpath .. "-symbolic.svg"
    
    widget.icon:set_image(iconpath)

end
-- }}}

-- {{{ Listen
helpers:listen(widget)
-- }}}

return widget
