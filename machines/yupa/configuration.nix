{
  imports = [
    ../../modules/disko-zfs.nix
    ../../modules/nim.nix
    ../../modules/shared.nix
    ../../modules/stylix.nix
    ../../modules/wifi.nix
  ];

  clan.core.networking.targetHost = "root@192.168.1.185";
  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-eui.0025388b11b2bd16";
  networking.interfaces."tinc.mars".ipv4.addresses = [
    {
      address = "10.0.55.203";
      prefixLength = 24;
    }
  ];
  stylix.image = ../../bg/yupa.jpg;
}
