{
  lib,
  pkgs,
  nixvim,
  ...
}:
{
  imports = [
    nixvim.nixosModules.nixvim
  ];

  programs.nixvim = import ../shared/nixvim.nix { inherit lib pkgs; } // {
    enable = true;
    defaultEditor = true;
  };

  services = {
    earlyoom = {
      enable = true;
      enableNotifications = true;
      extraArgs = [
        "--prefer"
        "(^|/)(cc|cpp|gcc|g++|cc1|cc1plus|clang|clang++)$"
      ];
    };
  };
}
