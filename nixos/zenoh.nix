{
  pkgs,
  ...
}:
{
  services.zenohd = {
    enable = true;
    plugins = [ pkgs.zenoh-plugin-mqtt ];
    settings.plugins = {
      mqtt = { };
      storage_manager.storages.azv = {
        key_expr = "azv/**";
        volume.id = "memory";
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 7447 ];
}
