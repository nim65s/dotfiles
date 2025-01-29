{ pkgs, ... }:
{
  imports = [ ./home-manager.nix ];

  home-manager.users.user = import ./nim-home.nix;

  users.users.user = {
    name = "nim";
    shell = pkgs.fish;
  };
}
