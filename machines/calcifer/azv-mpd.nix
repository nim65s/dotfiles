{
  lib,
  ...
}:
let
  fifo = "/run/mopidy-snapserver.fifo";
in
{
  imports = [
    ../../nixos/mopidy.nix
  ];

  networking.firewall = {
    interfaces.lan1.allowedTCPPorts = [
      6600
      6680
    ];
  };

  services = {
    mopidy.settings = {
      audio.output = "audioresample ! audioconvert ! audio/x-raw,rate=48000,channels=2,format=S16LE ! filesink location=${fifo}";
      mpd.hostname = "::";
      m3u.playlists_dir = "/var/lib/mopidy/Playlists";
    };

    nim-mopidy = {
      enable = true;
      enable-nixos = true;
    };

    snapserver = {
      enable = true;
      settings = {
        stream.source = "${fifo}?name=mopidy";
        http.enable = true;
      };
    };
  };

  systemd = {
    services = {
      mopidy.after = [ "systemd-tmpfiles-setup.service" ];
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
  };
}
