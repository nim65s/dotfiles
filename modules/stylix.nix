{ lib, pkgs, stylix, ... }:
{
  imports = [
    stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/zenburn.yaml";
    cursor = {
      name = "gruppled_white_lite";
      package = pkgs.gruppled-white-lite-cursors;
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
    };
    image = lib.mkDefault ../bg/sleep.jpg;
    opacity = {
      applications = 0.9;
      desktop = 0.8;
      popups = 0.7;
      terminal = 0.8;
    };
    polarity = "dark";
  };
}
