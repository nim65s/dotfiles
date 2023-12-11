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
    arandr
    black
    cargo-binstall
    cargo-release
    cava
    ccze
    dfc
    dig
    dos2unix
    chrpath
    clang_16
    cmake
    cntr
    docker-compose
    du-dust
    #eigen
    element-desktop-wayland
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
    plantuml
    just
    khal
    khard
    kolourpaint
    less
    #llvmPackages_16.bintools
    mdcat
    mdbook
    mpv
    mypy
    nheko
    ninja
    nixpkgs-review
    nmap
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
    (poetry.withPlugins(ps: with ps; [
      poetry-plugin-up
    ]))
    (python3.withPackages(ps: with ps; [
      boost
      django
      httpx
      i3ipc
      ipython
      numpy
      pandocfilters
      pip
      wheel
    ]))
    pre-commit
    pulseaudio
    pavucontrol
    ripgrep
    rofi-power-menu
    rofi-rbw
    ruff
    rustup
    sauce-code-pro
    signal-desktop
    sd
    sccache
    shellcheck
    slurp
    source-sans
    spotify
    sqlite
    swappy
    tig
    tinc
    todoman
    tree
    usbutils
    vdirsyncer
    virtualbox
    vlc
    watchexec
    wev
    #wireplumber
    wl-clipboard
    wtype
    xclip
    xdotool
    xdg-desktop-portal-hyprland
    xwayland
    yt-dlp
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

    ".xinitrc".text = "exec i3";
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

  services.signaturepdf = {
    enable = true;
    port = 5165;
    extraConfig = {
      max_file_uploads = "201";
      post_max_size = "24M";
      upload_max_filesize = "24M";
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
    windowManager.i3.enable = true;
  };

  wayland.windowManager.sway.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      source = "~/dotfiles/.config/hypr/hyprland.conf";
    };
  };
}
