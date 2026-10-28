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
      colorized-logs
      comma
      dcfldd
      # devenv
      docker-compose
      #eww-wayland
      fishPlugins.bass
      #font-awesome
      gersemi
      git-extras
      git-fork-clone
      git-objects-cache
      gnumake
      gnupg
      # himalaya
      hwloc
      imv
      jless
      jq
      keep-sorted
      lsof
      lurk
      md5cron
      mdcat
      minicom
      mosh
      mpc
      mypy
      #nix-du
      nix-output-monitor
      nix-update
      nixd
      nixfmt
      nixook
      nmap
      #noto-fonts-emoji
      openssl
      pciutils
      pipewire
      # pipx TODO https://github.com/NixOS/nixpkgs/pull/526458
      pkg-config
      playerctl
      pmapnitor
      pratches
      pre-commit
      pwgen
      rbw
      ruff
      rustscan
      sd
      shellcheck
      slurp
      sops
      sqlite
      ssh-to-age
      statix
      #sway
      tailstamp
      tdf
      tree
      tree-sitter
      unzip
      usbutils
      #ventoy  # TODO: https://github.com/ventoy/Ventoy/issues/3224
      wev
      wget
      xkcdpass
      yq
      zfs
      #zola
      # keep-sorted end
    ]
    ++ [
      (python3.withPackages (
        ps: with ps; [
          # keep-sorted start
          httpx
          ipython
          jinja2
          numpy
          pandas
          pip
          pyarrow
          pytest
          pyyaml
          tabulate
          tomlkit
          tqdm
          wheel
          # keep-sorted end
        ]
      ))
    ]
    ++ lib.optionals config.nim-home.gui [
      # keep-sorted start
      brightnessctl
      evince
      gparted
      grim
      libreoffice
      mpv
      niri
      pdfarranger
      pinentry-qt
      pwvucontrol
      rofi-rbw
      rofimoji
      swaybg
      # swaylock
      vlc
      # vscode-fhs
      wdisplays
      #wireplumber
      wl-clipboard
      wtype
      zathura
      # keep-sorted end
    ];

}
