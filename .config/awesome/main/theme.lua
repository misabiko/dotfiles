
local gears = require("gears")

local beautiful = require("beautiful")

beautiful.init("/usr/share/awesome/themes/cesious/theme.lua")
beautiful.icon_theme        = "Papirus-Dark"
beautiful.bg_normal         = "#222D32"
beautiful.bg_focus          = "#2C3940"
beautiful.titlebar_close_button_normal = "/usr/share/awesome/themes/cesious/titlebar/close_normal_adapta.png"
beautiful.titlebar_close_button_focus = "/usr/share/awesome/themes/cesious/titlebar/close_focus_adapta.png"
beautiful.font              = "Noto Sans Regular 10"
beautiful.notification_font = "Noto Sans Bold 14"
beautiful.wallpaper = "usr/share/backgrounds/mikael-gustafsson-wallpaper-mikael-gustafsson.jpg"

local function set_wallpaper(s)
    -- wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- if wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
end)
