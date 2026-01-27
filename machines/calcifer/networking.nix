{
  # freebox ll: fe80::72fc:8fff:fe4f:f890
  # calcifer ll: fe80::a074:30ff:fec5:b1d6
  networking = {

    defaultGateway = {
      address = "192.168.0.254";
      interface = "wan";
    };

    domain = "azv";

    interfaces = {

      "wan" = {
        ipv4.addresses = [
          {
            address = "192.168.0.1";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a01:e0a:989:7190::1";
            prefixLength = 64;
          }
        ];
      };

      "lan1" = {
        ipv4.addresses = [
          {
            address = "192.168.1.1";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a01:e0a:989:7191::1";
            prefixLength = 64;
          }
        ];
      };

      "lan2" = {
        ipv4.addresses = [
          {
            address = "192.168.2.1";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a01:e0a:989:7192::1";
            prefixLength = 64;
          }
        ];
      };

      "lan3" = {
        ipv4.addresses = [
          {
            address = "192.168.3.1";
            prefixLength = 24;
          }
        ];
        ipv6.addresses = [
          {
            address = "2a01:e0a:989:7193::1";
            prefixLength = 64;
          }
        ];
      };

    };

    nat = {
      enable = true;
      externalInterface = "wan";
      internalInterfaces = [
        "lan1"
        "lan2"
        "lan3"
      ];
    };

    nftables = {
      enable = true;
    };

  };

}
