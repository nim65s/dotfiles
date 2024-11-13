{ config, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  clan.core.networking = {
    targetHost = "root@192.168.8.209";
    zerotier.networkId = builtins.readFile (
      config.clan.core.clanDir + "/machines/loon/facts/zerotier-network-id"
    );
  };
  console.keyMap = "fr-bepo";
  networking.hostId = "0df1ec23";
  disko.devices.disk.main.device = "/dev/disk/by-id/wwn-0x500a0751210f7632";
  services.getty.autologinUser = "nim";
  system.stateVersion = "24.11"; # Did you read the comment?
}
