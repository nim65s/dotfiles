{
  imports = [
    ../../modules/disko-zfs.nix
    ../../modules/display.nix
    ../../modules/shared.nix
    ../../modules/nixos.nix
    ../../modules/wifi.nix
    ../../modules/x86_64-linux.nix
  ];

  disko.devices.disk.main.device = "/dev/disk/by-id/wwn-0x500a0751210f7632";
  home-manager.users.nim = import ../../modules/nim-home.nix;
  networking = {
    interfaces."tinc.mars".ipv4.addresses = [
      {
        address = "10.0.55.200";
        prefixLength = 24;
      }
    ];
  };
}
