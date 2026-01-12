{
  config,
  ...
}:
{
  home.programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        ${if config.nim-home.waybar-output != "" then "output" else null} = config.nim-home.waybar-output;
        layer = "top";

        position = "bottom";

        height = 36;

        modules-left = [
          "niri/workspaces"
        ];

        modules-center = [ "niri/window" ];

        modules-right = [
          "custom/media"
          "pulseaudio"
          "network"
          "memory"
          "cpu"
          "temperature"
          "backlight"
          "battery"
          "clock"
          "tray"
        ];

        "niri/workspaces" = {
          "all-outputs" = true;
          "disable-auto-back-and-forth" = true;
          "disable-scroll-wraparound" = true;
        };

        "tray" = {
          "spacing" = 10;
        };

        "cpu" = {
          "format" = "{usage}% ";
        };

        "memory" = {
          "format" = "{}% ";
        };

        "battery" = {
          "states" = {
            "good" = 80;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          "format-full" = "";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        "clock" = {
          "tooltip-format" = "<tt>{calendar}</tt>";
          "format" = "{:%Y-%m-%d %H:%M}";
        };

        "pulseaudio" = {
          "scroll-step" = 1;
          "format" = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = "󰝟 {icon} {format_source}";
          "format-muted" = "󰝟 {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [
              ""
              ""
              ""
            ];
          };
          "on-click" = "pwvucontrol";
        };

        "network" = {
          "format-wifi" = "{essid} ({signalStrength}%) ";
          "format-ethernet" = "{ipaddr}/{cidr} 🌍";
          "tooltip-format" = "{ifname} via {gwaddr} 🌍";
          "format-linked" = "{ifname} (No IP) 🌍";
          "format-disconnected" = "Disconnected ⚠";
          "format-alt" = "{ifname}: {ipaddr}/{cidr}";
        };

        "custom/media" = {
          "format" = "{icon} {}";
          "return-type" = "json";
          "format-icons" = {
            "Playing" = " ";
            "Paused" = " ";
          };
          "max-length" = 70;
          "exec" =
            ''playerctl -a metadata --format '{"text": "{{artist}} - {{markup_escape(title)}}", "tooltip": "{{album}}", "alt": "{{status}}", "class": "{{status}}"}' -F'';
          "on-click" = "playerctl play-pause";
          "on-click-right" = "playerctl next";
        };
      };
    };
  };
}
