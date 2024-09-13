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
      lavelanet.ssid = "Freebox-34A964";
      sabliere.ssid = "Livebox-7730";
    };
  };
}
