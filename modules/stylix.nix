{
  lib,
  pkgs,
  ...
}:
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    cursor = lib.mkDefault {
      name = "catppuccin-mocha-blue-cursors";
      package = pkgs.catppuccin-cursors.mochaBlue;
    };
    fonts = {
      serif = {
        package = pkgs.iosevka-bin.override { variant = "Etoile"; };
        name = "Iosevka-Etoile";
      };
      sansSerif = {
        package = pkgs.iosevka-bin.override { variant = "Aile"; };
        name = "Iosevka-Aile";
      };
      monospace = {
        package = pkgs.nerd-fonts.iosevka;
        name = "IosevkaNerdFont";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "NotoColorEmoji";
      };
      sizes = {
        applications = 8;
        desktop = 8;
        terminal = 9;
      };
    };
    image = lib.mkDefault ../bg/sleep.jpg;
    opacity = {
      applications = 0.9;
      desktop = 0.9;
      popups = 0.9;
      terminal = 0.9;
    };
    polarity = "dark";
  };
}
