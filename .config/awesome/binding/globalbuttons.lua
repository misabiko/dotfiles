local awful = require("awful")
local gears = require("gears")

local _M = {}

function _M.get()
	return gears.table.join(
		awful.button({ }, 1, function () RC.mainmenu:hide() end),
	    awful.button({ }, 3, function () RC.mainmenu:toggle() end),
	    awful.button({ }, 4, awful.tag.viewnext),
	    awful.button({ }, 5, awful.tag.viewprev)
	)
end

return setmetatable({}, {__call = function(_, ...) return _M.get(...) end})
