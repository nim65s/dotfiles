{
  imports = [
    ../../modules/disko-zfs.nix
    ../../modules/nim.nix
    ../../modules/shared.nix
    ../../modules/stylix.nix
    ../../modules/wifi.nix
  ];

  clan.core.networking.targetHost = "root@192.168.8.105";
  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-eui.0025388b11b2bd16";
  stylix.image = ../../bg/yupa.jpg;
}
