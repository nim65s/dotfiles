{ pkgs, ... }:
{
  imports = [ ./home-manager.nix ];

  users.users.user = {
    name = "nim";
  };
}
