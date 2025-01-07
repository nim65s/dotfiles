{ config, lib, pkgs, ... }:
{
  options = {
    nim-home = {
      niri = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
      };
    };
  };

  config = {
    home = {
      username = "nim";
      homeDirectory = "/home/nim";
      stateVersion = "25.05";

      file = {
        ".config/niri/config.kdl".source = pkgs.concatText "config.kdl" ([ ./niri.kdl ] ++ config.nim-home.niri);
      };
    };
  };
}
