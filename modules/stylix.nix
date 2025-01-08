{ lib, pkgs, stylix, ... }:
{
  imports = [
    stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
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
