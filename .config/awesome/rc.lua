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

local config_path = awful.util.getdir("config") .. "/"

require("main.error-handling")

require("main.theme")

local main = {
	layouts = require("main.layouts"),
	tags	= require("main.tags"),
	menu	= require("main.menu")
}

RC.layouts = main.layouts()
RC.tags = main.tags()

-- {{{ helper functions
local function client_menu_toggle_fn()
    local instance = nil
    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}


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
--mykeyboardlayout = awful.widget.keyboardlayout()

local kbdcfg = keyboard_layout.kbdcfg({cmd = "fcitx-remote -s", type = "tui"})

kbdcfg.add_primary_layout("English", "EN", "fcitx-keyboard-ca-multix")
kbdcfg.add_primary_layout("Japanese", "JP", "mozc")
kbdcfg.bind()

local binding = {
	globalbuttons = require("binding.globalbuttons"),
	globalkeys = require("binding.globalkeys"),
	clientkeys = require("binding.clientkeys"),
	clientbuttons = require("binding.clientbuttons"),
	taglistbuttons = require("binding.taglistbuttons")
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


local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- this will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

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
    -- wallpaper
    set_wallpaper(s)

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
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

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

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = binding.clientkeys(),
                     buttons = binding.clientbuttons(),
                     size_hints_honor = false, -- Remove gaps between terminals
                     screen = awful.screen.preferred,
                     callback = awful.client.setslave,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    --{ rule_any = {type = { "normal", "dialog" } },
    --  properties = { titlebars_enabled = true }
    --},

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },

    { rule = { tag = "fd" }, properties = { titlebars_enabled = true } }
}
-- }}}

-- {{{ Signals


-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.stickybutton   (c),
           -- awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
        -- Hide the menubar if we are not floating
   -- local l = awful.layout.get(c.screen)
   -- if not (l.name == "floating" or c.floating) then
   --     awful.titlebar.hide(c)
   -- end
end)

-- Enable sloppy focus, so that focus follows mouse.
--[[
    client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)
--]]

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Disable borders on lone windows
-- Handle border sizes of clients.
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
  local clients = awful.client.visible(s)
  local layout = awful.layout.getname(awful.layout.get(s))

  for _, c in pairs(clients) do
    -- No borders with only one humanly visible client
    if c.maximized then
      -- NOTE: also handled in focus, but that does not cover maximizing from a
      -- tiled state (when the client had focus).
      c.border_width = 0
    elseif c.floating or layout == "floating" then
      c.border_width = beautiful.border_width
    elseif layout == "max" or layout == "fullscreen" then
      c.border_width = 0
    else
      local tiled = awful.client.tiled(c.screen)
      if #tiled == 1 then -- and c == tiled[1] then
        tiled[1].border_width = 0
        -- if layout ~= "max" and layout ~= "fullscreen" then
        -- XXX: SLOW!
        -- awful.client.moveresize(0, 0, 2, 0, tiled[1])
        -- end
      else
        c.border_width = beautiful.border_width
      end
    end
  end
end)
end

-- }}}

--client.connect_signal("property::floating", function (c)
--    if c.floating then
--        awful.titlebar.show(c)
--    else
--        awful.titlebar.hide(c)
--    end
--end)

awful.spawn.with_shell("~/.config/awesome/autorun.sh")
