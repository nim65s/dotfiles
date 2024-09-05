{ inputs, ... }:
{
  imports = [
    inputs.clan-core.clanModules.iwd
    #inputs.clan-core.clanModules.sshd
  ];

  clan = {
    iwd.networks = {
      azv.ssid = "azv";
      baron.ssid = "Baron";
      kekeno.ssid = "Kekeno";
      sabliere.ssid = "Livebox-7730";
    };
  };
}
