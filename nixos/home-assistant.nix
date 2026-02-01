{
  config,
  lib,
  ...
}:
let
  cfg = config.services.home-assistant.config;
in
{
  networking.firewall.allowedTCPPorts = [ 80 ];

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

      mqtt =
        let
          id = "01KG5VHCBNVD4W8N6056D4Z495";
          device = {
            name = "kal";
            identifiers = [ id ];
          };
        in
        {
          # broker = "192.168.1.1";
          binary_sensor = [
            {
              inherit device;
              name = "Relay";
              device_class = "running";
              payload_off = "Off";
              payload_on = "On";
              state_topic = "kal/tele/daemon/relay";
              unique_id = "${id}_3fdc0af8251443aeb8c5d8fcc488b172";
              qos = 0.0;
            }
          ];

          sensor = [
            {
              inherit device;
              name = "Température";
              device_class = "temperature";
              state_topic = "kal/tele/tasmota_43D8FD/temperature";
              unique_id = "${id}_f04fc4fd6a364b4a8bcc8669347660c9";
              unit_of_measurement = "°C";
              qos = 0.0;
            }

            {
              inherit device;
              name = "Humidité";
              device_class = "moisture";
              state_topic = "kal/tele/tasmota_43D8FD/humidity";
              unique_id = "${id}_d2efa6a1d30c472c92deca1eac0ed58b";
              unit_of_measurement = "%";
              qos = 0.0;
            }
          ];

          select = [
            {
              inherit device;
              name = "Mode";
              options = [
                "On"
                "Off"
                "Auto"
              ];
              command_topic = "kal/cmnd/daemon/mode";
              state_topic = "kal/tele/daemon/mode";
              unique_id = "${id}_d8cc2439c7114cf09f9564e6ee8fbddc";
              qos = 0.0;
            }
          ];

        };

    };

    lovelaceConfigWritable = true;
    lovelaceConfig = {

      title = "Azv";
      views = [
        {
          title = "Kal";
          column_span = 1;
          cards = [

            {
              type = "tile";
              entity = "sensor.kal_temperature";
            }

            {
              type = "tile";
              entity = "sensor.kal_humidite";
            }

            {
              type = "tile";
              entity = "select.kal_mode";
              show_entity_picture = false;
              hide_state = false;
              vertical = true;
              features_position = "bottom";
              features = [
                {
                  type = "select-options";
                }
              ];
            }

            {
              type = "tile";
              entity = "binary_sensor.kal_relay";
              vertical = true;
              features_position = "bottom";
              grid_options = {
                columns = 6;
                rows = 3;
              };
            }

          ];
        }
      ];

    };

    extraPackages = ps: [
      ps.hatasmota
      ps.paho-mqtt
    ];
  };
}
