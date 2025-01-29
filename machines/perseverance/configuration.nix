{ pkgs, ... }:
{
  imports = [
    ../../modules/disko.nix
    ../../modules/nim.nix
    ../../modules/shared.nix
    ../../modules/stylix.nix
    ../../modules/wifi.nix
  ];

  clan.core.networking.targetHost = "root@192.168.1.10";
  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-LDLC_F8+M.2_120_09292220C0589";
  environment.sessionVariables.ROVER = "perseverance";
  home-manager.users.user = import ../../modules/nim-home-minimal.nix;
  networking = {
    defaultGateway = {
      address = "192.168.1.1";
      interface = "wlan0";
    };
    firewall.allowedTCPPorts = [
      80
      3000
      8000
    ];
    interfaces = {
      wlan0 = {
        ipv4.addresses = [
          {
            address = "192.168.1.10";
            prefixLength = 24;
          }
        ];
      };
      "tinc.mars".ipv4.addresses = [
        {
          address = "10.0.55.10";
          prefixLength = 24;
        }
      ];
    };
  };

  services = {
    logind = {
      killUserProcesses = true;
      powerKey = "poweroff";
    };
    nginx = {
      enable = true;
      virtualHosts."perseverance" = {
        root = "/var/www/perseverance";
        extraConfig = "autoindex on;";
      };
    };
  };

  stylix.image = ../../bg/perseverance.jpeg;

  systemd.services = {
    calibration = {
      description = "Rover calibration UI";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 5;
        WorkingDirectory = "/home/nim/roveros";
        User = "nim";
        ExecStart = "/run/current-system/sw/bin/nix develop --command ./manage.py runserver 0.0.0.0:8000";
        Environment = [
          "PYTHONUNBUFFERED=true"
          "ROVER=perseverance"
        ];
        TimeoutStopSec = 15;
      };
      wantedBy = [ "multi-user.target" ];
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
    roveros = {
      description = "Rover Main AI";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 5;
        WorkingDirectory = "/home/nim/roveros";
        User = "nim";
        ExecStart = "/home/nim/roveros/target/release/roveros-uia";
        Environment = "RUST_BACKTRACE=1";
        TimeoutStopSec = 15;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
