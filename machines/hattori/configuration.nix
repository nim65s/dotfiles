{
  imports = [
    ../../modules/disko-zfs.nix
    ../../modules/nim.nix
    ../../modules/shared.nix
    ../../modules/stylix.nix
    ../../modules/wifi.nix
  ];

  clan.core.networking.targetHost = "root@192.168.8.185";
  disko.devices.disk.main.device = "/dev/disk/by-id/wwn-0x500a0751210f7632";
  networking = {
    interfaces."tinc.mars".ipv4.addresses = [ { address = "10.0.55.200"; prefixLength = 24; } ];
  };
}
