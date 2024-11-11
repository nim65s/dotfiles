{
  config,
  lib,
  pkgs,
  ...
}:
let
  atjoin =
    {
      name,
      host ? "laas.fr",
    }:
    "${name}@${host}";
in
{
  imports = [ ./firefox.nix ];

  programs = {
    atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        sync_address = "https://atuin.datcat.fr";
      };
    };

    bacon = {
      enable = true;
      settings = {
        reverse = true;
        keybindings = {
          s = "scroll-lines(-1)";
          t = "scroll-lines(1)";
        };
      };
    };

    bat = {
      enable = true;
      config = {
        #theme = "zenburn";
        pager = "less";
      };
    };

    btop = {
      enable = true;
      settings = {
        cpu_single_graph = true;
      };
    };

    #chromium = {
    #enable = true;
    #package = pkgs.ungoogled-chromium;
    #commandLineArgs = [ "--ozone-platform=wayland" ];
    #};

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

    fish = {
      enable = true;
      shellAbbrs = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "......" = "cd ../../../../..";
        bn = "cmake -B build";
        bnb = "cmake -B build && cmake --build build";
        bb = "cmake --build build";
        bt = "cmake --build build -t test";
        bi = "cmake --build build -t install";
        demonte = "~/scripts/demonter.sh";
        dc = "cd";
        gc = {
          expansion = "git commit -am '%'";
          setCursor = true;
        };
        gd = "git difftool";
        gst = "git status";
        gp = "git push";
        gf = "git fetch --all --prune";
        gcan = "git commit -a --amend --no-edit";
        gcl = "git clone";
        gcr = "git clone --recursive";
        gch = "git checkout";
        glp = "git push -o merge_request.create -o merge_request.merge_when_pipeline_succeeds";
        grhh = "git reset --hard HEAD";
        gsub = "git commit -am submodules; git push";
        ipa = "ip address";
        ipr = "ip route";
        la = "eza -A";
        ll = "eza -l --sort newest";
        ls = "eza";
        lt = "eza --tree";
        lla = "eza -lA";
        llt = "eza -l --tree";
        lat = "eza -A --tree";
        lta = "eza -A --tree";
        monte = "~/scripts/monter.sh";
        psef = "ps -ef | grep -v grep | grep";
        v = "vim";
        vi = "vim";
        vmi = "vim";
        vd = "vimdiff";
        z = "zellij";
        za = "zathura";
      };
      interactiveShellInit = ''
        test -f ~/dotfiles/.config/fish/config.fish
        and source ~/dotfiles/.config/fish/config.fish
      '';
      loginShellInit = ''
        test -f ~/dotfiles/.config/fish/path.fish
        and source ~/dotfiles/.config/fish/path.fish

        if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
          #${lib.getExe config.wayland.windowManager.sway.package} > ~/.wayland.log 2> ~/.wayland.err
          ${pkgs.niri}/bin/niri-session > ~/.wayland.log 2> ~/.wayland.err
        end
      '';
      shellAliases = {
        "+" = "echo";
        cp = "cp -r";
        mpv = "mpv --no-border";
        mv = "mv -v";
        rm = "rm -Iv";
        watch = "watch --color -d";
      };
    };

    fzf = {
      enable = true;
    };

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };

    git = {
      enable = true;
      delta.enable = true;
      lfs.enable = true;
      userName = "Guilhem Saurel";
      userEmail = "guilhem.saurel@laas.fr";
      includes = [
        {
          contents = {
            core = {
              excludesfile = "~/dotfiles/gitignore";
            };
            push = {
              default = "simple";
            };
            user = {
              signingKey = "4653CF28";
            };
            pull = {
              ff = "only";
            };
            init = {
              defaultBranch = "main";
            };
            hub = {
              protocol = "ssh";
            };
            submodule = {
              fetchJobs = 4;
            };
            fetch = {
              parallel = 4;
            };
            blame = {
              ignoreRevsFile = ".git-blame-ignore-revs";
            };
            merge = {
              tool = "vimdiff";
              guitool = "meld";
            };
            diff = {
              tool = "vimdiff";
              guitool = "meld";
            };
            difftool = {
              cmd = "vimdiff";
              prompt = false;
            };
            color = {
              ui = "always";
              branch = "always";
              interactive = "always";
              status = "always";
            };
          };
        }
        { path = "~/dotfiles/.gitconfig"; }
      ];
    };

    helix = {
      defaultEditor = true;
      enable = true;
    };
    home-manager.enable = true;

    i3status-rust = {
      enable = true;
      bars.default = {
        icons = "awesome6";
        #theme = "gruvbox-dark";
        blocks = [
          { block = "music"; }
          { block = "net"; }
          {
            alert = 10.0;
            block = "disk_space";
            format = " $icon root: $available.eng(w:2) ";
            info_type = "available";
            interval = 20;
            path = "/";
            warning = 20.0;
          }
          { block = "memory"; }
          { block = "cpu"; }
          {
            block = "sound";
            click = [
              {
                button = "left";
                cmd = "pavucontrol";
              }
            ];
          }
          { block = "battery"; }
          {
            block = "time";
            format = " $timestamp.datetime(f:'%Y-%m-%d %H:%M') ";
            interval = 60;
          }
        ];
      };
    };

    kitty = {
      enable = true;
      #font.name = "SauceCodePro Nerd Font";
      #font.size = 8;
      keybindings = {
        "kitty_mod+left" = "resize_window narrower";
        "kitty_mod+right" = "resize_window wider";
        "kitty_mod+up" = "resize_window taller";
        "kitty_mod+down" = "resize_window shorter";
        "alt+n" = "launch --location=split --cwd=current";
        "alt+m" = "launch --location=hsplit --cwd=current";
        "alt+z" = "launch --location=vsplit --cwd=current";
        "kitty_mod+n" = "new_os_window_with_cwd";
        "alt+t" = "next_window";
        "alt+s" = "previous_window";
        "alt+shift+t" = "move_window_forward";
        "alt+shift+s" = "move_window_backward";
        "alt+shift+d" = "detach_window";
        "alt+l" = "next_tab";
        "alt+v" = "previous_tab";
        "alt+d" = "new_tab_with_cwd";
        "alt+plus" = "layout_action increase_num_full_size_windows";
        "alt+minus" = "layout_action decrease_num_full_size_windows";
        "kitty_mod+plus" = "change_font_size all +1.0";
        "kitty_mod+minus" = "change_font_size all -1.0";
      };
      package = config.lib.nixGL.wrap pkgs.kitty;
      settings = {
        touch_scroll_multiplier = "10.0";
        focus_follows_mouse = true;
        enable_audio_bell = false;
        enabled_layouts = "splits,fat,tall,grid,horizontal,vertical,stack";
        placement_strategy = "top-left";
        tab_bar_style = "powerline";
        tab_separator = " | ";
        #background_opacity = "0.7";
        shell = "${lib.getExe pkgs.fish}";
        scrollback_lines = 10000;
      };
    };

    lsd = {
      enable = true;
      settings = {
        header = true;
        hyperlink = "auto";
        indicators = true;
        ignore-globs = [
          ".git"
          "*.orig"
          "*~"
        ];
        total-size = true;
      };
    };

    msmtp.enable = true;
    neomutt.enable = true;
    notmuch.enable = true;
    nix-index.enable = true;
    offlineimap.enable = true;

    rbw = {
      enable = true;
      settings = {
        email = atjoin {
          name = "guilhem";
          host = "saurel.me";
        };
        base_url = "https://safe.datcat.fr";
        pinentry = pkgs.pinentry-qt;
      };
    };

    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = [
        pkgs.rofi-emoji
        pkgs.rofi-file-browser
      ];
      terminal = lib.getExe pkgs.kitty;
      #theme = {
      #"@theme" = "arthur";
      #"*" = {
      #font = "SauceCodePro Nerd Font 12";
      #};
      #};
      extraConfig = {
        color-enabled = true;
        matching = "prefix";
        no-lazy-grab = true;
      };
    };

    ssh = {
      enable = true;
      controlMaster = "auto";
      includes = [ "local_config" ];
      userKnownHostsFile = "~/.ssh/known_hosts ~/dotfiles/known_hosts";
      matchBlocks = {
        "gh" = {
          hostname = "github.com";
          user = "git";
        };
        "gl" = {
          hostname = "gitlab.laas.fr";
          user = "git";
        };
        "laas" = {
          hostname = "ssh.laas.fr";
          user = "gsaurel";
        };
        "upe" = {
          hostname = "upepesanke";
          user = "gsaurel";
          proxyJump = "laas";
        };
        "miya" = {
          hostname = "miyanoura";
          user = "gsaurel";
          proxyJump = "laas";
        };
        "totoro" = {
          hostname = "totoro.saurel.me";
          user = "nim";
        };
        "nausicaa" = {
          user = "nim";
          proxyJump = "totoro";
        };
        "*.l" = {
          hostname = "%haas.fr";
          forwardAgent = true;
          proxyJump = "laas";
          user = "gsaurel";
        };
        "*.L" = {
          hostname = "%haas.fr";
          forwardAgent = true;
          proxyJump = "laas";
          user = "root";
        };
        "*.t" = {
          hostname = "%hetaneutral.net";
          user = "root";
          port = 2222;
        };
      };
    };

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

    swaylock = {
      enable = true;
      settings = {
        #color = "000000";
        show-failed-attempts = true;
        ignore-empty-password = true;
        font = "SauceCodePro Nerd Font";
      };
    };

    thunderbird = {
      enable = true;
      profiles.nim = {
        isDefault = true;
        settings = {
          "extensions.activeThemeID" = "thunderbird-compact-dark@mozilla.org";
          "mail.identity.default.compose_html" = 1;
          "mail.pane_config.dynamic" = 2;
          "mail.server.default.check_all_folders_for_new" = true;
          "mail.uidensity" = 0;
          "mail.uifontsize" = 10;
          "ldap_2.autoComplete.useDirectory" = true;
          "ldap_2.servers.laas.description" = "Serveur LDAP LAAS";
          "ldap_2.servers.laas.filename" = "ldap.sqlite";
          "ldap_2.servers.laas.maxHits" = 100;
          "ldap_2.servers.laas.uri" = "ldap://ldap2.laas.fr/dc=laas,dc=fr%20??sub?(objectClass=person)";
          "ldap_2.servers.default.attrmap.PrimaryEmail" = "laas-mainMail";
        };
      };
    };

    vim = {
      enable = true;
      #defaultEditor = true;
      plugins = with pkgs; [
        vimPlugins.ale
        vimPlugins.colorizer
        vimPlugins.file-line
        vimPlugins.nerdcommenter
        vimPlugins.vim-airline
        vimPlugins.vim-airline-themes
        vimPlugins.vim-clang-format
        vimPlugins.vim-fugitive
        vimPlugins.vim-jinja
        vimPlugins.vim-manpager
        vimPlugins.vim-nix
        vimPlugins.vim-pager
        vimPlugins.vim-plugin-AnsiEsc
        vimPlugins.vim-sensible
        vimPlugins.vim-signify
        vimPlugins.vim-toml
        vimPlugins.vimspector
        vimPlugins.yuck-vim
        #vimPlugins.zenburn
      ];
      settings = {
        backupdir = [
          "~/.vim/tmp"
          "~/.tmp"
          "~/tmp"
          "/var/tmp"
          "/tmp"
        ];
        directory = [
          "~/.vim/tmp"
          "~/.tmp"
          "~/tmp"
          "/var/tmp"
          "/tmp"
        ];
        copyindent = true;
        expandtab = true;
        hidden = true;
        history = 1001;
        ignorecase = true;
        modeline = true;
        mouse = "a";
        mousefocus = true;
        mousehide = false;
        number = true;
        shiftwidth = 4;
        smartcase = true;
        tabstop = 8;
        undofile = true;
      };
      extraConfig = ''
        if empty($DOTFILES)
          let $DOTFILES = expand("~/dotfiles")
        endif
        let $VIMRC = $DOTFILES .. "/.vimrc"
        if filereadable($VIMRC)
          source $VIMRC
        endif
      '';
    };

    waybar = {
      enable = true;
      settings = {
        mainBar = {
          ${if config.my-waybar-output != "" then "output" else null} = config.my-waybar-output;
          layer = "top";
          position = "bottom";
          height = 32;
          modules-left = [
            "sway/workspaces"
            "sway/mode"
            "sway/scratchpad"
          ];
          modules-center = [ "sway/window" ];
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

          "sway/workspaces" = {
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
      #style = ./waybar.css;
    };

    zathura = {
      enable = true;
      mappings = {
        r = "reload";
        t = "navigate next";
        s = "navigate previous";
        v = "zoom in";
        l = "zoom out";
        q = "quit";
        n = "rotate";
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
}
