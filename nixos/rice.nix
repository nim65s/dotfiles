{
  lib,
  catppuccin,
  stylix,
}:
{
  imports = [
    catppuccin.nixosModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    autoEnable = true;
    accent = lib.mkDefault "blue";
  };

  home-manager = {
    extraSpecialArgs = {
      inherit
        catppuccin
        stylix
        ;
    };
  };
}
