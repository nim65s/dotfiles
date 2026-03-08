{
  networking.nftables = {
    enable = true;
    tables = {
      firewall = {
        family = "inet";
        content = ''
          chain incoming {
            type filter hook forward priority 0; policy accept;

            ct state { established, related } accept
            ct state invalid drop

            tcp dport { 22, 2222 } accept

            iifname "wan" oifname { "lan1", "lan2", "lan3" } drop;
          }
        '';
      };
    };
  };
}
