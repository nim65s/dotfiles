{ config, pkgs, ... }:
{
  inherit (config.my-home)
    accounts
    fonts
    gtk
    home
    programs
    qt
    services
    systemd
    wayland
    xdg
    xsession
    ;
  nixGL = "nixGL";
  my-waybar-output = "eDP-1";
  my-sway-output = {
    "*" = {
      bg = "${./../../bg/yupa.jpg} fill";
    };
  };
  nix = config.my-home.nix // {
    package = pkgs.lix;
  };
}
