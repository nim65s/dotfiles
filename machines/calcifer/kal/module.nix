{
  config,
  pkgs,
  ...
}:
let
  moduleName = "kal";
  tokenEnv = "KAL_INFLUXDB_TOKEN";
in
{
  clan.core.vars.generators.kal-influxdb = {
    files =
      let
        f = {
          secret = true;
          owner = moduleName;
          group = moduleName;
          mode = "0440";
        };
      in
      {
        token = f;
        token-env = f;
        password = f;
      };
    runtimeInputs = [ pkgs.pwgen ];
    script = ''
      pwgen -B 42 -c 1 > $out/token
      echo "${tokenEnv}=$(cat $out/token)" > $out/token-env
      pwgen -B 42 -c 1 > $out/password
    '';
  };
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
            secureJsonData.token = "$__file{${config.clan.core.vars.generators.kal-influxdb.files.token.path}}";
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
          tokenFile = config.clan.core.vars.generators.kal-influxdb.files.token.path;
          passwordFile = config.clan.core.vars.generators.kal-influxdb.files.password.path;
        };
      };
    };

    nginx = {
      enable = true;
      virtualHosts."${moduleName}.saurel.me" = {
        serverAliases = [
          "calcifer.azv"
          "kal.azv"
          "kal.m"
        ];
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
      extraOptions = [
        "--cfg=plugins/storage_manager/volumes/influxdb2/private/token:\${${tokenEnv}}"
        "--cfg=plugins/storages/${moduleName}/volume/private/token:\${${tokenEnv}}"
      ];
      settings.plugins = {
        mqtt = { };
        rest.http_port = 8000;
        storage_manager = {
          volumes.influxdb2 = {
            url = "http://localhost:8086";
            private = {
              org_id = moduleName;
            };
          };
          storages."${moduleName}" = {
            key_expr = "kal/**";
            volume = {
              id = "influxdb2";
              db = moduleName;
              private = {
                org_id = moduleName;
              };
            };
          };
        };
      };
    };

  };

  systemd.services.zenohd = {
    after = [ "influxdb2.service" ];
    serviceConfig.EnvironmentFile = config.clan.core.vars.generators.kal-influxdb.files.token-env.path;
  };

  users.groups."${moduleName}" = { };
  users.users."${moduleName}" = {
    description = "kal user";
    home = "/var/lib/${moduleName}";
    createHome = true;
    group = moduleName;
    isSystemUser = true;
  };
  users.users.grafana.extraGroups = [ moduleName ];
  users.users.influxdb2.extraGroups = [ moduleName ];
}
