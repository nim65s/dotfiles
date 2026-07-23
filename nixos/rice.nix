{
  lib,
  catppuccin,
  pkgs,
  stylix,
  ...
}:
{
  imports = [
    catppuccin.nixosModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    autoEnable = true;
    accent = lib.mkDefault "blue";
    sources = catppuccin.packages.${pkgs.stdenv.hostPlatform.system}.overrideScope (
      _: _: {
        whiskers = pkgs.catppuccin-whiskers;
      }
    );
  };

  home-manager = {
    extraSpecialArgs = {
      inherit
        catppuccin
        stylix
        ;
    };
  };

  stylix = {
    targets = {
      nixvim.enable = false;
      qt.enable = false;
    };
  };

}
