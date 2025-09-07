{ inputs, pkgs, ... }:
{
  imports = [
    inputs.stylix.homeModules.stylix
    ./stylix.nix
  ];

  home = {
    packages = [ pkgs.nix ];
  };
  xdg.portal = {
    enable = true;
    configPackages = [ pkgs.niri ];
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };
}
