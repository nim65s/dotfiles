{
  imports = [
    ../../modules/disko.nix
    ../../modules/shared.nix
    ../../modules/wifi.nix
  ];

  clan.core.networking.targetHost = "root@192.168.8.106";
  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-eui.0025388b11b2bd16";
}
