{
  pkgs,
  ...
}:
{
  imports = [
    ../../nixos/disko/ext4-swap-tmpfs.nix
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
    device = "/dev/disk/by-id/ata-WDC_WD5000LPVX-08V0TT5_WD-WXA1A25E1ECV";
    name = "main-5960c9943c8b84f2d5158243d19fb2fc";
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
    # group = "kids";
  };

}
