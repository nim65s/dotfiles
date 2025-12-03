{ config, ... }:
let
  ip = "20";
  disk = "nvme-LDLC_F8+M.2_120_09292220C0868";
  name = "main-9a85e7cff1e9472f81f1bdd94431815c";
in
{
  imports = [
    ../../nixos/rovers.nix
  ];

  clan.core.networking.targetHost = "root@192.168.1.${ip}";
  disko.devices.disk.main = {
    inherit name;
    device = "/dev/disk/by-id/${disk}";
  };
  environment.sessionVariables.ROVER = config.system.name;
  networking = {
    interfaces = {
      eno1 = {
        ipv4.addresses = [
          {
            address = "192.168.2.${ip}";
            prefixLength = 24;
          }
        ];
        useDHCP = false;
      };
      wlp0s20f3 = {
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
      subnet = 20;
      upstream = "wlp0s20f3";
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
