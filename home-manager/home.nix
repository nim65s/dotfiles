{
  config,
  lib,
  pkgs,
  ...
}:
{
  home = {
    username = config.my-username;
    homeDirectory = "/home/${config.my-username}";
    enableDebugInfo = true;
    stateVersion = "23.05"; # Please read the comment before changing.
    keyboard = {
      layout = "fr";
      variant = "bepo";
    };

    packages = with pkgs; [
      acpi
      age
      alacritty
      arandr
      black
      brightnessctl
      broot
      cachix
      cargo
      cargo-binstall
      cargo-release
      cava
      ccze
      clan-cli
      cntr
      comma
      dcfldd
      dconf
      deadnix
      dfc
      d-spy
      dig
      dos2unix
      chrpath
      clang_17
      clang-tools
      cmake
      cmake-format
      cntr
      docker-compose
      du-dust
      element-desktop-wayland
      evince
      #eww-wayland
      eza
      fd
      ffmpeg
      file
      fish
      fishPlugins.bass
      font-awesome
      fork-manager
      fuzzel
      gdb
      gdbgui
      ghostscript
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
      hwloc
      i3lock
      iftop
      inetutils
      imv
      iotop
      i3
      i3lock
      i3status-rust
      isort
      jless
      jq
      just
      kcov
      khal
      khard
      killall
      kolourpaint
      less
      libreoffice
      lix
      llvmPackages_17.openmp
      lsd
      lsof
      gnumake
      mdcat
      mdbook
      meld
      meshlab
      mosh
      mpv
      mypy
      ncdu
      ninja
      niri
      nitrogen
      nixd
      nixfmt-rfc-style
      (nixpkgs-review.override {
        nix = lix;
        withNom = true;
      })
      #nix-du
      nix-diff
      nix-init
      nix-output-monitor
      nix-tree
      nix-update
      nmap
      noto-fonts-emoji
      nurl
      okular
      openldap
      openssh
      openssl
      pandoc
      pavucontrol
      pciutils
      pdfarranger
      pdfpc
      #pipewire
      pinentry-qt
      pipx
      plantuml
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
          pyyaml
          tabulate
          tqdm
          wand
          wheel
        ]
      ))
      pre-commit
      pre-commit-sort
      pulseaudio
      pavucontrol
      pwgen
      ripgrep
      rofi-emoji
      rofi-file-browser
      rofi-power-menu
      rofi-rbw
      rpi-imager
      ruff
      rustc
      nur.repos.nim65s.sauce-code-pro
      signal-desktop
      sd
      sccache
      shellcheck
      slurp
      snapcast
      sops
      source-han-mono
      source-han-sans
      source-han-serif
      source-sans
      source-serif
      spotify
      sqlite
      ssh-to-age
      statix
      strace
      swappy
      #sway
      swaylock
      tig
      tinc
      thunderbird
      todoman
      tree
      unzip
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
      wget
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
      zfs
      zola
      zoom-us
    ];

    pointerCursor = {
      package = pkgs.gruppled-white-lite-cursors;
      name = "gruppled_white_lite";
      gtk.enable = true;
    };

    file = {
      ".config/dfc/dfcrc".source = ../.config/dfc/dfcrc;
      ".config/niri/config.kdl".source = ../.config/niri/config.kdl;
      ".config/kitty/open-actions.conf".source = ../.config/kitty/open-actions.conf;
      ".config/khal/config".source = ../.config/khal/config;
      ".config/khard/khard.conf".source = ../.config/khard/khard.conf;
      ".config/python_keyring/keyringrc.cfg".source = ../.config/python_keyring/keyringrc.cfg;
      ".config/rofi-rbw.rc".source = ../.config/rofi-rbw.rc;
      ".config/vdirsyncer/config".source = ../.config/vdirsyncer/config;
      ".ipython/profile_default/ipython_config.py".source = ../.ipython/profile_default/ipython_config.py;
      ".latexmkrc".source = ../.latexmkrc;
      ".pypirc".source = ../.pypirc;

      ".xinitrc".text = "exec ${lib.getExe pkgs.i3} > ~/.x.log 2> ~/.x.err";
    };

    sessionVariables = {
      BROWSER = lib.getExe config.programs.firefox.finalPackage;
      CLAN_DIR = "$HOME/dotfiles";
      CMAKE_BUILD_TYPE = "RelWithDebInfo";
      CMAKE_C_COMPILER_LAUNCHER = "sccache";
      CMAKE_CXX_COMPILER_LAUNCHER = "sccache";
      CMAKE_COLOR_DIAGNOSTICS = "ON";
      CMAKE_EXPORT_COMPILE_COMMANDS = "ON";
      CMAKE_GENERATOR = "Ninja";
      CMEEL_LOG_LEVEL = "DEBUG";
      CTEST_OUTPUT_ON_FAILURE = "ON";
      CTEST_PROGRESS_OUTPUT = "ON";
      DELTA_PAGER = "less -FR";
      MANPAGER = "vim -c ASMANPAGER -";
      PAGER = "vim -c PAGER -";
      POETRY_VIRTUALENVS_IN_PROJECT = "true";
      RUSTC_WRAPPER = lib.getExe pkgs.sccache;
      SHELL = lib.getExe pkgs.fish;
      SSH_ASKPASS = "$HOME/scripts/ask_rbw.py";
      SSH_ASKPASS_REQUIRE = "prefer";
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
      TWINE_USERNAME = "nim65s";
    };
  };
}
