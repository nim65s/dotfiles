{
  imports = [
    ../../modules/disko.nix
    ../../modules/nim.nix
    ../../modules/shared.nix
    ../../modules/stylix.nix
    ../../modules/wifi.nix
  ];

  clan.core.networking.targetHost = "root@10.0.55.20";
  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-LDLC_F8+M.2_120_09292220C0868";
  environment.sessionVariables.ROVER = "zhurong";

  networking = {
    firewall.allowedTCPPorts = [ 80 ];
    interfaces."tinc.mars".ipv4.addresses = [
      {
        address = "10.0.55.20";
        prefixLength = 24;
      }
    ];
  };

  services.nginx = {
    enable = true;
    virtualHosts."zhurong" = {
      root = "/var/www/zhurong";
      extraConfig = "autoindex on;";
    };
  };

  stylix.image = ../../bg/zhurong.jpg;

  systemd.services = {
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
