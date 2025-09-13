{ config, ... }:
let
  ip = "30";
  disk = "nvme-LDLC_F8+M.2_120_09292220C0619";
  name = "main-fb47a971d4ce46d8b3a62cf345b04b2a";
in
{
  imports = [
    ../../modules/rovers.nix
  ];

  clan.core.networking.targetHost = "root@192.168.1.${ip}";
  disko.devices.disk.main = {
    inherit name;
    device = "/dev/disk/by-id/${disk}";
  };
  environment.sessionVariables.ROVER = config.system.name;
  networking = {
    interfaces = {
      wlan0 = {
        ipv4.addresses = [
          {
            address = "192.168.1.${ip}";
            prefixLength = 24;
          }
        ];
      };
      "tinc.mars".ipv4.addresses = [
        {
          address = "10.0.55.${ip}";
          prefixLength = 24;
        }
      ];
    };
  };

  services = {
    nginx = {
      virtualHosts."${config.system.name}" = {
        root = "/var/www/${config.system.name}";
        extraConfig = "autoindex on;";
      };
    };
    roversap = {
      enable = true;
      subnet = 30;
      upstream = "TODO";
    };
  };

  stylix.image = ../../bg/perseverance.jpeg;

  systemd.services = {
    calibration = {
      serviceConfig = {
        Environment = [
          "PATH=/run/current-system/sw/bin"
          "PYTHONUNBUFFERED=true"
          "ROVER=${config.system.name}"
        ];
      };
    };
    perseverance = {
      description = "Rover Python AI";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 5;
        WorkingDirectory = "/home/nim/roveros/perseverance";
        User = "nim";
        ExecStart = "/run/current-system/sw/bin/nix develop --command flask run";
        Environment = [
          "PATH=/run/current-system/sw/bin"
          "PYTHONUNBUFFERED=true"
        ];
        TimeoutStopSec = 15;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
