{ clan-core, ... }:
{
  imports = [
    clan-core.clanModules.iwd
  ];

  clan = {
    iwd.networks = {
      azv = { };
      marsrovers = { };
    };
  };
}
