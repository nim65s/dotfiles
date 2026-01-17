{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    nim-home = {
      niri = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
      };
      swaybgs = lib.mkOption {
        type = lib.types.str;
        default = "${lib.getExe pkgs.swaybg} -m fill -i ${config.stylix.image}";
      };
      waybar-output = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      username = lib.mkOption {
        type = lib.types.str;
        default = "nim";
      };
      homeDirectory = lib.mkOption {
        type = lib.types.str;
        default = "/home/${config.nim-home.username}";
      };
      laasProxy = {
        enable = lib.mkEnableOption "ProxyJump to laas";
        value = lib.mkOption {
          default = { };
        };
      };
    };
  };
}
