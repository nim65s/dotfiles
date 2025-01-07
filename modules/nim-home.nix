{ config, lib, pkgs, ... }:
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

    systemd = {
      user.services = {
        swaybgs = {
          Install.WantedBy = [ "graphical-session.target" ];
          Service.ExecStart = pkgs.writeShellScript "swaybgs" config.nim-home.swaybgs;
          Unit = {
            Description = "Set wallpaper(s)";
            PartOf = "graphical-session.target";
            After = "graphical-session.target";
          };
        };
      };
    };
  };
}
