{
  pkgs,
  ...
}:
{
  imports = [
    ./accounts.nix
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
  ];
  programs.notmuch.enable = true;
}
