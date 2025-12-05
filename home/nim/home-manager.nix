# Standalone HM things
# ie. not nixos hm
{
  config,
  lib,
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
      flakeDir = "${config.nim-home.homeDirectory}/dotfiles";
      useFlake = true;
    };
  };
  systemd.user.services.home-manager-auto-upgrade = {
    Service.ExecStartPre = "${lib.getExe pkgs.git} pull https://github.com/nim65s/dotfiles";
  };
  xdg.portal = {
    enable = true;
    configPackages = [ pkgs.niri ];
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };
}
