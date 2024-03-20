{
  lib,
  sway,
  pkgs,
  workspaceOutputAssign,
  nixGL,
}:
let
  mod = "Mod4";
in
{
  inherit workspaceOutputAssign;
  fonts.names = [ "SauceCodePro Nerd Font" ];
  fonts.size = 8.0;
  modifier = mod;
  window = {
    commands =
      [
        {
          command = "layout tabbed";
          criteria = {
            class = "^Signal$";
          };
        }
        {
          command = "layout tabbed";
          criteria = {
            class = "^Element$";
          };
        }
      ]
      ++ lib.optionals sway [
        {
          command = "layout tabbed";
          criteria = {
            app_id = "Element";
          };
        }
      ];
    hideEdgeBorders = "smart";
  };
  ${if sway then "up" else null} = "s";
  ${if sway then "down" else null} = "t";
  ${if sway then "left" else null} = "c";
  ${if sway then "right" else null} = "r";
  terminal = "${nixGL} ${lib.getExe pkgs.kitty}";
  menu = "${if sway then lib.getExe pkgs.rofi-wayland else lib.getExe pkgs.rofi} -show run";
  gaps.smartBorders = "on";
  workspaceAutoBackAndForth = true;
  bars = lib.optionals (!sway) [
    {
      fonts.names = [ "SauceCodePro Nerd Font" ];
      fonts.size = 8.0;
      statusCommand = "${lib.getExe pkgs.i3status-rust} config-default.toml";
    }
  ];
  assigns = {
    "9" = [ { class = "^Zeal$"; } ] ++ lib.optionals sway [ { app_id = "org.zealdocs.zeal"; } ];
    "10" = [ { class = "^Firefox$"; } ] ++ lib.optionals sway [ { app_id = "firefox"; } ];
    "11" = [ { class = "^thunderbird$"; } ] ++ lib.optionals sway [ { app_id = "thunderbird"; } ];
    "12" = [
      { class = "^Signal$"; }
      { class = "^Element$"; }
    ] ++ lib.optionals sway [ { app_id = "Element"; } ];
  };
  #extraConfig = "";
  keybindings = {
    "${mod}+Return" = ''exec "${nixGL} ${lib.getExe pkgs.kitty}"'';
    "${mod}+i" = ''exec "${
      if sway then lib.getExe pkgs.rofi-wayland else lib.getExe pkgs.rofi
    } -show run"'';
    "${mod}+e" = ''exec "${lib.getExe pkgs.rofi-rbw} ${
      if sway then "--typer wtype --clipboarder wl-copy" else "--typer xdotool --clipboarder xclip"
    }"'';
    "${mod}+x" = ''exec "${if sway then lib.getExe pkgs.swaylock else lib.getExe pkgs.i3lock}"'';
    "${mod}+Shift+x" = "kill";
    "${mod}+c" = "focus left";
    "${mod}+t" = "focus down";
    "${mod}+s" = "focus up";
    "${mod}+r" = "focus right";
    "${mod}+Shift+c" = "move left";
    "${mod}+Shift+t" = "move down";
    "${mod}+Shift+s" = "move up";
    "${mod}+Shift+r" = "move right";
    "${mod}+Left" = "workspace prev";
    "${mod}+Right" = "workspace next";
    "${mod}+Shift+Up" = "move workspace to output up";
    "${mod}+Shift+Down" = "move workspace to output down";
    "${mod}+Shift+Left" = "move workspace to output left";
    "${mod}+Shift+Right" = "move workspace to output right";
    "${mod}+Escape" = "workspace back_and_forth";
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
    "${mod}+Shift+b" = "reload";
    "${mod}+Shift+o" = "restart";
    "${mod}+Shift+p" = ''exec "${
      if sway then "swaynag" else "i3-nagbar"
    } -t warning -m 'You pressed the exit shortcut. Do you really want to exit ${if sway then "sway" else "i3"}? ' -b 'Yes' '${
      if sway then "swaymsg" else "i3-msg"
    } exit'"'';
    "${mod}+o" = "mode resize";
    "${mod}+w" = "move workspace to output right";
    "${mod}+z" = "move workspace to output left";
    "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
    "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
    "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle";
    "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
    "XF86AudioPlay" = ''exec --no-startup-id "${lib.getExe pkgs.playerctl} play-pause"'';
    "XF86AudioPrev" = ''exec --no-startup-id "${lib.getExe pkgs.playerctl} previous"'';
    "XF86AudioNext" = ''exec --no-startup-id "${lib.getExe pkgs.playerctl} next"'';
    "XF86Display" = ''exec "${lib.getExe pkgs.arandr}"'';
    "XF86MonBrightnessUp" = ''exec --no-startup-id "${lib.getExe pkgs.brightnessctl} s 10%+"'';
    "XF86MonBrightnessDown" = ''exec --no-startup-id "${lib.getExe pkgs.brightnessctl} s 10%-"'';
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
  ${if sway then "input" else null} = {
    "type:keyboard" = {
      xkb_layout = "fr";
      xkb_numlock = "enabled";
      xkb_variant = "bepo";
    };
  };
  startup =
    [
      { command = lib.getExe pkgs.firefox-devedition; }
      { command = lib.getExe pkgs.thunderbird; }
      { command = lib.getExe pkgs.signal-desktop; }
      { command = lib.getExe pkgs.zeal; }
    ]
    ++ lib.optionals sway [
      { command = lib.getExe pkgs.element-desktop-wayland; }
      { command = lib.getExe pkgs.waybar; }
    ]
    ++ lib.optionals (!sway) [
      { command = lib.getExe pkgs.element-desktop; }
      { command = "setxkbmap -synch"; }
      { command = "${lib.getExe pkgs.nitrogen} --restore"; }
    ];
}
