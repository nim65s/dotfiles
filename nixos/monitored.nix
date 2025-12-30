{
  config,
  ...
}:
let
  logsServerAddr = "ashitaka.m";
  lokiPort = 3100;
  nodeExporterPort = toString config.services.prometheus.exporters.node.port;
in
{

  environment.etc = {
    "alloy/config.alloy".text = ''
      loki.source.journal "journald"  {
        forward_to = [loki.write.endpoint.receiver]
        labels = {
          host = "${config.networking.hostName}",
        }
        relabel_rules = loki.relabel.journal.rules
      }
      loki.relabel "journal" {
        forward_to = []
        rule {
          source_labels = ["__journal_priority_keyword"]
          target_label  = "level"
        }
        rule {
          source_labels = ["__journal__systemd_unit"]
          target_label  = "unit"
        }
      }
      loki.write "endpoint" {
        endpoint {
          url = "http://${logsServerAddr}:${toString lokiPort}/loki/api/v1/push"
        }
      }
    '';
  };

  services = {
    alloy = {
      enable = true;
    };
    prometheus = {
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [
            "logind"
            "systemd"
          ];
          firewallFilter = "-i mycelium -p tcp -m tcp --dport ${nodeExporterPort}";
          firewallRules = ''iifname "mycelium" tcp dport ${nodeExporterPort} counter accept'';
          openFirewall = true;
        };
      };
    };
  };
  systemd.services.alloy.serviceConfig.TimeoutStopSec = 2;
}
