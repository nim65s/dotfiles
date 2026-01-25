{
  config,
  ...
}:
{
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv6.conf.default.forwarding" = true;
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = [
        "lan1"
        "lan2"
        "lan3"
      ];
      except-interface = "wan";
      bind-interfaces = true;

      # IPv4 DHCP ranges
      dhcp-range = [
        "lan1,192.168.1.100,192.168.1.200,12h"
        "lan2,192.168.2.100,192.168.2.200,12h"
        "lan3,192.168.3.100,192.168.3.200,12h"
      ];

      enable-ra = true;
      ra-param = [
        "lan1,0,0"
        "lan2,0,0"
        "lan3,0,0"
      ];

      server = [ "9.9.9.9" ];
      no-hosts = true;
      domain = config.networking.domain;
      local = "/${config.networking.domain}/";
      dhcp-authoritative = true;
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
