{
  imports = [
    ../../modules/rovers.nix
  ];

  clan.core.networking.targetHost = "root@192.168.1.20";
  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-LDLC_F8+M.2_120_09292220C0868";
  environment.sessionVariables.ROVER = "zhurong";
  networking = {
    interfaces = {
      wlan0 = {
        ipv4.addresses = [
          {
            address = "192.168.1.20";
            prefixLength = 24;
          }
        ];
      };
      "tinc.mars".ipv4.addresses = [
        {
          address = "10.0.55.20";
          prefixLength = 24;
        }
      ];
    };
  };

  services = {
    nginx = {
      virtualHosts."zhurong" = {
        root = "/var/www/zhurong";
        extraConfig = "autoindex on;";
      };
    };
  };

  stylix.image = ../../bg/zhurong.jpg;

  systemd.services = {
    calibration = {
      serviceConfig = {
        Environment = [
          "PYTHONUNBUFFERED=true"
          "ROVER=zhurong"
        ];
      };
    };
  };
}
