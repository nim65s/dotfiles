{
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
    notmuch.enable = true;
  };

  services = {
    nim-sync.enable = true;
  };
}
