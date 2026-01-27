{
  config,
  lib,
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
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "calcifer.saurel.me" = {
          default = true;
          addSSL = true;
          enableACME = true;
          globalRedirect = "https://www.laas.fr/fr/annuaire/gsaurel";
        };
        "iot.saurel.me" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyWebsockets = true;
            proxyPass =
              let
                grafana = config.services.grafana.settings.server;
              in
              "http://${grafana.http_addr}:${toString grafana.http_port}";
          };
        };
      };
    };

    udev.extraRules = ''
      SUBSYSTEM=="gpio", KERNEL=="gpiochip*", MODE="0660", GROUP="gpio"
    '';

    zenohd = {
      enable = true;
      plugins = [ pkgs.zenoh-plugin-mqtt ];
      backends = [ pkgs.zenoh-backend-influxdb ];
      extraOptions = [
        "--cfg=plugins/storage_manager/volumes/influxdb2/private/org_id:'\"${moduleName}\"'"
        "--cfg=plugins/storage_manager/volumes/influxdb2/private/token:'\"\${${tokenEnv}}\"'"
        "--cfg=plugins/storages/${moduleName}/volume/private/org_id:'\"${moduleName}\"'"
        "--cfg=plugins/storages/${moduleName}/volume/private/token:'\"\${${tokenEnv}}\"'"
      ];
      settings.plugins = {
        mqtt = { };
        rest.http_port = 8000;
        storage_manager = {
          volumes.influxdb2 = {
            url = "http://localhost:8086";
          };
          storages."${moduleName}" = {
            key_expr = "kal/**";
            volume = {
              id = "influxdb2";
              db = moduleName;
            };
          };
        };
      };
    };

  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    interfaces.lan1.allowedTCPPorts = [
      1883
      7447
    ];
  };

  nixpkgs.overlays = [
    (final: _prev: {
      kal = final.callPackage ./package.nix { };
    })
  ];

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
    };

  systemd.services = {
    zenohd = {
      after = [ "influxdb2.service" ];
      requires = [ "influxdb2.service" ];
      serviceConfig.EnvironmentFile = config.clan.core.vars.generators.kal-influxdb.files.token-env.path;
    };

    "${moduleName}" = {
      description = pkgs.kal.meta.description;
      after = [ "zenohd.service" ];
      requires = [ "zenohd.service" ];

      before = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Environment = "RUST_LOG=debug";
        ExecStart = lib.getExe pkgs.kal;
        Type = "exec";
        Restart = "on-failure";
        RestartSec = 5;
        User = moduleName;
        Group = moduleName;
      };
    };
  };

  users.groups.gpio = { };
  users.groups."${moduleName}" = { };
  users.users."${moduleName}" = {
    description = "kal user";
    home = "/var/lib/${moduleName}";
    createHome = true;
    group = moduleName;
    isSystemUser = true;
    extraGroups = [ "gpio" ];
  };
  users.users.grafana.extraGroups = [ moduleName ];
  users.users.influxdb2.extraGroups = [ moduleName ];
}
