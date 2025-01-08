{ config, lib, pkgs, ... }:
{
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
      username = "nim";
      homeDirectory = "/home/nim";
      stateVersion = "25.05";

      file = {
        ".config/niri/config.kdl".source = pkgs.concatText "config.kdl" ([ ./niri.kdl ] ++ config.nim-home.niri);
      };
    };

    programs = {
      alacritty.enable = true;
      bat.enable = true;
      btop.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      eza = {
        enable = true;
        git = true;
        icons = "auto";
        extraOptions = [
          "--classify"
          "--color-scale=all"
          "--git-ignore"
          "--group"
          "--header"
          "--hyperlink"
          "--ignore-glob=.git|*.orig|*~"
        ];
      };
      fish.enable = true;
      helix = {
        enable = true;
        defaultEditor = true;
      };
      kitty.enable = true;
      starship = {
        enable = true;
        settings = {
          format = "┬─ $all$time$line_break╰─ $jobs$battery$status$container$os$shell$character";
          time.disabled = false;
          status.disabled = false;
          package.disabled = true;
          os = {
            disabled = false;
            symbols = {
              Alpine = " ";
              Amazon = " ";
              Android = " ";
              Arch = " ";
              CentOS = " ";
              Debian = " ";
              DragonFly = " ";
              Emscripten = " ";
              EndeavourOS = " ";
              Fedora = " ";
              FreeBSD = " ";
              Garuda = "﯑ ";
              Gentoo = " ";
              HardenedBSD = "ﲊ ";
              Illumos = " ";
              Linux = " ";
              Macos = " ";
              Manjaro = " ";
              Mariner = " ";
              MidnightBSD = " ";
              Mint = " ";
              NetBSD = " ";
              NixOS = " ";
              OpenBSD = " ";
              openSUSE = " ";
              OracleLinux = " ";
              Pop = " ";
              Raspbian = " ";
              Redhat = " ";
              RedHatEnterprise = " ";
              Redox = " ";
              Solus = "ﴱ ";
              SUSE = " ";
              Ubuntu = " ";
              Unknown = " ";
              Windows = " ";
            };
          };
          aws.symbol = "  ";
          buf.symbol = " ";
          c.symbol = " ";
          conda.symbol = " ";
          dart.symbol = " ";
          directory.read_only = " 󰌾";
          docker_context.symbol = " ";
          elixir.symbol = " ";
          elm.symbol = " ";
          fossil_branch.symbol = " ";
          git_branch.symbol = " ";
          golang.symbol = " ";
          guix_shell.symbol = " ";
          haskell.symbol = " ";
          haxe.symbol = "⌘ ";
          hg_branch.symbol = " ";
          java.symbol = " ";
          julia.symbol = " ";
          lua.symbol = " ";
          memory_usage.symbol = " ";
          meson.symbol = "喝 ";
          nim.symbol = " ";
          nix_shell.symbol = " ";
          nodejs.symbol = " ";
          pijul_channel.symbol = "🪺 ";
          python.symbol = " ";
          rlang.symbol = "ﳒ ";
          ruby.symbol = " ";
          rust.symbol = " ";
          scala.symbol = " ";
          spack.symbol = "🅢 ";
          hostname.ssh_symbol = " ";
        };
      };
      swaylock.enable = true;
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
              "exec" = ''playerctl -a metadata --format '{"text": "{{artist}} - {{markup_escape(title)}}", "tooltip": "{{album}}", "alt": "{{status}}", "class": "{{status}}"}' -F'';
              "on-click" = "playerctl play-pause";
              "on-click-right" = "playerctl next";
            };
          };
        };
      };
      zoxide = {
        enable = true;
        options = [
          "--cmd"
          "cd"
        ];
      };
    };

    services = {
      swaync.enable = true;
      swayidle = {
        enable = true;
        events = [
          { event = "before-sleep"; command = lib.getExe pkgs.swaylock; }
        ];
      };
    };

    systemd = {
      user.services = {
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
