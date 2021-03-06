require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")
require("teardrop")
require("vicious")

beautiful.init(".config/awesome/awesome.zenburn.nimed.theme.lua")

terminal = "urxvtc"
editor = "vim"
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
awful.tag.seticon("images/awicons/spotify.png", tags[1][1])
awful.tag.seticon("images/awicons/chromium.png", tags[1][2])
awful.tag.seticon("images/awicons/xmpp.png", tags[1][9])
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", function () awful.util.spawn_with_shell(terminal .. "-e 'vim $XDG_CONFIG_HOME/awesome/rc.lua; awesome -k; read -n 1'", 2) end },
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
		else
				mywibox[1].visible = true
				mywibox[2].visible = true
		end
end

playicone = widget({ type = "imagebox" })
playicone.image = image(beautiful.play_icon)
pauseicone = widget({ type = "imagebox" })
pauseicone.image = image(beautiful.pause_icon)
nexticone = widget({ type = "imagebox" })
nexticone.image = image(beautiful.next_icon)
previcone = widget({ type = "imagebox" })
previcone.image = image(beautiful.prev_icon)
downicone = widget({ type = "imagebox" })
downicone.image = image(beautiful.down_icon)
upicone = widget({ type = "imagebox" })
upicone.image = image(beautiful.up_icon)
cpuicone = widget({ type = "imagebox" })
cpuicone.image = image(beautiful.cpu_icon)
gmailicone = widget({ type = "imagebox" })
gmailicone.image = image(beautiful.gmail_icon)
gmailicone:buttons(awful.button({ }, 1, function () 
	awful.util.spawn_with_shell("chromium https://mail.google.com") 
	awful.tag.viewonly(tags[1][2])
end ))
homeicone = widget({ type = "imagebox" })
homeicone.image = image(beautiful.home_icon)
spkricone = widget({ type = "imagebox" })
spkricone.image = image(beautiful.spkr_icon)
spkricone:buttons(awful.util.table.join(
	awful.button({ }, 1, function () awful.util.spawn("./scripts/audio.sh m") end),
	awful.button({ }, 5, function () awful.util.spawn("./scripts/audio.sh -") end),
	awful.button({ }, 4, function () awful.util.spawn("./scripts/audio.sh +") end)))
clockicone = widget({ type = "imagebox" })
clockicone.image = image(beautiful.clock_icon)
clockicone:add_signal("mouse::enter", function() naughty.notify({ text = io.popen("crontab -l","r"):read("*a") }) end)
clockicone_timer = timer({ timeout = 3600 })
clockicone_timer:add_signal("timeout", function ()
		local l = io.popen("crontab -l | grep morningbird | wc -l","r"):read("*line")
		if l == '0' then clockicone.visible = false else clockicone.visible = true end
end)
clockicone_timer:start()
clockicone_timer:emit_signal("timeout")

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

cpuwidget = widget({ type = "textbox", align = "right" })
vicious.register(cpuwidget, vicious.widgets.cpu, " $2% - $3% ")
cpuwidget:buttons(awful.button({ }, 1, function () awful.util.spawn_with_shell(terminal .. "-e 'htop'",1) end))

mpdwidget = widget({ type = "textbox", name = "mpdwidget", align = "center" })
mpdwidget_timer = timer({ timeout = 1 })
mpdwidget_timer:add_signal("timeout", function () mpdwidget.text = io.popen('mpc --format " [[<b>%artist%</b>[ (%album%)] =>] %title%]|[%file%]" | sed "N;s/\\n/ /;s=#[0-9]*/[0-9]*==;N;s/\\n/ /;s/&/&amp;/g"'):read("*a") end)
mpdwidget_timer:start()

mpdwidget:buttons(awful.util.table.join(
	awful.button({ }, 1, function () awful.util.spawn("mpc toggle") end),
	awful.button({ }, 5, function () awful.util.spawn("mpc volume -3") end),
	awful.button({ }, 4, function () awful.util.spawn("mpc volume +3") end)))
previcone:buttons(awful.button({ }, 1, function () awful.util.spawn("mpc seek 0%") end))
nexticone:buttons(awful.button({ }, 1, function () awful.util.spawn("mpc next") end))

netwidget = widget({ type = "textbox", align = "right" })
vicious.register(netwidget, vicious.widgets.net, '${eth0 down_kb} - ${eth0 up_kb}', 3)
netwidget:buttons(awful.util.table.join(
	awful.button({ }, 1, function () awful.util.spawn_with_shell(terminal .. "-e 'sudo iptraf -i eth0'", 1) end),
	awful.button({ }, 3, function () awful.util.spawn_with_shell(terminal .. "-e 'sudo iftop'", 1) end)))

fswidget = widget({ type = "textbox", align = "right" })
vicious.register(fswidget, vicious.widgets.fs, "${/home used_p}% / ${/ used_p}%")
fswidget:buttons(awful.button({ }, 1, function () awful.util.spawn_with_shell(terminal .. "-e 'df -h; read -n 1'", 1) end))

pacwidget = widget({ type = "textbox", align = "right" })
pacmanicone = widget({ type = "imagebox" })
pacmanicone.image = image(beautiful.pacman_icon)
pacwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () 
			awful.util.spawn_with_shell(terminal .. "-e 'yaourt -Syu'",1)
			pacwidget.text = '0'
	end),
    awful.button({ }, 3, function () 
			awful.util.spawn_with_shell(terminal .. "-e 'yaourt -Syu --aur --devel'",1)
			pacwidget.text = '0'
	end)))
pacmanicone:buttons(awful.util.table.join(
    awful.button({ }, 1, function () 
			awful.util.spawn_with_shell(terminal .. "-e 'yaourt -Syu'",1)
			pacwidget.text = '0'
	end),
    awful.button({ }, 3, function ()
			awful.util.spawn_with_shell(terminal .. "-e 'yaourt -Syu --aur --devel'",1)
			pacwidget.text = '0'
	end)))
pacwidget_timer = timer({ timeout = 300 })
pacwidget_timer:add_signal("timeout", function () pacwidget.text = io.popen("pacman -Qu | wc -l", "r"):read("*a") end)
pacwidget_timer:start()
pacwidget_timer:emit_signal("timeout")
volwidget = awful.widget.progressbar()
volwidget:set_width(10)
volwidget:set_vertical(true)
volwidget:set_color(beautiful.fg_normal)
volwidget:set_max_value(100)
-- volwidget:set_value(io.popen("ossmix vmix0-outvol | cut -d' ' -f 10","r"):read("*a")-15)
volwidget:set_value(tonumber(io.popen("amixer get Master| tail -n 1 | cut -d' ' -f 6 | sed 's/\[//;s/%\]//'","r"):read("*a")))
volwidget.widget:buttons(awful.util.table.join(
	awful.button({ }, 1, function () awful.util.spawn("./scripts/audio.sh m") end),
	awful.button({ }, 5, function () awful.util.spawn("./scripts/audio.sh -") end),
	awful.button({ }, 4, function () awful.util.spawn("./scripts/audio.sh +") end)))

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
    awful.button({ }, 1, function() awful.util.spawn_with_shell("./scripts/edt.sh notify") end),
    awful.button({ }, 3, function() 
			awful.util.spawn_with_shell("./scripts/edt.sh notify alarm") 
			clockicone_timer:emit_signal("timeout")
	end),
    awful.button({ }, 5, function() calendar:month(-1) end),
    awful.button({ }, 4, function() calendar:month(1) end)))

mysystray = {}
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
mywibox[2] = awful.wibox({ position = "bottom", screen = 1 })

    mypromptbox[1] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    mylayoutbox[1] = awful.widget.layoutbox(s)
    mylayoutbox[1]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    mytaglist = awful.widget.taglist(1, awful.widget.taglist.label.all, mytaglist.buttons)
    mytasklist = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, 1)
                                          end, mytasklist.buttons)
    mywibox[1].widgets = {
	    {
		    mytaglist,
		    mypromptbox[1],
		    layout = awful.widget.layout.horizontal.leftright
	    },
	    wiclock,
		clockicone,
	    mylayoutbox[1],
	    mytasklist,
	    layout = awful.widget.layout.horizontal.rightleft
    }
    mywibox[2].widgets = {
	    {
		    mylauncher,
		    mysystray,
		    previcone,
		    playicone,
		    nexticone,
			volwidget,
		    spkricone,
		    mpdwidget,
		    layout = awful.widget.layout.horizontal.leftright
	    },
	    gmailicone,
	    pacwidget,
	    pacmanicone,
	    cpuwidget,
	    cpuicone,
	    fswidget,
	    homeicone,
		upicone,
	    netwidget,
	    downicone,
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

    awful.key({ modkey,           }, "t",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "s",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey, "Shift"   }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "t", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "s", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "t", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "s", function () awful.screen.focus_relative(-1) end),
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
    awful.key({ modkey, "Control" }, "h", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    awful.key({ modkey,           }, "q",     function() awful.util.spawn("xscreensaver-command -lock") end),

    awful.key({ modkey,           }, "r",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "c",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "c",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "r",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "c",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "r",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    
    -- http://wiki.archlinux.org/index.php/Awesome3
	
	awful.key({ modkey,           }, "b",     function () wiboxtoggle()                    end),

    -- Prompt
    awful.key({ modkey },            "h",     function () mypromptbox[1]:run() end),
    awful.key({ modkey },            "v",     function () teardrop(terminal .. " -e ./scripts/teardrop.sh", "bottom", "center", 1, 0.3, true) end),


    awful.key({ modkey }, "w",
              function ()
                  awful.prompt.run({ prompt = "Wikipedia: " },
                  mypromptbox[mouse.screen].widget,
                  function (command)
                      awful.util.spawn_with_shell("chromium http://fr.wikipedia.org/w/index.php?title=Sp%C3%A9cial:Recherche\\&search=$(echo '"..command.."' | sed 's/ /+/g')", false)
                      awful.tag.viewonly(tags[1][2])
                      end)
              end),

    awful.key({ modkey }, "a",
              function ()
                  awful.prompt.run({ prompt = "Archlinux: " },
                  mypromptbox[mouse.screen].widget,
                  function (command)
                      awful.util.spawn_with_shell("chromium https://wiki.archlinux.org/index.php?search="..command, false)
                      awful.tag.viewonly(tags[1][2])
                      end)
              end),

    awful.key({ modkey, "Shift" }, "a",
              function ()
                  awful.prompt.run({ prompt = "ArchlinuxFr: " },
                  mypromptbox[mouse.screen].widget,
                  function (command)
                      awful.util.spawn_with_shell("chromium http://wiki.archlinux.fr/index.php?search="..command, false)
                      awful.tag.viewonly(tags[1][2])
                      end)
              end),

    awful.key({ modkey }, "g",
              function ()
                  awful.prompt.run({ prompt = "Google: " },
                  mypromptbox[mouse.screen].widget,
                  function (command)
                      awful.util.spawn_with_shell("chromium http://www.google.com/search?q=$(echo '"..command.."' | sed 's/ /+/g')", false)
                      awful.tag.viewonly(tags[1][2])
                      end)
              end),

    awful.key({ modkey, "Control" }, "g",
              function ()
                  awful.prompt.run({ prompt = "Lucky Google: " },
                  mypromptbox[mouse.screen].widget,
                  function (command)
                      awful.util.spawn_with_shell("chromium http://www.google.com/search?btnI=Recherche+Google\\&q=$(echo '"..command.."' | sed 's/ /+/g')", false)
                      awful.tag.viewonly(tags[1][2])
                      end)
              end),

    awful.key({ modkey }, "y",
              function ()
                  awful.prompt.run({ prompt = "YubNub: " },
                  mypromptbox[mouse.screen].widget,
                  function (command)
                      awful.util.spawn("chromium http://yubnub.org/parser/parse?command=$(echo '"..command.."' | sed 's/ /+/g')", false)
                      awful.tag.viewonly(tags[1][2])
                      end)
              end),

    awful.key({ }, "XF86Calculator",
              function ()
                  awful.prompt.run({ prompt = "Calculate: " },
                  mypromptbox[1].widget,
                  function (expr)
                      local xmessage = "xmessage -timeout 10 -file -"
                      awful.util.spawn_with_shell("echo '" .. expr .. ' = ' ..
                      awful.util.eval("return (" .. expr .. ")") .. "' | " .. xmessage, false
                      )
                  end)
              end),

    awful.key({ }, "XF86HomePage", 
              function ()
                  awful.util.spawn("chromium", false)
                  awful.tag.viewonly(tags[1][2])
              end),

    awful.key({ }, "XF86Mail", 
              function ()
                  awful.util.spawn("thunderbird", false)
              end),

    awful.key({ }, "XF86Search", 
              function ()
                  bepowidget.text = "fr "
                  awful.util.spawn("setxkbmap fr", false)
              end),

    awful.key({ modkey }, "XF86Search", 
              function ()
                  bepowidget.text = "bépo "
                  awful.util.spawn("setxkbmap fr bepo", false)
              end),

-- TODO : si rien ne rien faire
    awful.key({ }, "XF86Favorites",
              function ()
                  awful.prompt.run({ prompt = "Manual: " }, 
                  mypromptbox[1].widget,
                  function (page) awful.util.spawn("khelpcenter man:" .. page, false) end,
                  function(cmd, cur_pos, ncomp)
                      local pages = {}
                      local m = 'IFS=: && find $(manpath||echo "$MANPATH") -type f -printf "%f\n"| cut -d. -f1'
                      local c, err = io.popen(m)
                      if c then while true do
                          local manpage = c:read("*line")
                          if not manpage then break end
                          if manpage:find("^" .. cmd:sub(1, cur_pos)) then
                              table.insert(pages, manpage)
                              end
                          end
                      c:close()
                      else io.stderr:write(err) end
                      if #cmd == 0 then return cmd, cur_pos end
                      if #pages == 0 then return end
                      while ncomp > #pages do ncomp = ncomp - #pages end
                      return pages[ncomp], cur_pos
                      end)
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "x",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "h",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "j",      function (c) c.ontop = not c.ontop            end),
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
    { rule = { class = "Gvim" },
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

run_once("ssh-add")
run_once("chromium")

