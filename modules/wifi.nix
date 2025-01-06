{ inputs, ... }:
{
  imports = [
    inputs.clan-core.clanModules.iwd
  ];

  clan = {
    iwd.networks = {
      azv.ssid = "azv";
    };
  };
}
