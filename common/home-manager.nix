{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./nixgl.nix
    ./i3sway.nix
    ./my-i3.nix
    ./my-sway.nix
    ./my-home.nix
    ./my-programs.nix
    ./my-firefox.nix
  ];
}
