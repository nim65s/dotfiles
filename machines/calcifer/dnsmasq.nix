{
  lib,
  config,
  ...
}:
{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = lib.mkDefault 1;
    "net.ipv6.conf.all.forwarding" = lib.mkDefault 1;
    "net.ipv6.conf.default.forwarding" = lib.mkDefault 1;
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = [
        "lan1"
        # "lan2"
        # "lan3"
      ];
      except-interface = "wan";
      bind-interfaces = true;

      address = [
        "/calcifer.azv/192.168.1.1"
        "/calcifer.azv/2a01:e0a:941:c1d1::1"
        "/calcifer.azv.saurel.me/82.65.234.111"
        "/calcifer.azv.saurel.me/2a01:e0a:941:c1d4::1"
        "/kiki.azv/192.168.1.2"
        "/epson.azv/192.168.1.3"
        "/spare.azv/192.168.1.4"
        "/totoro.azv/192.168.1.111"
      ];
      dhcp-host = [
        "18:e8:29:fd:a0:6a,kiki.azv,192.168.1.2"
        "38:1a:52:8f:c4:76,epson.azv,192.168.1.3"
        "1c:69:7a:66:98:ee,spare.azv,192.168.1.4"
        "00:9c:02:97:5d:31,totoro.azv,192.168.1.111"
      ];
      dhcp-range = [
        "lan1,192.168.1.100,192.168.1.200,12h"
        "lan1,::,constructor:lan1,ra-names"
        # "lan2,192.168.2.100,192.168.2.200,12h"
        # "lan2,::,constructor:lan2,ra-only"
        # "lan3,192.168.3.100,192.168.3.200,12h"
        # "lan2,::,constructor:lan3,ra-only"
      ];

      enable-ra = true;

      dhcp-option = [
        "option:domain-search,azv"
      ];

      server = [ "9.9.9.9" ];
      no-hosts = true;
      domain = config.networking.domain;
      local = "/${config.networking.domain}/";
      dhcp-authoritative = true;
      expand-hosts = true;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      53
    ];
    allowedUDPPorts = [
      53
      67
    ];
  };

  systemd.services.dnsmasq = {
    after = [
      "sys-subsystem-net-devices-lan1.device"
      "sys-subsystem-net-devices-wan.device"
    ];
    requires = [
      "sys-subsystem-net-devices-lan1.device"
      "sys-subsystem-net-devices-wan.device"
    ];
  };
}
