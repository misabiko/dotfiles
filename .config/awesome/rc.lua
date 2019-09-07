-- Standard awesome library
local gears = require("gears")
awful = require("awful")
require("awful.autofocus")
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

local binding = {
	globalbuttons = require("binding.globalbuttons"),
	globalkeys = require("binding.globalkeys"),
	clientkeys = require("binding.clientkeys"),
	clientbuttons = require("binding.clientbuttons"),
	taglistbuttons = require("binding.taglistbuttons"),
	tasklistbuttons = require("binding.tasklistbuttons")
}

require("main.wibar")

root.buttons(binding.globalbuttons())

root.keys(binding.globalkeys())

awful.rules.rules = main.rules(
	binding.clientkeys(),
	binding.clientbuttons()
)

require("main.signals")

awful.spawn.with_shell("~/.config/awesome/autorun.sh")
