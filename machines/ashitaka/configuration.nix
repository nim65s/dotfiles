{ ... }:
{
  imports = [
    ../../modules/disko-zfs.nix
    ../../modules/display.nix
    ../../modules/nim.nix
    ../../modules/nvidia.nix
    ../../modules/remote-decrypt.nix
    ../../modules/shared.nix
    ../../modules/steam.nix
    ../../modules/stylix.nix
    ../../modules/x86_64-linux.nix
  ];

  clan.core.networking = {
    targetHost = "root@192.168.8.238";
    zerotier.controller.enable = true;
  };

  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-eui.0025385b4140cf80";
  home-manager.users.user = import ./home.nix;

  networking = {
    defaultGateway = {
      address = "192.168.8.1";
      interface = "enp3s0";
    };
    interfaces = {
      enp3s0 = {
        ipv4.addresses = [
          {
            address = "192.168.8.238";
            prefixLength = 24;
          }
        ];
      };
      "tinc.mars".ipv4.addresses = [
        {
          address = "10.0.55.205";
          prefixLength = 24;
        }
      ];
    };
  };

  stylix.image = ../../bg/ashitaka-3.jpg;
}
