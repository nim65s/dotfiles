{ config, inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../home-manager/my-options.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    users.${config.my-username} = import ../home-manager;
  };
}
