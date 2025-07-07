{ inputs, pkgs, ... }:
{
  imports = [
    inputs.stylix.homeModules.stylix
    ./stylix.nix
  ];

  nix.package = pkgs.lix;
  home = {
    packages = [ pkgs.lix ];
  };
  xdg.portal = {
    enable = true;
    configPackages = [ pkgs.niri ];
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };
}
