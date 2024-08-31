{ config, allSystems, ... }:
{
  nixpkgs = {
    inherit (allSystems.${config.nixpkgs.hostPlatform.system}._module.args) pkgs;
  };
}
