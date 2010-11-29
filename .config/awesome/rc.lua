require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")
require("teardrop")
require("vicious")

beautiful.init("/home/nim/.config/awesome/awesome.zenburn.nimed.theme.lua")

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
tags[2] = awful.tag({ "1:pms", "2:chrome", "3:vim", "4:firefox", 5, 6, 7, 8, 9}, 2, { layouts[1], layouts[1], layouts[2], layouts[1], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2]})
tags[1] = awful.tag({ "1:IM", "2:fah&rtorrent", 3, 4}, 1, awful.layout.suit.fair)
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
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
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
homeicone = widget({ type = "imagebox" })
homeicone.image = image(beautiful.home_icon)
spkricone = widget({ type = "imagebox" })
spkricone.image = image(beautiful.spkr_icon)
spkricone:buttons(awful.util.table.join(
	awful.button({ }, 1, function () awful.util.spawn("/home/nim/scripts/audio.sh m") end),
	awful.button({ }, 5, function () awful.util.spawn("/home/nim/scripts/audio.sh -") end),
	awful.button({ }, 4, function () awful.util.spawn("/home/nim/scripts/audio.sh +") end)))

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
cpuwidget:buttons(awful.button({ }, 1, function () awful.util.spawn_with_shell("terminator -e 'htop'",2) end))

mpdwidget = widget({ type = "textbox", name = "mpdwidget", align = "center" })
vicious.register(mpdwidget, vicious.widgets.mpd, 
function(widget,args)
	if args["{state}"] == "Stop" then
		return " Stop " 
	else
		return ' '..args["{volume}"]..' : '.. bold(args["{Artist}"])..' ( '..args["{Album}"]..' ) => '..args["{Title}"]
	end
end, 3)
mpdwidget:buttons(awful.util.table.join(
	awful.button({ }, 1, function () awful.util.spawn("mpc toggle") end),
	awful.button({ }, 5, function () awful.util.spawn("mpc volume -3") end),
	awful.button({ }, 4, function () awful.util.spawn("mpc volume +3") end)))
previcone:buttons(awful.button({ }, 1, function () awful.util.spawn("mpc seek 0%") end))
nexticone:buttons(awful.button({ }, 1, function () awful.util.spawn("mpc next") end))

netwidget = widget({ type = "textbox", align = "right" })
vicious.register(netwidget, vicious.widgets.net, '${eth0 down_kb} - ${eth0 up_kb}', 3)
netwidget:buttons(awful.util.table.join(
	awful.button({ }, 1, function () awful.util.spawn_with_shell("terminator -e 'sudo iptraf -i eth0'", 2) end),
	awful.button({ }, 3, function () awful.util.spawn_with_shell("terminator -e 'sudo iftop'", 2) end)))

--senwidget = widget({ type = "textbox" })
--vicious.register(senwidget, vicious.contrib.sensors, " $1 ")


fswidget = widget({ type = "textbox", align = "right" })
vicious.register(fswidget, vicious.widgets.fs, "${/home used_p}% / ${/ used_p}%")
fswidget:buttons(awful.button({ }, 1, function () awful.util.spawn_with_shell("terminator -e 'df -h; read -n 1'", 2) end))

mygmail = widget({ type = "textbox" })
mygmail_t = awful.tooltip({ objects = { mygmail }, })
vicious.register(mygmail, vicious.widgets.gmail,function (widget, args)
					             mygmail_t:set_text(args["{subject}"])
					             return args["{count}"]
						 end, 10)
mygmail:buttons(awful.button({ }, 1, function () 
	awful.util.spawn_with_shell("chromium https://mail.google.com") 
	awful.tag.viewonly(tags[2][2])
end ))

memwidget = widget({ type = "textbox", align = "right" })
vicious.register(memwidget, vicious.widgets.sensors, " $1% ")

pacwidget = widget({ type = "textbox", align = "right" })
pacmanicone = widget({ type = "imagebox" })
pacmanicone.image = image(beautiful.pacman_icon)
pacwidget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () 
			awful.util.spawn_with_shell("terminator -e 'yaourt -Syu'",2)
			pacwidget.text = '0'
	end),
    awful.button({ }, 3, function () 
			awful.util.spawn_with_shell("terminator -e 'yaourt -Syu --aur --devel'",2)
			pacwidget.text = '0'
	end)))
pacmanicone:buttons(awful.util.table.join(
    awful.button({ }, 1, function () 
			awful.util.spawn_with_shell("terminator -e 'yaourt -Syu'",2)
			pacwidget.text = '0'
	end),
    awful.button({ }, 3, function ()
			awful.util.spawn_with_shell("terminator -e 'yaourt -Syu --aur --devel'",2)
			pacwidget.text = '0'
	end)))
pacwidget_timer = timer({ timeout = 300 })
pacwidget_timer:add_signal("timeout", function () pacwidget.text = io.popen("pacman -Qu | wc -l", "r"):read("*a") end)
pacwidget_timer:start()

fahwidget = widget({ type = "imagebox" })
fahwidget.image = image(beautiful.aw_icon)
fahwidget:buttons(awful.button({ }, 1, function () awful.util.spawn("/home/nim/scripts/fah.sh awesome", false) end))
fahwidget:add_signal("mouse::enter", function() awful.util.spawn_with_shell("/home/nim/scripts/fah.sh notify") end)

fahsmpwidget = awful.widget.progressbar()
fahsmpwidget:set_width(8)
fahsmpwidget:set_vertical(true)
fahsmpwidget:set_color(beautiful.fg_normal)
fahgpuwidget = awful.widget.progressbar()
fahgpuwidget:set_width(8)
fahgpuwidget:set_vertical(true)
fahgpuwidget:set_color(beautiful.fg_normal)

fahwidget_timer = timer({ timeout = 300 })
fahwidget_timer:add_signal("timeout", function () 
		fahgpuwidget:set_value(io.popen("tail -n 1 /opt/fah-gpu/alpha/unitinfo.txt | cut -d' ' -f 2 | sed 's/%//'","r"):read("*a")/100)
		fahsmpwidget:set_value(io.popen("tail -n 1 /opt/fah-smp/unitinfo.txt | cut -d' ' -f 2 | sed 's/%//'","r"):read("*a")/100)
end)
fahwidget_timer:start()

volwidget = awful.widget.progressbar()
volwidget:set_width(10)
volwidget:set_vertical(true)
volwidget:set_color(beautiful.fg_normal)
volwidget:set_max_value(10)
volwidget:set_value(io.popen("ossmix vmix0-outvol | cut -d' ' -f 10","r"):read("*a")-15)
--volwidget.widget:buttons(awful.util.table.join(
--	awful.button({ }, 1, function () awful.util.spawn("/home/nim/scripts/audio.sh m") end),
--	awful.button({ }, 5, function () awful.util.spawn("/home/nim/scripts/audio.sh -") end),
--	awful.button({ }, 4, function () awful.util.spawn("/home/nim/scripts/audio.sh +") end)))

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
        text = string.format('<span font_desc="%s">%s</span>', self.font, cal),
        timeout = 0,
        hover_timeout = 0.5,
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

-- Create a textclock widget
wiclock = awful.widget.textclock({ align = "right" }, "%T - %d/%m ", 1)
wiclock:add_signal("mouse::enter", function() calendar:month(0) end)
wiclock:add_signal("mouse::leave", function() calendar:remove() end)
wiclock:buttons(awful.util.table.join(
    awful.button({ }, 1, function() awful.util.spawn_with_shell("/home/nim/scripts/edt.sh notify") end),
    awful.button({ }, 3, function() awful.util.spawn_with_shell("/home/nim/scripts/edt.sh notify alarm") end),
    awful.button({ }, 5, function() calendar:month(-1) end),
    awful.button({ }, 4, function() calendar:month(1) end)))

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
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
                                                  awful.tag.viewonly(c:tags()[1])
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
mywibox[1] = awful.wibox({ position = "bottom", screen = 1 })
mywibox[2] = awful.wibox({ position = "top", screen = 2 })
mywibox[3] = awful.wibox({ position = "bottom", screen = 2 })

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)
				  end
    -- Add widgets to the wibox - order matters
    mywibox[1].widgets = {
        {
            mytaglist[1],
            mypromptbox[1],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[1],
        wiclock,
        mytasklist[1],
        layout = awful.widget.layout.horizontal.rightleft
    }
    mywibox[2].widgets = {
	    {
		    mytaglist[2],
		    mypromptbox[2],
		    layout = awful.widget.layout.horizontal.leftright
	    },
	    wiclock,
	    mylayoutbox[2],
	    mytasklist[2],
	    layout = awful.widget.layout.horizontal.rightleft
    }
    mywibox[3].widgets = {
	    {
		    mylauncher,
		    mysystray,
			fahgpuwidget,
		    fahwidget,
			fahsmpwidget,
		    previcone,
		    playicone,
		    nexticone,
			volwidget,
		    spkricone,
		    mpdwidget,
		    layout = awful.widget.layout.horizontal.leftright
	    },
	    mygmail,
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

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey,           }, "o",     
 		function (c) 
	    		if mouse.screen == 1 then awful.client.movetoscreen(c,2) end
			if mouse.screen == 2 then awful.client.movetoscreen(c,1) end
    		end),
    
    -- http://wiki.archlinux.org/index.php/Awesome3
    awful.key({ modkey,           }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/images/screenshots/ 2>/dev/null'") end),
	
	-- tentative de cachage de ces p*** de wibox pour voir des trucs en plein écran...
	awful.key({ modkey,           }, "b",     function () wiboxtoggle()                    end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey },            "v",     function () teardrop("terminator", "bottom", "center", 1, 0.2, true) end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    awful.key({ modkey }, "w",
              function ()
                  awful.prompt.run({ prompt = "Wikipedia: " },
                  mypromptbox[mouse.screen].widget,
                  function (command)
                      if mouse.screen == 1 then awful.screen.focus (2) end
                      awful.util.spawn_with_shell("chromium http://wikipedia.fr/Resultats.php?q=$(echo '"..command.."' | sed 's/ /+/g')", false)
                      awful.tag.viewonly(tags[2][2])
                      end)
              end),

    awful.key({ modkey }, "g",
              function ()
                  awful.prompt.run({ prompt = "Google: " },
                  mypromptbox[mouse.screen].widget,
                  function (command)
                      if mouse.screen == 1 then awful.screen.focus (2) end
                      awful.util.spawn_with_shell("chromium http://www.google.com/search?q=$(echo '"..command.."' | sed 's/ /+/g')", false)
                      awful.tag.viewonly(tags[2][2])
                      end)
              end),

    awful.key({ modkey, "Control" }, "g",
              function ()
                  awful.prompt.run({ prompt = "Lucky Google: " },
                  mypromptbox[mouse.screen].widget,
                  function (command)
                      if mouse.screen == 1 then awful.screen.focus (2) end
                      awful.util.spawn_with_shell("chromium http://www.google.com/search?btnI=Recherche+Google\\&q=$(echo '"..command.."' | sed 's/ /+/g')", false)
                      awful.tag.viewonly(tags[2][2])
                      end)
              end),

    awful.key({ modkey }, "y",
              function ()
                  awful.prompt.run({ prompt = "YubNub: " },
                  mypromptbox[mouse.screen].widget,
                  function (command)
                      if mouse.screen == 1 then awful.screen.focus (2) end
                      awful.util.spawn("chromium http://yubnub.org/parser/parse?command=$(echo '"..command.."' | sed 's/ /+/g')", false)
                      awful.tag.viewonly(tags[2][2])
                      end)
              end),

    awful.key({ }, "XF86Calculator",
              function ()
                  awful.prompt.run({ prompt = "Calculate: " },
                  mypromptbox[mouse.screen].widget,
                  function (expr)
                      local xmessage = "xmessage -timeout 10 -file -"
                      awful.util.spawn_with_shell("echo '" .. expr .. ' = ' ..
                      awful.util.eval("return (" .. expr .. ")") .. "' | " .. xmessage, false
                      )
                  end)
              end),

    awful.key({ }, "XF86HomePage", 
              function ()
                  if mouse.screen == 1 then awful.screen.focus (2) end
                  awful.util.spawn("chromium", false)
                  awful.tag.viewonly(tags[2][2])
              end),

    awful.key({ }, "XF86Mail", 
              function ()
                  if mouse.screen == 1 then awful.screen.focus (2) end
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
                  mypromptbox[mouse.screen].widget,
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
    -- All clients will match this rule.
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
      properties = { tag = tags[2][4],
      border_width = 0 } },
    { rule = { class = "Chromium" },
      properties = { tag = tags[2][2],
      border_width = 0,
      switchtotag = true } },
    { rule = { class = "Thunderbird" },
      properties = { tag = tags[2][3],
      border_width = 0 } },
    { rule = { class = "Kmess" },
      properties = { switchtotag = true,
      tag = tags[1][1],
      screen = 1 
      } },
    { rule = { class = "amarokapp" },
      properties = { tag = tags[2][1],
      border_width = 0 } },
    { rule = { class = "feh"},
      properties = { fullscreen = true } },
    { rule = { class = "kmix" },
      properties = { tag = tags[1][9],
      border_width = 0 } } 
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
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
awful.screen.focus(2)
awful.tag.viewonly(tags[2][9])
run_once("kalarm")
--}}}

naughty.config.presets.low.screen=2
naughty.config.presets.normal.screen=2
naughty.config.presets.critical.screen=2
