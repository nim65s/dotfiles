{
  config,
  pkgs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      # keep-sorted start
      acpi
      age
      bandwhich
      binutils
      broot
      cachix
      caligula
      chrpath
      cmake
      # cmake-format
      cntr
      colorized-logs
      comma
      dcfldd
      deadnix
      # devenv
      docker-compose
      dos2unix
      erdtree
      #eww-wayland
      fishPlugins.bass
      formatjson5
      #font-awesome
      fuzzel
      gersemi
      ghostscript
      git-extras
      git-fork-clone
      git-objects-cache
      git-statuses
      gnumake
      gnupg
      # himalaya
      hwloc
      imv
      jless
      jq
      just
      keep-sorted
      lsof
      lurk
      md5cron
      mdbook
      mdcat
      minicom
      mosh
      mpc
      mypy
      ninja
      #nix-du
      nix-diff-rs
      nix-output-monitor
      nix-tree-rs
      nix-update
      nixd
      nixfmt
      nixook
      nmap
      #noto-fonts-emoji
      nurl
      openldap
      openssl
      pandoc
      pciutils
      pipewire
      # pipx TODO https://github.com/NixOS/nixpkgs/pull/526458
      pkg-config
      playerctl
      pmapnitor
      pratches
      pre-commit
      pre-commit-sort
      prefetch-npm-deps
      prek
      pwgen
      rbw
      rosdep
      ruff
      rustscan
      sccache
      sd
      shellcheck
      slurp
      sops
      sqlite
      ssh-to-age
      statix
      strace
      #sway
      tailstamp
      tdf
      toml-sort
      tree
      tree-sitter
      typst
      typstyle
      unzip
      usbutils
      #ventoy  # TODO: https://github.com/ventoy/Ventoy/issues/3224
      watchexec
      weechat
      wev
      wget
      xkcdpass
      yq
      yt-dlp
      zfs
      #zola
      # keep-sorted end
    ]
    ++ [
      (python3.withPackages (
        ps: with ps; [
          # keep-sorted start
          django
          httpx
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
          tomlkit
          tqdm
          wand
          wheel
          # keep-sorted end
        ]
      ))
    ]
    ++ lib.optionals config.nim-home.gui [
      # keep-sorted start
      brightnessctl
      cage
      d-spy
      evince
      gparted
      grim
      iosevka
      iosevka-aile
      iosevka-etoile
      iosevka-term
      kcov
      kdePackages.kolourpaint
      kdePackages.okular
      libreoffice
      meld
      mesa-demos
      meshlab
      mpv
      niri
      pdfarranger
      pdfpc
      pinentry-qt
      pwvucontrol
      rofi-rbw
      rofimoji
      signal-desktop
      slint-viewer
      swaybg
      # swaylock
      vlc
      # vscode-fhs
      wdisplays
      #wireplumber
      wl-clipboard
      wtype
      zathura
      zeal
      # keep-sorted end
    ];

}
