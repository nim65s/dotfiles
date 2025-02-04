{
  config,
  lib,
  pkgs,
  sops,
  ...
}:
let
  atjoin = { name, host ? "laas.fr" }: lib.concatStringsSep "@" [ name host ];
in {
  imports = [
    ./firefox.nix
    ./nim-home-minimal.nix
    ./nim-accounts.nix
    ../home-manager/todo.nix
  ];

  options = {
    nim-home = {
      niri = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
      };
      swaybgs = lib.mkOption {
        type = lib.types.str;
        default = "${lib.getExe pkgs.swaybg} -m fill -i ${config.stylix.image}";
      };
      waybar-output = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
    };
  };

  config = {
    home = {
      file = {
        ".config/niri/config.kdl".source = pkgs.concatText "config.kdl" (
          [ ./niri.kdl ] ++ config.nim-home.niri
        );
        ".ssh/id_ed25519_sk".source = sops.secrets.ssh-sk1.path;
      };
      keyboard = {
        layout = "fr";
        variant = "ergol";
      };
    };

    programs = {
      alacritty.enable = true;

      atuin = {
        enable = true;
        flags = [ "--disable-up-arrow" ];
        settings.sync_address = "https://atuin.datcat.fr";
      };

      bacon = {
        enable = true;
        settings = {
          reverse = true;
        };
      };

      kitty.enable = true;

      msmtp.enable = true;
      neomutt.enable = true;
      notmuch.enable = true;
      nix-index.enable = true;
      offlineimap.enable = true;

      rbw = {
        enable = true;
        settings = {
          email = atjoin { name = "guilhem"; host = "saurel.me"; };
          base_url = "https://safe.datcat.fr";
          pinentry = pkgs.pinentry-qt;
        };
      };

      rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        terminal = lib.getExe pkgs.kitty;
        extraConfig = {
          color-enabled = true;
          matching = "prefix";
          no-lazy-grab = true;
        };
      };

      swaylock = {
        enable = true;
        settings = {
          show-failed-attempts = true;
          ignore-empty-password = true;
          font = "Iosevdka";
        };
      };
      waybar = {
        enable = true;
        settings = {
          mainBar = {
            ${if config.nim-home.waybar-output != "" then "output" else null} = config.nim-home.waybar-output;
            layer = "top";
            position = "bottom";
            height = 32;
            modules-left = [
              "niri/workspaces"
              "niri/mode"
              "niri/scratchpad"
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
              "on-click" = "pavucontrol";
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
      zathura.enable = true;
    };

    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };

    services = {
      spotifyd = {
        enable = true;
        settings = {
          global = {
            username = "nim65s";
            password_cmd = "rbw get spotify";
            device_name = "home-manager";
            device_type = "computer";
            backend = "pulseaudio";
          };
        };
      };
      ssh-agent.enable = true;
      swaync.enable = true;
      swayidle = {
        enable = true;
        events = [
          {
            event = "before-sleep";
            command = lib.getExe pkgs.swaylock;
          }
        ];
      };
    };

    systemd = {
      user.services = {
        spotifyd.Service.Environment = [ "PATH=${pkgs.rbw}/bin" ];
        swaybgs = {
          Install.WantedBy = [ "graphical-session.target" ];
          Service.ExecStart = pkgs.writeShellScript "swaybgs" config.nim-home.swaybgs;
          Unit = {
            Description = "Set wallpaper(s)";
            PartOf = "graphical-session.target";
            After = "graphical-session.target";
          };
        };
      };
    };
  };
}
