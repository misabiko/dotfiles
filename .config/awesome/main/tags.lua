local awful = require("awful")

local _M = {}

function _M.get ()
	local tags = {}

	awful.screen.connect_for_each_screen(function(s)
	    -- each screen has its own tag table.
	    local names = { "main", "www", "fd", "3", "4", "5" }
	    local l = awful.layout.suit    -- alias
		-- try creating filled array and change [1] to l.max
	    local layouts = { l.tile, l.max, l.floating, l.tile, l.tile, l.tile, l.tile, l.tile, l.tile }
	    tags = awful.tag(names, s, layouts)

	end)

	return tags
end

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
