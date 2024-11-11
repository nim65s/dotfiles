{ inputs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    users.nim = {
      imports = [
        inputs.catppuccin.homeManagerModules.catppuccin
        ../home-manager
      ];
    };
  };
}
