local awful = require("awful")

local tags = {}

awful.screen.connect_for_each_screen(function(s)
    -- each screen has its own tag table.
    local names = { "main", "www", "fd", "3", "4", "5" }
    local l = awful.layout.suit    -- alias
	-- try creating filled array and change [1] to l.max
    local layouts = { l.tile, l.max, l.floating, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile }
    tags = awful.tag(names, s, layouts)

	tags[2].selected = true
end)

return tags
