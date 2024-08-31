{ pkgs, ... }:
{
  nixGL = "nixGL";
  my-waybar-output = "eDP-1";
  my-sway-output = {
    "*" = {
      bg = "${./../../bg/yupa.jpg} fill";
    };
  };
  nix.package = pkgs.lix;
}
