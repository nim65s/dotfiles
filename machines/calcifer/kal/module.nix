{
  config,
  pkgs,
  ...
}:
let
  moduleName = "kal";
  secretInfluxDBToken = "todo";
in
{
  services = {

    grafana = {
      enable = true;
      provision = {
        enable = true;
        dashboards.settings.providers = [
          {
            options.path = ./dashboards;
          }
        ];
        datasources.settings.datasources = [
          {
            name = "InfluxDB";
            type = "influxdb";
            isDefault = true;
            access = "proxy";
            url = "http://localhost:8086";
            jsonData = {
              version = "Flux";
              organization = moduleName;
              defaultBucket = moduleName;
            };
            secureJsonData.token = secretInfluxDBToken;
          }
        ];
      };
    };

    influxdb2 = {
      enable = true;
      provision = {
        enable = true;
        initialSetup = {
          bucket = moduleName;
          organization = moduleName;
          tokenFile = pkgs.writeText "token" secretInfluxDBToken;
          passwordFile = pkgs.writeText "password" "not-${secretInfluxDBToken}";
        };
      };
    };

    nginx = {
      enable = true;
      virtualHosts.localhost = {
        default = true;
        locations."/" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass =
            let
              grafana = config.services.grafana.settings.server;
            in
            "http://${grafana.http_addr}:${toString grafana.http_port}";
        };
      };
    };

    zenohd = {
      enable = true;
      plugins = [ pkgs.zenoh-plugin-mqtt ];
      backends = [ pkgs.zenoh-backend-influxdb ];
      settings.plugins = {
        mqtt = { };
        rest.http_port = 8000;
        storage_manager = {
          volumes.influxdb2 = {
            url = "http://localhost:8086";
            private = {
              org_id = moduleName;
              token = secretInfluxDBToken;
            };
          };
          storages."${moduleName}" = {
            key_expr = "kal/**";
            volume = {
              id = "influxdb2";
              db = moduleName;
              private = {
                org_id = moduleName;
                token = secretInfluxDBToken;
              };
            };
          };
        };
      };
    };

  };

  systemd.services.zenohd.after = [ "influxdb2.service" ];
}
