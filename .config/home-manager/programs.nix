{ pkgs, lib, atjoin }:

{
  atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = { sync_address = "https://atuin.datcat.fr"; };
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
      theme = "zenburn";
      pager = "less";
    };
  };

  btop = {
    enable = true;
    settings = {
      cpu_single_graph = true;
    };
  };

  #programs.chromium = {
    #enable = true;
    #package = pkgs.ungoogled-chromium;
    #commandLineArgs = [ "--ozone-platform=wayland" ];
  #};

  firefox = import ./firefox.nix pkgs;

  fish = {
    enable = true;
    interactiveShellInit = ''
      test -f ~/dotfiles/.config/fish/config.fish
      and source ~/dotfiles/.config/fish/config.fish
    '';
    loginShellInit = ''
      if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        date >> ~/.hypr.log
        date >> ~/.hypr.err
        ~/.nix-profile/bin/nixGL ${pkgs.hyprland}/bin/Hyprland >> ~/.hypr.log 2>> ~/.hypr.err
      end
    '';
    shellAliases = {
      ll = lib.mkForce "${pkgs.lsd}/bin/lsd -lrt";
    };
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
          core = { excludesfile = "~/dotfiles/gitignore"; };
          push = { default = "simple"; };
          user = { signingKey = "4653CF28"; };
          pull = { ff = "only"; };
          init = { defaultBranch = "main"; };
          hub = { protocol = "ssh"; };
          submodule = { fetchJobs = 4; };
          fetch = { parallel = 4; };
          blame = { ignoreRevsFile = ".git-blame-ignore-revs"; };
          merge = { tool = "vimdiff"; guitool = "meld"; };
          diff = { tool = "vimdiff"; guitool = "meld"; };
          difftool = { cmd = "vimdiff"; prompt = false; };
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

  home-manager.enable = true;

  kitty = {
    enable = true;
    font.name = "Source Code Pro";
    font.size = 8;
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
    settings = {
      "touch_scroll_multiplier" = "10.0";
      "focus_follows_mouse" = true;
      "enable_audio_bell" = false;
      "enabled_layouts" = "splits,fat,tall,grid,horizontal,vertical,stack";
      "placement_strategy" = "top-left";
      "tab_bar_style" = "powerline";
      "tab_separator" = " | ";
      "background_opacity" = "0.7";
      "shell" = "fish";
    };
  };

  lsd = {
    enable = true;
    enableAliases = true;
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
  offlineimap.enable = true;

  rbw = {
    enable = true;
    settings = {
      email = atjoin { name="guilhem"; host="saurel.me";};
      base_url = "https://safe.datcat.fr";
    };
  };

  rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = [
      pkgs.rofi-emoji
      pkgs.rofi-file-browser
    ];
    terminal = "${pkgs.kitty}/bin/kitty";
    font = "Source Code Pro 12";
    theme = "arthur";
    extraConfig = {
      color-enabled = true;
      matching = "prefix";
      no-lazy-grab = true;
    };
  };

  ssh = {
    enable = true;
    controlMaster = "yes";
    includes = [ "local_config" ];
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
      "totoro" = {
        hostname = "totoro.saurel.me";
        user = "nim";
      };
      "nausicaa" = {
        hostname = "192.168.8.112";
        proxyJump = "totoro";
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
      directory.read_only = " ";
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

  /* TODO
  swaylock = {
    enable = true;
    settings = {
      color = "000000";
      show-failed-attempts = true;
    };
  };
  */

  vim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs; [
      vimPlugins.ale
      vimPlugins.colorizer
      vimPlugins.file-line
      vimPlugins.nerdcommenter
      vimPlugins.vim-airline
      vimPlugins.vim-airline-themes
      vimPlugins.vim-clang-format
      vimPlugins.vim-fugitive
      vimPlugins.vim-manpager
      vimPlugins.vim-nix
      vimPlugins.vim-pager
      vimPlugins.vim-sensible
      vimPlugins.vim-signify
      vimPlugins.vim-toml
      vimPlugins.yuck-vim
      vimPlugins.zenburn
    ];
    settings = {
      backupdir = [ "~/.vim/tmp" "~/.tmp" "~/tmp" "/var/tmp" "/tmp" ];
      directory = [ "~/.vim/tmp" "~/.tmp" "~/tmp" "/var/tmp" "/tmp" ];
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
        layer = "top";
        position = "top";
        height = 24;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "custom/media" "pulseaudio" "network" "memory" "cpu" "temperature" "battery" "clock" "tray"];

        "tray" = { "spacing" = 10; };
        "cpu" = { "format" = "{}% "; };
        "memory" = { "format" = "{}% "; };
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
          "format-icons" = ["" "" "" "" ""];
        };
        "clock" ={
          "tooltip-format" = "<tt>{calendar}</tt>";
          "format-alt" = "{:%Y-%m-%d}";
        };
        "pulseaudio" = {
          "scroll-step" = 1;
          "format" = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = " {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" "" ""];
          };
          "on-click" = "pavucontrol";
        };
        "network" = {
            "format-wifi" = "{essid} ({signalStrength}%) ";
            "format-ethernet" = "{ipaddr}/{cidr} 🌍";
            "tooltip-format" = "{ifname} via {gwaddr} 🌍";
            "format-linked" = "{ifname} (No IP) 🌍";
            "format-disconnected" = "Disconnected 🌍";
            "format-alt" = "{ifname}: {ipaddr}/{cidr}";
        };
        "hyprland/workspaces" = {
          "on-scroll-up" = "hyprctl dispatch workspace e+1";
          "on-scroll-down" = "hyprctl dispatch workspace e-1";
        };
        "custom/media" = {
          "format" = "{icon}{}";
          "return-type" = "json";
          "format-icons" = {
            "Playing" = " ";
            "Paused" = " ";
          };
          "max-length" = 70;
          "exec" = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{album}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
          "on-click" = "playerctl play-pause";
          "on-click-right" = "playerctl next";
        };
      };
    };
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
}
