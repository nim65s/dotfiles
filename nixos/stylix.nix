{ inputs, lib, pkgs, ... }:
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = import ../stylix.nix { inherit lib pkgs; };
}
