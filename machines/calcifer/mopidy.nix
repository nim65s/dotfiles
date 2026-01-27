{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../nixos/mopidy.nix
  ];

  clan.core.vars.generators = {
    nginx-mopidy = {
      files.conf.owner = "nginx";
      files.password.secret = true;
      runtimeInputs = [
        pkgs.apacheHttpd
        pkgs.pwgen
      ];
      script = ''
        pwgen -B 42 -c 1 > $out/password
        htpasswd -B -c $out/conf nim $(cat $out/password)
      '';
    };
  };

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

    nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      virtualHosts."mpd.saurel.me" = {
        addSSL = true;
        enableACME = true;
        locations."/" = {
          proxyWebsockets = true;
          proxyPass = "http://localhost:6680";
          basicAuthFile = config.clan.core.vars.generators.nginx-mopidy.files.conf.path;
        };
      };
    };

    nim-mopidy = {
      enable = true;
      enable-nixos = true;
    };
  };
}
