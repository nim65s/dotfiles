{
  lib,
  config,
  pkgs,
  ...
}:
{
  clan.core.vars.generators = {
    azv-nginx = {
      files.conf.owner = "nginx";
      files.password.secret = true;
      runtimeInputs = [
        pkgs.apacheHttpd
        pkgs.pwgen
      ];
      script = ''
        pwgen -B 42 -c 1 > $out/password
        htpasswd -bBc $out/conf nim $(cat $out/password)
      '';
    };
  };

  security.acme.certs =
    let
      atjoin =
        {
          name,
          host ? "saurel.me",
        }:
        lib.concatStringsSep "@" [
          name
          host
        ];
    in
    {
      "calcifer.saurel.me".email = atjoin { name = "guilhem+calcifer-calcifer"; };
      "iot.saurel.me".email = atjoin { name = "guilhem+calcifer-iot"; };
      "mpd.saurel.me".email = atjoin { name = "guilhem+calcifer-mpd"; };
      "snap.saurel.me".email = atjoin { name = "guilhem+calcifer-snap"; };
    };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts =
      let
        azvProxy =
          {
            source,
            private ? true,
          }:
          {
            forceSSL = true;
            enableACME = true;
            locations."/" = {
              proxyWebsockets = true;
              proxyPass = source;
            }
            // lib.optionalAttrs private {
              basicAuthFile = config.clan.core.vars.generators.azv-nginx.files.conf.path;
              extraConfig = ''
                satisfy any;

                allow 127.0.0.1;
                allow ::1;
                allow 192.168.0.0/24;
                allow 192.168.1.0/24;
                allow 192.168.2.0/24;
                allow 192.168.3.0/24;
                allow fc00::/7;
                allow fe80::/10;
                allow 2a01:e0a:941:c1d0::/64;
                allow 2a01:e0a:941:c1d1::/64;
                allow 2a01:e0a:941:c1d2::/64;
                allow 2a01:e0a:941:c1d3::/64;
                allow 2a01:e0a:941:c1d4::/64;

                deny all;
              '';
            };
          };
        grafana = config.services.grafana.settings.server;
      in
      {
        "calcifer.saurel.me" = {
          default = true;
          forceSSL = true;
          enableACME = true;
          globalRedirect = "https://www.laas.fr/fr/annuaire/gsaurel";
        };

        "iot.saurel.me" = azvProxy {
          source = "http://${grafana.http_addr}:${toString grafana.http_port}";
          private = false;
        };
        "mpd.saurel.me" = azvProxy {
          source = "http://spare.w:6680";
        };
        "snap.saurel.me" = azvProxy {
          source = "http://spare.w:${toString config.services.snapserver.settings.http.port}";
        };
      };

  };
}
