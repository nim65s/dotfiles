{
  config,
  pkgs,
  lib,
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
  imports = [
    ./modules.nix
    ./programs.nix
  ];
  fonts.fontconfig.enable = true;

  home.enableDebugInfo = true;

  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.keyboard = {
    layout = "fr";
    variant = "bepo";
  };

  home.packages = with pkgs; [
    acpi
    arandr
    black
    brightnessctl
    broot
    cargo-binstall
    cargo-release
    cava
    ccze
    dcfldd
    dconf
    dfc
    d-spy
    dig
    dos2unix
    chrpath
    clang_17
    cmake
    cntr
    docker-compose
    du-dust
    element-desktop-wayland
    evince
    #eww-wayland
    eza
    fd
    file
    firefox-devedition
    fish
    fishPlugins.bass
    font-awesome
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
    hugo
    i3lock
    iftop
    inetutils
    imv
    iotop
    i3
    i3lock
    i3status-rust
    isort
    pinentry
    plantuml
    just
    khal
    khard
    killall
    kitty
    kolourpaint
    less
    lsd
    lsof
    mdcat
    mdbook
    meld
    mosh
    mpv
    mypy
    ninja
    nitrogen
    nixfmt-rfc-style
    nixpkgs-review
    nix
    nmap
    noto-fonts-emoji
    okular
    openldap
    openssh
    openssl
    pandoc
    pavucontrol
    pdfpc
    #pipewire
    pipx
    pkg-config
    playerctl
    (poetry.withPlugins (ps: with ps; [ poetry-plugin-up ]))
    (python3.withPackages (
      ps: with ps; [
        django
        httpx
        i3ipc
        ipython
        jinja2
        ldap3
        numpy
        pandas
        pandocfilters
        pip
        pyarrow
        tabulate
        tqdm
        wand
        wheel
      ]
    ))
    pre-commit
    pulseaudio
    pavucontrol
    ripgrep
    rofi-emoji
    rofi-file-browser
    rofi-power-menu
    rofi-rbw
    rpi-imager
    ruff
    rustup
    sauce-code-pro
    signal-desktop
    sd
    sccache
    shellcheck
    slurp
    snapcast
    source-han-mono
    source-han-sans
    source-han-serif
    source-sans
    source-serif
    spotify
    sqlite
    swappy
    #sway
    swaylock
    tig
    tinc
    thunderbird
    todoman
    tree
    usbutils
    ventoy
    vdirsyncer
    vlc
    vscode-fhs
    watchexec
    wev
    #wireplumber
    wl-clipboard
    xorg.xkill
    waybar
    wtype
    xclip
    wdisplays
    xdotool
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    xwayland
    yt-dlp
    zathura
    zeal
    zellij
    zola
    zoom-us
  ];

  home.pointerCursor = {
    package = pkgs.gruppled-white-lite-cursors;
    name = "gruppled_white_lite";
    gtk.enable = true;
  };

  home.file = {
    ".config/dfc/dfcrc".source = ../.config/dfc/dfcrc;
    ".config/kitty/open-actions.conf".source = ../.config/kitty/open-actions.conf;
    ".config/khal/config".source = ../.config/khal/config;
    ".config/khard/khard.conf".source = ../.config/khard/khard.conf;
    ".config/python_keyring/keyringrc.cfg".source = ../.config/python_keyring/keyringrc.cfg;
    ".config/rofi-rbw.rc".source = ../.config/rofi-rbw.rc;
    ".config/vdirsyncer/config".source = ../.config/vdirsyncer/config;
    ".latexmkrc".source = ../.latexmkrc;
    ".pypirc".source = ../.pypirc;

    ".xinitrc".text = "exec ${lib.getExe pkgs.i3} > ~/.x.log 2> ~/.x.err";
  };

  home.sessionVariables = {
    SHELL = lib.getExe pkgs.fish;
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
        neomutt.enable = false;
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
          profiles = [ "nim" ];
          perIdentitySettings = id: {
            "mail.identity.id_${id}.fcc_reply_follows_parent" = true;
            "layers.acceleration.disabled" = true; # TODO
          };
        };
        userName = "gsaurel";
      };
      perso =
        let
          mail = atjoin {
            name = "guilhem";
            host = "saurel.me";
          };
        in
        {
          address = "${mail}";
          folders.inbox = "INBOX";
          imap.host = "mail.gandi.net";
          msmtp.enable = true;
          neomutt = {
            enable = true;
            extraConfig = ''
              set hostname="saurel.me"
              my_hdr Bcc: ${mail}
            '';
          };
          notmuch.enable = true;
          notmuch.neomutt.enable = true;
          offlineimap.enable = true;
          passwordCommand = "rbw get --folder mail perso";
          realName = "Guilhem Saurel";
          smtp.host = "mail.gandi.net";
          smtp.tls.enable = true;
          userName = atjoin {
            name = "guilhem";
            host = "saurel.me";
          };
        };
    };
  };

  nix = {
    #package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  qt = {
    enable = true;
    platformTheme = "qtct";
  };

  gtk = {
    enable = true;
    font.name = "Source Sans";
    theme.package = pkgs.libsForQt5.breeze-gtk;
    theme.name = "Breeze-Dark";
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
        format = ''
          <b>%s</b>
          %b'';
        font = "Source Sans";
        browser = "${lib.getExe pkgs.firefox-devedition} -new-tab";
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
  systemd.user.services.spotifyd.Service.Environment = [ "PATH=${pkgs.rbw}/bin" ];

  xdg = {
    enable = true;
    portal = {
      config.sway.default = [
        "wlr"
        "gtk"
      ];
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];
      xdgOpenUsePortal = true;
    };
  };

  xsession = {
    enable = true;
    numlock.enable = true;
    windowManager.i3.enable = true;
  };

  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.sway;
    extraConfig = ''
      hide_edge_borders --smart-titles smart
    '';
  };
}