{ inputs, pkgs, ... }:
{
  imports = [
    inputs.stylix.nixosModules.stylix
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
        package = pkgs.iosevka-etoile;
        name = "Iosevka-Etoile";
      };

      sansSerif = {
        package = pkgs.iosevka-aile;
        name = "Iosevka-Aile";
      };

      monospace = {
        package = pkgs.iosevka-term;
        # NB: if this is not mono enough, switch to NFM
        name = "IosevkaTermNF";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "NotoColorEmoji";
      };
    };
    image = ../bg/sleep.jpg;
    opacity = {
      applications = 0.9;
      desktop = 0.8;
      popups = 0.7;
      terminal = 0.8;
    };
    polarity = "dark";
  };
}
