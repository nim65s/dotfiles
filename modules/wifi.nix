{ inputs, ... }:
{
  imports = [
    inputs.clan-core.clanModules.iwd
  ];

  clan = {
    iwd.networksss = {
      azv.ssid = "azv";
    };
  };
}
