{
  config,
  lib,
  ...
}:
let
  cfg = config.services.home-assistant.config;
in
{
  services.home-assistant = {
    enable = true;
    configWritable = true; # only for now, will be overwritten
    config = {
      homeassistant = {
        name = "Azv";
        external_url = "http://${cfg.http.server_host}";
        internal_url = "http://${cfg.http.server_host}:${toString cfg.http.server_port}";
      };
      http = {
        use_x_forwarded_for = true;
        server_host = "home-assistant.m";
        trusted_proxies = [
          "::1"
          "127.0.0.1"
          (lib.removeSuffix "\n" config.clan.core.vars.generators.mycelium.files.ip.value)
        ];
      };
    };
    extraPackages = ps: [
      ps.hatasmota
      ps.paho-mqtt
    ];
  };
}
