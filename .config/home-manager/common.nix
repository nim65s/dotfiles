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
    ".config/khal/config".source = ../khal/config;
    ".config/khard/khard.conf".source = ../khard/khard.conf;
    ".config/python_keyring/keyringrc.cfg".source = ../python_keyring/keyringrc.cfg;
    ".config/rofi-rbw.rc".source = ../rofi-rbw.rc;
    ".config/vdirsyncer/config".source = ../vdirsyncer/config;
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

  programs = import ./programs.nix { pkgs=pkgs; lib=lib; atjoin=atjoin; };

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
