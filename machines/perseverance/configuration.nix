{ pkgs, ... }:
{
  imports = [
    ../../modules/disko.nix
    ../../modules/nim.nix
    ../../modules/shared.nix
    ../../modules/stylix.nix
    ../../modules/wifi.nix
  ];

  clan.core.networking.targetHost = "root@10.0.55.10";
  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-LDLC_F8+M.2_120_09292220C0589";
  environment.sessionVariables.ROVER = "perseverance";

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

  stylix.image = ../../bg/perseverance.jpeg;

  systemd.services = {
    perseverance = {
      description = "Rover Python AI";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 5;
        WorkingDirectory = "/home/nim/roveros/perseverance";
        User = "nim";
        ExecStart = "flask run";
        Environment = "PYTHONUNBUFFERED=true";
        TimeoutStopSec = 15;
      };
      wantedBy = [ "multi-user.target" ];
    };
    roveros = {
      description = "Rover Main AI";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 5;
        WorkingDirectory = "/home/nim/roveros";
        User = "nim";
        ExecStart = "./target/release/roveros-uia";
        Environment = "RUST_BACKTRACE=1";
        TimeoutStopSec = 15;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
