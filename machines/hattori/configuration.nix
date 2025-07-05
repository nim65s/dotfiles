{ pkgs, ... }:
{
  imports = [
    ../../modules/disko-zfs.nix
    ../../modules/display.nix
    ../../modules/shared.nix
    ../../modules/nixos.nix
    ../../modules/x86_64-linux.nix
    # ../../modules/parental-control.nix
  ];

  console = {
    useXkbConfig = false;
    keyMap = "fr";
  };
  disko.devices.disk.main = {
    device = "/dev/disk/by-id/wwn-0x500a0751210f7632";
    name = "main-5960c9984f2d43c8b5158243d19fb2fc";
  };
  home-manager.users = {
    nim = import ../../modules/nim-home.nix;
    mimi = import ../../modules/mimi-home.nix;
  };
  networking = {
    interfaces."tinc.mars".ipv4.addresses = [
      {
        address = "10.0.55.200";
        prefixLength = 24;
      }
    ];
  };
  programs.waybar.enable = false;
  services = {
    displayManager = {
      autoLogin.user = "mimi";
      defaultSession = null;
    };
    desktopManager.plasma6.enable = true;
    xserver.xkb.variant = "";
  };
  stylix.image = ../../bg/hattori.jpg;
  users.users.mimi = {
    isNormalUser = true;
    shell = pkgs.fish;
    # group = "kids";
  };
}
