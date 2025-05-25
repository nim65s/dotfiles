{ clan-core, ... }:
{
  imports = [
    clan-core.clanModules.iwd
  ];

  clan = {
    iwd.networks = {
      antagnac.ssid = "Livebox-DD9E";
      azv = { };
      baroustan = { };
      bouys = { };
      bsc.ssid = "Freepro-KD0N6N";
      kekeno = { };
      kessica = { };
      lacroix.ssid = "Freebox-866B60";
      lavelanet = { };
      marsrovers = { };
      picto-cne.ssid = "Tetaneutral_CNE_5G";
      prades = { };
      sabliere = { };
      toffan = { };
    };
  };
}
