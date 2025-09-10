{
  config,
  lib,
  ...
}:
let
  cfg = config.services.roversap;
in
{
  options = {
    services.roversap = {
      enable = lib.mkEnableOption "Add an AP in the rover";
      interface = lib.mkOption {
        type = lib.types.str;
        default = "wlan_tplink";
      };
      subnet = lib.mkOption {
        type = lib.types.int;
      };
      upstream = lib.mkOption {
        type = lib.types.str;
        default = "wlan0";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    let
      subnet = builtins.toString cfg.subnet;
      ip = "192.168.${subnet}.${subnet}";
    in
    {
      networking = {
        defaultGateway = {
          interface = cfg.upstream;
        };
        firewall = {
          allowedUDPPorts = [
            67
            68
            69
          ];
          allowedTCPPorts = [
            53
          ];
        };
        hosts = {
          "${ip}" = [ "${config.networking.hostName}.mars" ];
        };
        interfaces = {
          "${cfg.upstream}" = {
            useDHCP = true;
          };
          "${cfg.interface}" = {
            ipv4.addresses = [
              {
                address = "${ip}";
                prefixLength = 24;
              }
            ];
            useDHCP = false;
          };
        };
        networkmanager = {
          ensureProfiles.profiles = {
            azv.connection.interface-name = cfg.upstream;
            marsrovers.connection.interface-name = cfg.upstream;
          };
          unmanaged = [ "interface-name:${cfg.interface}" ];
        };
      };

      services = {
        dnsmasq = {
          enable = true;
          settings = {
            interface = cfg.interface;
            bind-interfaces = true;
            # dhcp-host = "fp4nim,192.168.${subnet}.206";
            dhcp-option = [
              "3,${ip}"
              "6,${ip}"
            ];
            dhcp-range = "192.168.${subnet}.100,192.168.${subnet}.199,12h";
            domain-needed = true;
          };
        };
        hostapd = {
          enable = true;
          radios."${cfg.interface}" = {
            channel = 1;
            countryCode = "FR";
            networks."${cfg.interface}" = {
              ssid = config.networking.hostName;
              authentication.saePasswords = [ { passwordFile = "/wifi-passwd"; } ];
            };
          };
        };
        udev.extraRules = ''
          SUBSYSTEM=="net", ACTION=="add", ENV{ID_VENDOR_FROM_DATABASE}=="TP-Link", NAME="${cfg.interface}"
        '';
      };
    }
  );
}
