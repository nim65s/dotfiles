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
        "ashitaka.w" = {
          default = true;
        };
        # "grafana.w" = proxy grafana.http_addr grafana.http_port;
        "grafana.w" = proxy "localhost" grafana.http_port;
        "home-assistant.w" = proxy hass.server_host hass.server_port;
      };
  };
}
