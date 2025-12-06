{
  pkgs,
  ...
}:
{
  services.zenohd = {
    enable = true;
    plugins = [ pkgs.zenoh-plugin-mqtt ];
    settings.plugins.mqtt = { };
  };
  networking.firewall.allowedTCPPorts = [ 7447 ];
}
