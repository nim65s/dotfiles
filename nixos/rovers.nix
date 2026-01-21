{
  imports = [
    ../nixos/disko/ext4.nix
    ../nixos/systemd-boot.nix
    ./shared.nix
    ./small.nix
    ./nixos.nix
    ./roversap.nix
  ];

  home-manager.users.nim = import ../home/nim/minimal.nix;

  networking = {
    defaultGateway = {
      address = "192.168.1.1";
    };
    firewall.allowedTCPPorts = [
      80
      3000
      8000
    ];
  };

  services = {
    logind = {
      settings.Login = {
        KillUserProcesses = true;
        HandlePowerKey = "poweroff";
      };
    };
    nginx = {
      enable = true;
    };
  };

  system.autoUpgrade.enable = false;

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
        Environment = [
          "PATH=/run/current-system/sw/bin"
          "RUST_BACKTRACE=1"
        ];
        TimeoutStopSec = 15;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
