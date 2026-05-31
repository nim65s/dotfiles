{
  pkgs,
  ...
}:
{
  imports = [
    ../../nixos/disko/zfs-swap.nix
    ../../nixos/display.nix
    ../../nixos/laptop.nix
    ../../nixos/shared.nix
    ../../nixos/nixos.nix
    ../../nixos/systemd-boot.nix
  ];

  console = {
    useXkbConfig = false;
    keyMap = "fr";
  };
  disko.devices.disk.main = {
    device = "/dev/disk/by-id/ata-KINGSTON_SM2280S3G2480G_50026B7264065871";
    name = "main-15960c9943c8b84f2d5158243d19fbf1";
  };
  home-manager.users = {
    nim = import ../../home/nim/main.nix;
    doud = import ../../home/doud.nix;
  };
  programs.waybar.enable = false;
  services = {
    displayManager = {
      autoLogin.user = "doud";
      defaultSession = null;
    };
    desktopManager.plasma6.enable = true;
    xserver.xkb.variant = "";
  };
  stylix.image = ../../bg/hattori.jpg;
  users.users.doud = {
    isNormalUser = true;
    shell = pkgs.fish;
  };

  fileSystems = {
    "/mnt" = {
      device = "/dev/disk/by-id/ata-WDC_WD5000LPVX-08V0TT5_WD-WXA1A25E1ECV-part4";
      fsType = "ext4";
    };
  };

}
