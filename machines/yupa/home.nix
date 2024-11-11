{ pkgs, nixgl, ... }:
{
  nixGL.packages = nixgl.packages;
  my-waybar-output = "eDP-1";
  my-sway-extraConfig = "";
  my-sway-output = {
    "*" = {
      bg = "${./../../bg/yupa.jpg} fill";
    };
  };
  nix.package = pkgs.lix;
}
