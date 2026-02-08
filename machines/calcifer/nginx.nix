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
    commonHttpConfig = ''
      geo $is_lan {
        default 0;

        127.0.0.1/32 1;
        ::1/128      1;

        192.168.0.0/24 1;
        192.168.1.0/24 1;
        192.168.2.0/24 1;
        192.168.3.0/24 1;

        fe80::/10 1;

        2a01:e0a:989:7190::/64 1;
        2a01:e0a:989:7191::/64 1;
        2a01:e0a:989:7192::/64 1;
        2a01:e0a:989:7193::/64 1;
      }
    '';

    virtualHosts =
      let
        azvProxy = _source: {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyWebsockets = true;
            extraConfig = ''
              satisfy any;
              if ($is_lan = 1) {
                  allow all;
              }
              deny all;
            '';
            basicAuthFile = config.clan.core.vars.generators.azv-nginx.files.conf.path;
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

        "iot.saurel.me" = azvProxy "http://${grafana.http_addr}:${toString grafana.http_port}";
        "mpd.saurel.me" = azvProxy "http://localhost:6680";
        "snap.saurel.me" = azvProxy "http://localhost:${config.services.snapserver.settings.http.port}";
      };

  };
}
