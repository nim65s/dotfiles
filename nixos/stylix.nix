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
        package = pkgs.iosevka-bin.override { variant = "Etoile"; };
        name = "Iosevka-Etoile";
      };

      sansSerif = {
        package = pkgs.iosevka-bin.override { variant = "Aile"; };
        name = "Iosevka-Aile";
      };

      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "IosevkaTerm" ]; };
        # NB: if this is not mono enough, switch to NFM
        name = "IosevkaTermNF";
      };

      emoji = {
        package = pkgs.openmoji-color;
        name = "OpenMojiColor";
      };
    };
    image = ../bg/sleep.jpg;
    opacity = {
      applications = 0.9;
      popups = 0.7;
      terminal = 0.8;
    };
    polarity = "dark";
  };
}
