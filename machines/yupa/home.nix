{ pkgs, ... }:
{
  my-waybar-output = "eDP-1";
  my-sway-extraConfig = "";
  nix.package = pkgs.lix;
  stylix.image = ./../../bg/yupa.jpg;
}
