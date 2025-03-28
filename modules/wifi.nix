{ clan-core, ... }:
{
  imports = [
    clan-core.clanModules.iwd
  ];

  clan = {
    iwd.networks = {
      azv = { };
      baroustan = { };
      bouys = { };
      bsc.ssid = "Freepro-KD0N6N";
      kekeno = { };
      kessica = { };
      lacroix = { };
      lavelanet = { };
      marsrovers = { };
      prades = { };
      sabliere = { };
      toffan = { };
    };
  };
}
