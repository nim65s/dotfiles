{
  pkgs,
  stylix,
  ...
}:
{
  imports = [
    stylix.homeModules.stylix
    ../../shared/stylix.nix
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
