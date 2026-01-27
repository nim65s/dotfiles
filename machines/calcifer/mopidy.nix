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
      mpd.hostname = "::";
      m3u.playlists_dir = "/var/lib/mopidy/Playlists";
    };

    nim-mopidy = {
      enable = true;
      enable-nixos = true;
    };
  };
}
