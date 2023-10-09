{lib, sway}:
let
  mod = "Mod4";
in {
  fonts.names = ["Source Code Pro"];
  fonts.size = 8.0;
  modifier = mod;
  bars = [{
    fonts.names = ["Source Code Pro"];
    fonts.size = 8.0;
  }];
  keybindings = lib.mkOptionDefault {
    "${mod}+Return" = "exec \"nixGL kitty\"";
    "${mod}+i" = "exec \"rofi -show run\"";
    "${mod}+e" = "exec \"rofi-rbw --typer xdotool --clipboarder xclip\"";
    "${mod}+Shift+b" = "kill";
    "${mod}+c" = "focus left";
    "${mod}+t" = "focus down";
    "${mod}+s" = "focus up";
    "${mod}+r" = "focus right";
    "${mod}+Shift+c" = "move left";
    "${mod}+Shift+t" = "move down";
    "${mod}+Shift+s" = "move up";
    "${mod}+Shift+r" = "move right";
    "${mod}+Left" = "worspace prev";
    "${mod}+Right" = "worspace next";
    "${mod}+Shift+Up" = "move worspace to output up";
    "${mod}+Shift+Down" = "move worspace to output down";
    "${mod}+Shift+Left" = "move worspace to output left";
    "${mod}+Shift+Right" = "move worspace to output right";
    "${mod}+Escape" = "worspace back_and_forth";
    "${mod}+h" = "split h";
    "${mod}+Shift+h" = "split v";
    "${mod}+f" = "fullscreen";
    "${mod}+u" = "layout stacking";
    "${mod}+eacute" = "layout tabbed";
    "${mod}+p" = "layout toggle split";
    "${mod}+Shift+space" = "floating toggle";
    "${mod}+space" = "focus mode_toggle";
    "${mod}+quotedbl" = "workspace 1";
    "${mod}+guillemotleft" = "workspace 2";
    "${mod}+guillemotright" = "workspace 3";
    "${mod}+parenleft" = "workspace 4";
    "${mod}+parenright" = "workspace 5";
    "${mod}+at" = "workspace 6";
    "${mod}+plus" = "workspace 7";
    "${mod}+minus" = "workspace 8";
    "${mod}+slash" = "workspace 9";
    "${mod}+asterisk" = "workspace 10";
    "${mod}+equal" = "workspace 11";
    "${mod}+percent" = "workspace 12";
    "${mod}+Shift+quotedbl" = "move container to workspace 1";
    "${mod}+Shift+guillemotleft" = "move container to workspace 2";
    "${mod}+Shift+guillemotright" = "move container to workspace 3";
    "${mod}+Shift+4" = "move container to workspace 4";
    "${mod}+Shift+5" = "move container to workspace 5";
    "${mod}+Shift+at" = "move container to workspace 6";
    "${mod}+Shift+plus" = "move container to workspace 7";
    "${mod}+Shift+minus" = "move container to workspace 8";
    "${mod}+Shift+slash" = "move container to workspace 9";
    "${mod}+Shift+asterisk" = "move container to workspace 10";
    "${mod}+Shift+equal" = "move container to workspace 11";
    "${mod}+Shift+percent" = "move container to workspace 12";
    "${mod}+Shift+x" = "reload";
    "${mod}+Shift+o" = "restart";
    "${mod}+Shift+p" = "exec \"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'\"";
    "${mod}+o" = "mode resize";
    "${mod}+w" = "move workspace to output right";
    "${mod}+z" = "move workspace to output left";
    "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume 0 +5%";
    "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume 0 -5%";
    "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 0 toggle";
    "XF86AudioPlay" = "exec \"playerctl play-pause\"";
    "XF86AudioPrev" = "exec \"playerctl previous\"";
    "XF86AudioNext" = "exec \"playerctl next\"";
  };
  modes.resize = {
    "t" = "resize shrink width 10 px or 10 ppt";
    "s" = "resize grow height 10 px or 10 ppt";
    "r" = "resize shrink height 10 px or 10 ppt";
    "n" = "resize grow width 10 px or 10 ppt";
    "Left" = "resize shrink width 10 px or 10 ppt";
    "Down" = "resize grow height 10 px or 10 ppt";
    "Up" = "resize shrink height 10 px or 10 ppt";
    "Right" = "resize grow width 10 px or 10 ppt";
    "Return" = "mode default";
    "Escape" = "mode default";
  };
  workspaceAutoBackAndForth = true;
  ${if sway then "input" else null} = {
    "type:keyboard" = {
      xkb_layout  = "fr";
      xkb_variant = "bepo";
    };
  } ;
}
