{
  imports = [
    ../../modules/rovers.nix
  ];

  clan.core.networking.targetHost = "root@192.168.1.30";
  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-LDLC_F8+M.2_120_09292220C0619";
  environment.sessionVariables.ROVER = "perseverance";
  networking = {
    interfaces = {
      wlan0 = {
        ipv4.addresses = [
          {
            address = "192.168.1.30";
            prefixLength = 24;
          }
        ];
      };
      "tinc.mars".ipv4.addresses = [
        {
          address = "10.0.55.30";
          prefixLength = 24;
        }
      ];
    };
  };

  services = {
    nginx = {
      virtualHosts."perseverance" = {
        root = "/var/www/perseverance";
        extraConfig = "autoindex on;";
      };
    };
  };

  stylix.image = ../../bg/perseverance.jpeg;

  systemd.services = {
    calibration = {
      serviceConfig = {
        Environment = [
          "PYTHONUNBUFFERED=true"
          "ROVER=perseverance"
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
        Environment = "PYTHONUNBUFFERED=true";
        TimeoutStopSec = 15;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
