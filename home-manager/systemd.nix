{ config, lib, pkgs, ... }:
{
  systemd = {
    user.services = {
      spotifyd.Service.Environment = [ "PATH=${pkgs.rbw}/bin" ];
      swaybg = {
        Install.WantedBy = [ "graphical-session.target" ];
        Service.ExecStart = "${lib.getExe pkgs.swaybg} -m fill -i ${config.stylix.image}";
        Unit = {
          Description = "set walppaper";
          PartOf = "graphical-session.target";
          After = "graphical-session.target";
        };
      };
    };
  };
}
