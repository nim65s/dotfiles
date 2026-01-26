{
  ...
}:
{
  imports = [
    ../bpi-r4/bpi-r4.nix
    ../../nixos/disko/ext4-swap.nix
    ../../nixos/mopidy.nix
    ../../nixos/nixos.nix
    ../../nixos/shared.nix
    ../../nixos/small.nix
    ./kal/module.nix
    ./dnsmasq.nix
    ./networking.nix
  ];

  disko.devices.disk.main = {
    device = "/dev/disk/by-id/nvme-eui.0025385b4140d4c7";
    name = "main-a0b291c142a29d9b41b9aaf8f398f426";
  };

  home-manager.users.nim = import ../../home/nim/minimal.nix;
  stylix.targets.console.colors.enable = false;
  services.getty.autologinUser = "root";
  catppuccin.tty.enable = false;
  system.autoUpgrade.enable = false;
  documentation.man.enable = false;
  services.fail2ban.enable = true;

  services.nim-mopidy.enable = true;
  services.nim-mopidy.enable-nixos = true;
}
