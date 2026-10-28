{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./accounts.nix
    ./nim-sync.nix
  ];

  home.packages = with pkgs; [
    # keep-sorted start
    black
    bloom
    pdfpc
    kdePackages.kolourpaint
    d-spy
    pdfarranger
    slint-viewer
    meshlab
    meld
    nurl
    kcov
    mesa-demos
    cage
    iosevka
    iosevka-aile
    iosevka-etoile
    iosevka-term
    zeal
    kdePackages.okular
    signal-desktop
    cargo
    cmeel
    colcon
    dockgen
    ffmpeg
    flakoboros
    gazebros2nix
    hugo
    jrl-cmakemodules-scripts
    khal
    nb
    nixpkgs-review
    nix-diff-rs
    nix-tree-rs
    yt-dlp
    watchexec
    weechat
    typst
    toml-sort
    strace
    sccache
    rosdep
    prek
    prefetch-npm-deps
    pandoc
    openldap
    ninja
    mdbook
    just
    git-statuses
    ghostscript
    formatjson5
    erdtree
    dos2unix
    deadnix
    cntr
    typstyle
    plantuml
    qemu
    templup
    vcs2l
    khard
    cargo-binstall
    cargo-release
    pre-commit-sort
    ros2cli
    rustc
    vdirsyncer
  ];

  programs = {
    alacritty.enable = true;

    asciinema.enable = true;

    atuin = {
      enable = true;
      daemon.enable = true;
      flags = [ "--disable-up-arrow" ];
      settings.sync_address = "https://atuin.datcat.fr";
    };

    bacon = {
      enable = true;
      settings = {
        reverse = true;
      };
    };

    ghostty.enable = true;

    git.settings.maintenance.repo = [
      "${config.home.homeDirectory}/dotfiles"
      "${config.home.homeDirectory}/local/gepetto/gazebros2nix"
      "${config.home.homeDirectory}/local/gepetto/nix"
      "${config.home.homeDirectory}/local/lopsided98/nix-ros-overlay"
      "${config.home.homeDirectory}/local/NixOS/nixpkgs"
      "${config.home.homeDirectory}/local/pi2/homes"
    ];

    gitui.enable = true;

    helix.enable = true;

    nixvim = import ../../shared/nixvim.nix { inherit lib pkgs; } // {
      enable = true;
    };

    nix-init = {
      enable = true;
      settings = {
        maintainers = [ "nim65s" ];
        access-tokens = {
          "github.com" = {
            command = [
              "rbw"
              "get"
              "github-token"
            ];
          };
        };
      };
    };

    notmuch.enable = true;

    nushell.enable = true;

    offlineimap.enable = true;

    starship = {
      settings.vcs.order = [
        "jj"
        "git"
      ];
    };

    thunderbird = {
      enable = config.nim-home.gui;
      profiles = {
        nim = {
          isDefault = true;
          settings = {
            "extensions.activeThemeID" = "{f6d05f0c-39a8-5c4d-96dd-4852202a8244}";
            "mail.identity.default.compose_html" = 1;
            "mail.pane_config.dynamic" = lib.mkDefault 2;
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
        ttnn = {
          settings = {
            "extensions.activeThemeID" = "{f6d05f0c-39a8-5c4d-96dd-4852202a8244}";
            "mail.identity.default.compose_html" = 1;
            "mail.pane_config.dynamic" = lib.mkDefault 2;
            "mail.server.default.check_all_folders_for_new" = true;
            "mail.uidensity" = 0;
            "mail.uifontsize" = 10;
          };
        };
      };
    };

  };

  services = {
    nim-sync.enable = true;
  };

  stylix = {
    autoEnable = true;
  };

  systemd.user = {
    services = {
      git-objects-cache = {
        Service = {
          Type = "oneshot";
          ExecStart = lib.getExe pkgs.git-objects-cache;
        };
        Unit.Description = "sync git objects-cache";
      };
    };
    timers = {
      git-objects-cache = {
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          OnCalendar = "daily";
          Unit = "git-objects-cache.service";
        };
        Unit.Description = "sync git objects-cache";
      };
    };
  };
}
