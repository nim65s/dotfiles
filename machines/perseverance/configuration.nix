{ pkgs, ... }:
{
  imports = [
    ../../modules/disko.nix
    ../../modules/nim.nix
    ../../modules/shared.nix
    ../../modules/stylix.nix
    ../../modules/wifi.nix
  ];

  clan.core.networking.targetHost = "root@192.168.1.104";
  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-LDLC_F8+M.2_120_09292220C0589";
  stylix.image = ../../bg/perseverance.jpeg;

  networking = {
    firewall.allowedTCPPorts = [ 80 ];
    interfaces."tinc.mars".ipv4.addresses = [ { address = "10.0.55.10"; prefixLength = 24; } ];
  };

  services.nginx = {
    enable = true;
    virtualHosts."perseverance" = {
      root = "/var/www/perseverance";
      extraConfig = "autoindex on;";
    };
  };
}
