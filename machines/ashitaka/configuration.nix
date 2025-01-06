{
  imports = [
    ../../modules/disko.nix
    ../../modules/shared.nix
  ];

  clan.core.networking.targetHost = "root@192.168.8.238";
  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-eui.0025385b4140cf80";
  #clan.core.networking.zerotier.controller.enable = true;

  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
    };
  };
  hardware.nvidia.open = true;

  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };

  networking = {
    interfaces.enp3s0 = {
      ipv4.addresses = [{
        address = "192.168.8.238";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.8.1";
      interface = "enp3s0";
    };
  };
}
