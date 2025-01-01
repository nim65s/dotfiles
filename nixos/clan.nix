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
      baroustan.ssid = "baroustan";
      comwell.ssid = "comwellhotels";
      #gofish.ssid = "><>°";
      human.ssid = "WNHC-Invite";
      kekeno.ssid = "Kekeno";
      kessica.ssid = "Livebox-CD00";
      lacroix.ssid = "Freebox-866B60";
      lavelanet.ssid = "Freebox-34A964";
      sabliere.ssid = "Livebox-7730";
      toffan.ssid = "Shannon-WiFi";
    };
  };
}
