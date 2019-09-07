-- Standard awesome library
local gears = require("gears")
awful = require("awful")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")
local menubar = require("menubar")
-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")

RC = {}
RC.vars = require("main.user-variables")

modkey = RC.vars.modkey

require("main.error-handling")

require("main.theme")

RC.layouts = require("main.layouts")
RC.tags = require("main.tags")

-- {{{ menu
RC.mainmenu = require("main.menu")

RC.launcher = awful.widget.launcher(
	{ image = beautiful.awesome_icon, menu = RC.mainmenu }
)

-- menubar configuration
menubar.utils.terminal = RC.vars.terminal -- set the terminal for applications that require it
-- }}}

require("main.wibar")

require("binding.globalbuttons")

require("binding.globalkeys")

require("main.rules")

require("main.signals")

awful.spawn.with_shell("~/.config/awesome/autorun.sh")
