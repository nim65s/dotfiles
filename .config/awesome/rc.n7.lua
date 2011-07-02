require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")
require("teardrop")
require("vicious")

beautiful.init("/home/saurelg/.config/awesome/awesome.zenburn.nimed.theme.lua")

terminal = "terminator"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.floating,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}

-- {{{ Tags
tags = {}
tags[1] = awful.tag({ "1:zik", "2:www", "3:vim", 4, 5, 6, 7, 8, 9}, 1, { layouts[1], layouts[1], layouts[2], layouts[1], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2]})
awful.tag.setmwfact(0.3,tags[1][2])
awful.tag.setmwfact(0.25,tags[1][4])
-- awful.tag.seticon("/home/nim/images/icones/32.ff.png", tags[1][2])
-- awful.tag.seticon("/home/nim/images/icones/32.tb.png", tags[1][3])
-- awful.tag.seticon("/home/nim/images/icones/32.am.png", tags[1][9])
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", function () awful.util.spawn_with_shell("terminator -e 'vim $XDG_CONFIG_HOME/awesome/rc.lua; awesome -k; read -n 1'", 2) end },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox

function wiboxtoggle()
		if mywibox[1].visible then
				mywibox[1].visible = false
				mywibox[2].visible = false
				mywibox[3].visible = false
		else
				mywibox[1].visible = true
				mywibox[2].visible = true
				mywibox[3].visible = true
		end
end

gmailicone = widget({ type = "imagebox" })
gmailicone.image = image(beautiful.gmail_icon)
gmailicone:buttons(awful.button({ }, 1, function () 
	awful.util.spawn_with_shell("chromium https://mail.google.com") 
	awful.tag.viewonly(tags[1][1])
end ))

function bg(color, text)
    return '<bg color="' .. color .. '" />' .. text
end
function fg(color, text)
    return '<span color="' .. color .. '">' .. text .. '</span>'
end
function bold(text)
    return '<b>' .. text .. '</b>'
end
function italic(text)
    return '<i>' .. text .. '</i>'
end

mygmail = widget({ type = "textbox" })
mygmail:buttons(awful.button({ }, 1, function () 
	awful.util.spawn_with_shell("chromium https://mail.google.com") 
	awful.tag.viewonly(tags[1][1])
end ))
mygmail_timer = timer({ timeout = 301 })
mygmail_timer:add_signal("timeout", function () mygmail.text = io.popen("grep -q mail.google.com $HOME/.netrc && curl --connect-timeout 1 -m 3 -fsn https://mail.google.com/mail/feed/atom/unread | grep fullcount | sed 's/<[/]*fullcount>//g' || echo 'netrc'", "r"):read("*a") end)
mygmail_timer:start()
mygmail_timer:emit_signal("timeout")
mygmail:add_signal("mouse::enter", function () naughty.notify({ icon = image(beautiful.gmail_icon), title = "    Gmail :", text = io.popen("grep -q mail.google.com $HOME/.netrc && curl --connect-timeout 1 -m 3 -fsn https://mail.google.com/mail/feed/atom/unread | egrep 'title|summary' | sed '1d;s/title/b/g;s/<[/]*summary>//g' || echo 'votre fichier $HOME/.netrc ne contient pas d informations à propos de la machine mail.google.com'","r"):read("*a") }) end)

calendar = {
    offset = 0,
    font = "monospace"
}

function calendar:month(month_offset)
    local save_offset = self.offset
    self:remove()
    self.offset = save_offset + month_offset
    local datespec = os.date("*t")
    datespec = datespec.year * 12 + datespec.month - 1 + self.offset
    datespec = (datespec % 12 + 1) .. " " .. math.floor(datespec / 12)
    local cal = awful.util.pread("cal " .. datespec)
    if self.offset == 0 then -- this month, hilight day and month
        cal = string.gsub(cal, "%s" .. tonumber(os.date("%d")) .. "%s", bold("%1"))
        cal = string.gsub(cal, "^(%s*%w+%s+%d+)", bold("%1"))
    end
    self.display = naughty.notify {
        opacity = use_composite and beautiful.opacity.naughty or 1,
        text = string.format('<span font_desc="%s">%s</span>', self.font, cal),
        timeout = 0,
        hover_timeout = 0.5,
        margin = 10,
    }
end

function calendar:remove()
    if self.display ~= nil then
        naughty.destroy(self.display)
        self.display = nil
        self.offset = 0
    end
end
-- }}}

wiclock = awful.widget.textclock({ align = "right" }, "%T - %d/%m ", 1)
wiclock:add_signal("mouse::enter", function() calendar:month(0) end)
wiclock:add_signal("mouse::leave", function() calendar:remove() end)
wiclock:buttons(awful.util.table.join(
    awful.button({ }, 1, function() awful.util.spawn_with_shell("/home/saurelg/scripts/edt.sh notify") end),
    awful.button({ }, 5, function() calendar:month(-1) end),
    awful.button({ }, 4, function() calendar:month(1) end)))

mysystray = widget({ type = "systray" })
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags())
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

-- Create the wibox
mywibox[1] = awful.wibox({ position = "top", screen = 1 })
for s = 1, screen.count() do
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)
	end
mywibox[1].widgets = {
        {
            mytaglist[1],
            mypromptbox[1],
            layout = awful.widget.layout.horizontal.leftright
        },
        wiclock,
		gmailicone,
		mygmail,
        mylayoutbox[1],
        mysystray[1],
        mytasklist,
        layout = awful.widget.layout.horizontal.rightleft
    }
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey, "Shift"   }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal)   end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    awful.key({ modkey,           }, "q",     function() awful.util.spawn("xscreensaver-command -lock") end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
	awful.key({ modkey,           }, "b",     function () wiboxtoggle()                    end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey },            "v",     function () teardrop("terminator", "bottom", "center", 1, 0.2, true) end),

    awful.key({ modkey }, "w",
              function ()
                  awful.prompt.run({ prompt = "Wikipedia: " },
                  mypromptbox[mouse.screen].widget,
                  function (command)
                      awful.util.spawn_with_shell("chromium http://wikipedia.fr/Resultats.php?q=$(echo '"..command.."' | sed 's/ /+/g')", false)
                      awful.tag.viewonly(tags[1][1])
                      end)
              end),

    awful.key({ modkey }, "a",
              function ()
                  awful.prompt.run({ prompt = "Archlinux: " },
                  mypromptbox[mouse.screen].widget,
                  function (command)
                      awful.util.spawn_with_shell("chromium https://wiki.archlinux.org/index.php?search="..command, false)
                      awful.tag.viewonly(tags[1][1])
                      end)
              end),

    awful.key({ modkey, "Shift" }, "a",
              function ()
                  awful.prompt.run({ prompt = "ArchlinuxFr: " },
                  mypromptbox[mouse.screen].widget,
                  function (command)
                      awful.util.spawn_with_shell("chromium http://wiki.archlinux.fr/index.php?search="..command, false)
                      awful.tag.viewonly(tags[1][1])
                      end)
              end),

    awful.key({ modkey }, "g",
              function ()
                  awful.prompt.run({ prompt = "Google: " },
                  mypromptbox[mouse.screen].widget,
                  function (command)
                      awful.util.spawn_with_shell("chromium http://www.google.com/search?q=$(echo '"..command.."' | sed 's/ /+/g')", false)
                      awful.tag.viewonly(tags[1][1])
                      end)
              end),

    awful.key({ modkey, "Control" }, "g",
              function ()
                  awful.prompt.run({ prompt = "Lucky Google: " },
                  mypromptbox[mouse.screen].widget,
                  function (command)
                      awful.util.spawn_with_shell("chromium http://www.google.com/search?btnI=Recherche+Google\\&q=$(echo '"..command.."' | sed 's/ /+/g')", false)
                      awful.tag.viewonly(tags[1][1])
                      end)
              end),

    awful.key({ modkey }, "y",
              function ()
                  awful.prompt.run({ prompt = "YubNub: " },
                  mypromptbox[mouse.screen].widget,
                  function (command)
                      awful.util.spawn("chromium http://yubnub.org/parser/parse?command=$(echo '"..command.."' | sed 's/ /+/g')", false)
                      awful.tag.viewonly(tags[1][1])
                      end)
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][4],
      border_width = 0 } },
    { rule = { class = "Chromium" },
      properties = { tag = tags[1][2],
      border_width = 0,
      switchtotag = true } },
    { rule = { class = "Pidgin" },
      properties = { tag = tags[1][9] } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Autostart
function run_once(prg)
    if not prg then
        do return nil end
    end
    awful.util.spawn_with_shell("pgrep -f -u $USER -x " .. prg .. " || (" .. prg .. ")")
end

run_once("pidgin")
run_once("ssh-add")
run_once("chromium")

