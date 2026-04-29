{
  lib,
  pkgs,
  ...
}:
let
  fifo = "/run/mopidy-snapserver.fifo";
in
{
  imports = [
    ../../nixos/small.nix
    ../../nixos/mopidy.nix
    ../../nixos/nas.nix
  ];

  services.displayManager = {
    autoLogin.user = "kodi";
    sddm.enable = false;
    defaultSession = "kodi";
  };

  users.extraUsers.kodi.isNormalUser = true;
  home-manager.users.kodi = import ./home.nix;
  home-manager.users.nim.nim-home.gui = false;

  services.xserver = {
    enable = true;
    desktopManager.kodi.enable = true;
    displayManager = {
      lightdm.greeter.enable = false;
    };
  };

  networking.firewall.allowedTCPPorts = [
    8080
    9090
    9777
    1704 # snapcast
    1780 # snapserver
    6600 # mpd
    6680 # mpd http
  ];

  services = {
    mopidy.settings = {
      audio.output = "audioresample ! audioconvert ! audio/x-raw,rate=48000,channels=2,format=S16LE ! filesink location=${fifo}";
      mpd.hostname = "::";
      m3u.playlists_dir = "/var/lib/mopidy/Playlists";
      http.hostname = "spare.w";
    };

    nim-mopidy = {
      enable = true;
      enable-nixos = true;
    };

    snapserver = {
      enable = true;
      settings = {
        stream.source = "pipe://${fifo}?name=mopidy";
        http.enabled = true;
      };
    };
  };

  systemd = {
    services = {
      mopidy.after = [ "systemd-tmpfiles-setup.service" ];
      snapclient = {
        serviceConfig = {
          User = "snapserver";
          Group = "snapserver";
          ExecStart = "${lib.getExe' pkgs.snapcast "snapclient"} tcp://localhost";
        };
      };
      snapserver = {
        serviceConfig = {
          DynamicUser = lib.mkForce false;
          User = "snapserver";
          Group = "snapserver";
        };
      };
    };
    tmpfiles.rules = [
      "p ${fifo} 0640 mopidy snapserver - -"
    ];
  };

  users.groups.snapserver = { };
  users.users.mopidy.extraGroups = [ "snapserver" ];
  users.users.snapserver = {
    isSystemUser = true;
    group = "snapserver";
    extraGroups = [ "audio" ];
  };
}
