{ config, ... }:
{
  imports = [

  ];
  clan.core.networking = {
    zerotier.networkId = builtins.readFile (
      config.clan.core.clanDir + "/machines/loon/facts/zerotier-network-id"
    );
  };
  console.keyMap = "fr-bepo";
  #networking.hostId = "46dec12f";
  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-eui.0025385b4140cf80";
  services.getty.autologinUser = "nim";
  system.stateVersion = "24.11"; # Did you read the comment?
}
