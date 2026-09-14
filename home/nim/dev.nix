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
    cargo
    cmeel
    colcon
    dockgen
    ffmpeg
    gazebros2nix
    hugo
    jrl-cmakemodules-scripts
    khal
    nb
    nixpkgs-review
    plantuml
    qemu
    templup
    vcs2l
    khard
    cargo-binstall
    cargo-release
    ros2cli
    rustc
    vdirsyncer
  ];

  programs = {
    git.settings.maintenance.repo = [
      "${config.home.homeDirectory}/dotfiles"
      "${config.home.homeDirectory}/local/gepetto/gazebros2nix"
      "${config.home.homeDirectory}/local/gepetto/nix"
      "${config.home.homeDirectory}/local/lopsided98/nix-ros-overlay"
      "${config.home.homeDirectory}/local/NixOS/nixpkgs"
      "${config.home.homeDirectory}/local/pi2/homes"
    ];
    helix.enable = true;
    notmuch.enable = true;
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
          OnActiveSec = "daily";
          OnUnitActiveSec = "daily";
          Unit = "git-objects-cache.service";
        };
        Unit.Description = "sync git objects-cache";
      };
    };
  };
}
