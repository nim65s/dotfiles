{
  config,
  ...
}:
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts =
      let
        grafana = config.services.grafana.settings.server;
        hass = config.services.home-assistant.config.http;
        proxy = host: port: {
          locations."/" = {
            proxyPass = "http://${host}:${toString port}";
            proxyWebsockets = true;
          };
        };
      in
      {
        "ashitaka.m" = {
          default = true;
        };
        # "grafana.m" = proxy grafana.http_addr grafana.http_port;
        "grafana.m" = proxy "localhost" grafana.http_port;
        "home-assistant.m" = proxy hass.server_host hass.server_port;
      };
  };
}
