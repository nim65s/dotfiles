{ pkgs, ... }:
{
  gtk = {
    enable = true;
    font.name = "Source Sans";
    theme.package = pkgs.libsForQt5.breeze-gtk;
    theme.name = "Breeze-Dark";
  };
}
