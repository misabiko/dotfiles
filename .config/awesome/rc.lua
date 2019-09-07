-- Standard awesome library
local gears = require("gears")
awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Freedesktop menu
local freedesktop = require("freedesktop")
-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")

local switcher = require("awesome-switcher")
local keyboard_layout = require("keyboard_layout")

RC = {}
RC.vars = require("main.user-variables")

modkey = RC.vars.modkey

require("main.error-handling")

require("main.theme")

local main = {
	layouts = require("main.layouts"),
	tags	= require("main.tags"),
	menu	= require("main.menu"),
	rules	= require("main.rules")
}

RC.layouts = main.layouts()
RC.tags = main.tags()

-- {{{ menu
RC.mainmenu = main.menu()

RC.launcher = awful.widget.launcher(
	{ image = beautiful.awesome_icon, menu = RC.mainmenu }
)

-- menubar configuration
menubar.utils.terminal = RC.vars.terminal -- set the terminal for applications that require it
-- }}}

-- {{{ wibar
-- create a textclock widget
mytextclock = wibox.widget.textclock("%a %Y/%m/%d %I:%M %p ")

-- keyboard map indicator and switcher
local kbdcfg = keyboard_layout.kbdcfg({cmd = "fcitx-remote -s", type = "tui"})

kbdcfg.add_primary_layout("English", "EN", "fcitx-keyboard-ca-multix")
kbdcfg.add_primary_layout("Japanese", "JP", "mozc")
kbdcfg.bind()

local binding = {
	globalbuttons = require("binding.globalbuttons"),
	globalkeys = require("binding.globalkeys"),
	clientkeys = require("binding.clientkeys"),
	clientbuttons = require("binding.clientbuttons"),
	taglistbuttons = require("binding.taglistbuttons"),
	tasklistbuttons = require("binding.tasklistbuttons")
}

kbdcfg.widget:buttons(
    awful.util.table.join(awful.button({ }, 1, function () kbdcfg.switch_next() end),
                          awful.button({ }, 3, function () kbdcfg.menu:toggle() end))
)

darkblue    = beautiful.bg_focus
blue        = "#9ebaba"
red         = "#eb8f8f"
separator = wibox.widget.textbox(' <span color="' .. blue .. '">| </span>')
spacer = wibox.widget.textbox(' <span color="' .. blue .. '"> </span>')

awful.screen.connect_for_each_screen(function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, binding.taglistbuttons())

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, binding.tasklistbuttons())

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            RC.launcher,
            s.mytaglist,
            s.mypromptbox,
            separator,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
--            mykeyboardlayout,
            kbdcfg.widget,
            separator,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

root.buttons(binding.globalbuttons())

root.keys(binding.globalkeys())

awful.rules.rules = main.rules(
	binding.clientkeys(),
	binding.clientbuttons()
)

require("main.signals")

awful.spawn.with_shell("~/.config/awesome/autorun.sh")
