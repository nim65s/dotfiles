{
  imports = [
    ../../modules/disko-zfs.nix
    ../../modules/display.nix
    ../../modules/shared.nix
    ../../modules/stylix.nix
    ../../modules/wifi.nix
    ../../modules/x86_64-linux.nix
  ];

  clan.core.networking.targetHost = "root@10.0.55.203";
  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-eui.0025388b11b2bd16";
  home-manager.users.nim = import ../../modules/nim-home.nix;
  networking.interfaces."tinc.mars".ipv4.addresses = [
    {
      address = "10.0.55.203";
      prefixLength = 24;
    }
  ];
  stylix.image = ../../bg/yupa.jpg;
}
