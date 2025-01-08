{ pkgs, ... }:
{
  imports = [ ./home-manager.nix ];

  home-manager.users.user = import ./nim-home.nix;

  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = "nim";
      };
      defaultSession = "niri";
    };
    xserver = {
      xkb.variant = "bepo";
    };
  };

  users.users.user = {
    name = "nim";
    shell = pkgs.fish;
  };
}
