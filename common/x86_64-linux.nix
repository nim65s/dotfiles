{ allSystems, ... }:
{
  nixpkgs = {
    inherit (allSystems.x86_64-linux._module.args) pkgs;
  };
}