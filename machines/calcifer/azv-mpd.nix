{
  ...
}:
let
  fifo = "/run/mopidy-snapcast.fifo";
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

  systemd.tmpfiles.rules = [
    "p ${fifo} 0640 mopidy snapcast - -"
  ];

  users.groups.snapcast = { };
  users.users.mopidy.extraGroups = [ "snapcast" ];
}
