local awful = require("awful")
local gears = require("gears")

local _M = {}

function _M.get()
	return gears.table.join(
	    awful.button({ }, 1, function (c) client.focus = c; c:raise()
	                 RC.mainmenu:hide() end),
	    awful.button({ modkey }, 1, awful.mouse.client.move),
	    awful.button({ modkey }, 3, awful.mouse.client.resize)
	)
end

return setmetatable({}, {__call = function(_, ...) return _M.get(...) end})
