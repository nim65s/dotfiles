# Standalone HM things
# ie. not nixos hm
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
  services.home-manager = {
    autoExpire = {
      enable = true;
      frequency = "weekly";
      store.cleanup = true;
      store.options = "--delete-older-than 30d";
    };
    autoUpgrade = {
      enable = true;
      flakeUrl = "git+https://github.com/nim65s/dotfiles";
      frequency = "weekly";
      preSwitchCommands = [ ]; # dont want "nix flake update", default for 26.05
      useFlake = true;
    };
  };

  stylix.targets.kde.plasmaWorkspacePackage = pkgs.kdePackages.plasma-workspace;

  xdg.portal = {
    enable = true;
    configPackages = [ pkgs.niri ];
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };
}
