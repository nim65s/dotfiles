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
