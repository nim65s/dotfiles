{
  config,
  pkgs,
  ...
}:
let
  logsServerAddr = "ashitaka.m";
  lokiPort = 3100;
  lokiConfigFile = "loki.yaml";
in
{
  environment.etc = {
    # ref. https://grafana.com/docs/loki/latest/configure/examples/configuration-examples/#1-local-configuration-exampleyaml
    "${lokiConfigFile}".source = (pkgs.formats.yaml { }).generate lokiConfigFile {
      "auth_enabled" = false;
      "server" = {
        "http_listen_port" = lokiPort;
      };
      "common" = {
        "ring" = {
          "instance_addr" = logsServerAddr;
          "kvstore" = {
            "store" = "inmemory";
          };
        };
        "replication_factor" = 1;
        "path_prefix" = "/tmp/loki";
      };
      "schema_config" = {
        "configs" = [
          {
            "from" = "2020-05-15";
            "store" = "tsdb";
            "object_store" = "filesystem";
            "schema" = "v13";
            "index" = {
              "prefix" = "index_";
              "period" = "24h";
            };
          }
        ];
      };
      "storage_config" = {
        "filesystem" = {
          "directory" = "/tmp/loki/chunks";
        };
      };
    };
  };

  services = {
    grafana = {
      enable = true;
      settings.server = {
        root_url = "%(protocol)s://%(domain)s:%(http_port)s/grafana/";
        serve_from_sub_path = true;
      };
      provision = {
        enable = true;
        dashboards.settings.providers = [
          {
            options.path = ./dashboards;
          }
        ];
        datasources.settings.datasources = [
          {
            name = "Loki";
            type = "loki";
            access = "proxy";
            url = "http://${logsServerAddr}:${toString lokiPort}";
          }
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://${logsServerAddr}:${toString config.services.prometheus.port}";
            isDefault = true;
          }
        ];
      };
    };
    loki = {
      enable = true;
      configFile = "/etc/${lokiConfigFile}";
    };
    nginx = {
      enable = true;
      virtualHosts."${logsServerAddr}" = {
        default = true;
        locations =
          let
            grafanaHost = config.services.grafana.settings.server.http_addr;
            grafanaPort = config.services.grafana.settings.server.http_port;
            proxy = proxyPass: {
              proxyPass = proxyPass;
              extraConfig = ''
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;

                proxy_set_header Host $host;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Real-IP $remote_addr;
              '';
            };
          in
          {
            "/grafana" = proxy "http://${grafanaHost}:${toString grafanaPort}";
          };
      };
    };
    prometheus = {
      enable = true;
      exporters = {
        nginx.enable = true;
      };
      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [
            {
              targets =
                let
                  port = toString config.services.prometheus.exporters.node.port;
                in
                [
                  "ashitaka.m:${port}"
                  "hattori.m:${port}"
                  "yupa.m:${port}"
                ];
            }
          ];
        }
      ];
    };
  };

  networking.firewall.extraCommands = ''
    ip46tables -A nixos-fw -i mycelium -p tcp -m tcp --dport ${toString lokiPort} -m comment --comment alloy-loki -j nixos-fw-accept"
  '';
}
