local awful = require("awful")
local gears = require("gears")
local sharedtags = require("awesome-sharedtags")

local l = awful.layout.suit    -- alias
local tags = sharedtags({
	{name = "main1", screen = 1, layout = l.tile},
	{name = "www1", screen = 1, layout = l.fair},
	{name = "main2", screen = 2, layout = l.tile},
	{name = "www2", screen = 2, layout = l.fair},
	{name = "main3", screen = 3, layout = l.tile},
	{name = "www3", screen = 3, layout = l.fair},
	{name = "ide", layout = l.max},
	{name = "fd", layout = l.floating}
})

awful.screen.connect_for_each_screen(function(s)
    -- Here is a good place to add tags to a newly connected screen, if desired:
    sharedtags.viewonly(tags["ide"], s)
    sharedtags.viewonly(tags["fd"], s)
end)

return tags
