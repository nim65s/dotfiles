{ config, pkgs, ... }:
{
  xdg = {
    enable = true;
    portal = {
      config.sway.default = [
        "wlr"
        "gtk"
      ];
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];
      xdgOpenUsePortal = true;
    };
    systemDirs.data = [ "/home/${config.my-username}/.nix-profile/share" ];
  };
}
