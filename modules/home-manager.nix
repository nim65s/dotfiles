{ home-manager, ... }:
{
  imports = [ home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.root = import ./root-home-minimal.nix;
  };
}
