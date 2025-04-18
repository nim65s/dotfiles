{ config, ... }:
let
  ip = "20";
  disk = "nvme-LDLC_F8+M.2_120_09292220C0868";
in
{
  imports = [
    ../../modules/rovers.nix
  ];

  clan.core.networking.targetHost = "root@192.168.1.${ip}";
  disko.devices.disk.main.device = "/dev/disk/by-id/${disk}";
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
  };

  stylix.image = ../../bg/zhurong.jpg;

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
  };
}
