{
  config,
  ...
}:
{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv6.conf.default.forwarding" = true;
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
        "/calcifer.azv/2a01:e0a:989:7191::1"
        "/calcifer.azv.saurel.me/82.65.234.111"
        "/calcifer.azv.saurel.me/2a01:e0a:989:7190::1"
      ];
      dhcp-range = [
        "lan1,192.168.1.100,192.168.1.200,12h"
        "lan1,::,constructor:lan1,ra-only"
        # "lan2,192.168.2.100,192.168.2.200,12h"
        # "lan2,::,constructor:lan2,ra-only"
        # "lan3,192.168.3.100,192.168.3.200,12h"
        # "lan2,::,constructor:lan3,ra-only"
      ];

      enable-ra = true;

      dhcp-option = [
        "option:domain-search:azv"
        "option:domain-search:m"
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
}
