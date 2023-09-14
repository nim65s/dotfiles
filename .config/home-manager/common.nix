{ config, pkgs, lib, ... }:

let
  gruppled-white-lite-cursors = pkgs.callPackage ./gruppled-lite-cursors {
    theme = "gruppled_white_lite";
  };
  sauce-code-pro = pkgs.nerdfonts.override {
    fonts = [ "SourceCodePro" ];
  };
  atjoin = { name, host ? "laas.fr" }: "${name}@${host}";
in

{
  nixpkgs.config = import ./nixpkgs-config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;

  fonts.fontconfig.enable = true;

  home.enableDebugInfo = true;

  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    acpi
    adwaita-qt
    bacon
    black
    cargo-binstall
    cargo-release
    ccze
    dfc
    dos2unix
    chrpath
    clang_16
    cmake
    cntr
    docker-compose
    du-dust
    #eigen
    #element-desktop-wayland
    evince
    eww-wayland
    eza
    fd
    file
    fishPlugins.bass
    git
    gnupg
    gtklock
    gtklock-userinfo-module
    gtklock-powerbar-module
    gtklock-playerctl-module
    grim
    helix
    htop
    httpie
    hyprpaper
    hyprpicker
    inetutils
    imv
    isort
    pinentry
    just
    khal
    khard
    kolourpaint
    less
    #llvmPackages_16.bintools
    mdbook
    mpv
    mypy
    nheko
    ninja
    nixpkgs-review
    okular
    openssh
    openssl
    pandoc
    pavucontrol
    pdfpc
    #pipewire
    pipx
    pkg-config
    playerctl
    #poetry
    #poetryPlugins.poetry-plugin-up
    python3
    #python310Packages.boost
    #python310Packages.django
    #python310Packages.i3ipc
    #python310Packages.ipython
    #python310Packages.numpy
    #python310Packages.pandocfilters
    #python310Packages.python
    #python310Packages.poetry-dynamic-versioning
    pre-commit
    pulseaudio
    pavucontrol
    ripgrep
    rofi-power-menu
    rofi-rbw-wayland
    ruff
    rustup
    sauce-code-pro
    sd
    sccache
    shellcheck
    source-sans
    sqlite
    swappy
    tig
    tinc
    todoman
    tree
    vdirsyncer
    vlc
    watchexec
    wev
    #wireplumber
    xdg-desktop-portal-hyprland
    xwayland
    zathura
    zellij
    zoom-us
  ];

  home.pointerCursor = {
    package = gruppled-white-lite-cursors;
    name = "gruppled_white_lite";
    gtk.enable = true;
  };

  home.file = {
    ".config/dfc/dfcrc".source = ../dfc/dfcrc;
    ".config/kitty/open-actions.conf".source = ../kitty/open-actions.conf;
    ".config/python_keyring/keyringrc.cfg".source = ../python_keyring/keyringrc.cfg;
    ".config/rofi-rbw.rc".source = ../rofi-rbw.rc;
    ".latexmkrc".source = ../../.latexmkrc;
    ".pypirc".source = ../../.pypirc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    SHELL = "${pkgs.fish}/bin/fish";
    SSH_ASKPASS = "$HOME/scripts/ask_rbw.py";
    SSH_ASKPASS_REQUIRE = "prefer";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
    PAGER = "vim -c PAGER -";
    DELTA_PAGER = "less -FR";
    MANPAGER = "vim -c ASMANPAGER -";
  };

  accounts.email = {
    maildirBasePath = ".mails";
    accounts = {
      laas = {
        address = atjoin { name = "guilhem.saurel"; };
        aliases = [
          (atjoin { name = "gsaurel"; })
          (atjoin { name = "saurel"; })
        ];
        imap.host = "imap.laas.fr";
        imap.port = 993;
        msmtp.enable = true;
        neomutt.enable = true;
        notmuch.enable = true;
        notmuch.neomutt.enable = true;
        offlineimap.enable = true;
        passwordCommand = "rbw get --folder laas main";
        primary = true;
        realName = "Guilhem Saurel";
        smtp.host = "smtp.laas.fr";
        smtp.tls.useStartTls = true;
        thunderbird = {
          enable = true;
          profiles = ["nim"];
          perIdentitySettings = id: {
            "mail.identity.id_${id}.fcc_reply_follows_parent" = true;
          };
        };
        userName = "gsaurel";
      };
      perso = {
        address = atjoin { name="guilhem"; host="saurel.me";};
        imap.host = "mail.gandi.net";
        msmtp.enable = true;
        neomutt.enable = true;
        notmuch.enable = true;
        notmuch.neomutt.enable = true;
        offlineimap.enable = true;
        passwordCommand = "rbw get --folder mail perso";
        realName = "Guilhem Saurel";
        smtp.host = "mail.gandi.net";
        smtp.tls.enable = true;
        userName = atjoin { name="guilhem"; host="saurel.me";};
      };
    };
  };

  gtk = {
    enable = true;
    font.name = "Source Sans";
    theme.package = pkgs.gnome.adwaita-icon-theme;
    theme.name = "Adwaita";
  };

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = { sync_address = "https://atuin.datcat.fr"; };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "zenburn";
      pager = "less";
    };
  };

  programs.btop = {
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

  programs.firefox = import ./firefox.nix pkgs;

  programs.fish = {
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

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  programs.git = {
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

  programs.home-manager.enable = true;

  programs.kitty = {
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

  programs.lsd = {
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

  programs.msmtp.enable = true;
  programs.neomutt.enable = true;
  programs.notmuch.enable = true;
  programs.offlineimap.enable = true;

  programs.rbw = {
    enable = true;
    settings = {
      email = atjoin { name="guilhem"; host="saurel.me";};
      base_url = "https://safe.datcat.fr";
    };
  };

  programs.rofi = {
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

  programs.ssh = {
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

  programs.starship = {
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

  programs.thunderbird = {
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
  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      show-failed-attempts = true;
    };
  };
  */

  programs.vim = {
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

  programs.waybar = {
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

  programs.zathura = {
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

  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "keyboard";
        geometry = "0x5-10+10";
        indicate_hidden = true;
        padding = 10;
        horizontal_padding = 10;
        sort = true;
        format = "<b>%s</b>\n%b";
        font = "Source Sans";
        browser = "${pkgs.firefox-devedition}/bin/firefox -new-tab";
      };
    };
  };

  services.ssh-agent.enable = true;

  services.spotifyd = {
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
  systemd.user.services.spotifyd.Service.Environment = ["PATH=${pkgs.rbw}/bin"];

  services.swayosd.enable = true;

  xdg.mimeApps = {
    enable = true;
  };

  xsession = {
    enable = true;
    numlock.enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        fonts.names = ["Source Code Pro"];
        fonts.size = 8.0;
        modifier = "Mod4";
        bars = [{
          fonts.names = ["Source Code Pro"];
          fonts.size = 8.0;
        }];
        keybindings = let
          mod = config.xsession.windowManager.i3.config.modifier;
        in lib.mkOptionDefault {
          "${mod}+Return" = "exec \"nixGL kitty\"";
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
          "$XF86AudioPlay" = "exec \"playerctl play-pause\"";
          "$XF86AudioPrev" = "exec \"playerctl previous\"";
          "$XF86AudioNext" = "exec \"playerctl next\"";
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
        workspaceOutputAssign = [
          { "workspace" = "1";  "output" = "DP-1"; }
          { "workspace" = "2";  "output" = "DP-1"; }
          { "workspace" = "3";  "output" = "DP-1"; }
          { "workspace" = "4";  "output" = "DP-1"; }
          { "workspace" = "5";  "output" = "DP-1"; }
          { "workspace" = "6";  "output" = "DP-1"; }
          { "workspace" = "7";  "output" = "DP-1"; }
          { "workspace" = "8";  "output" = "DP-1"; }
          { "workspace" = "9";  "output" = "DP-1"; }
          { "workspace" = "10"; "output" = "DP-2"; }
          { "workspace" = "11"; "output" = "DP-2"; }
          { "workspace" = "12"; "output" = "DP-2"; }
        ];
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      source = "~/dotfiles/.config/hypr/hyprland.conf";
    };
  };
}
