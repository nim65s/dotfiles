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
      human.ssid = "WNHC-Invite";
      kekeno.ssid = "Kekeno";
      kessica.ssid = "Livebox-CD00";
      lavelanet.ssid = "Freebox-34A964";
      sabliere.ssid = "Livebox-7730";
    };
  };
}
