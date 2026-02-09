{
  lib,
  pkgs,
  ...
}:
{
  systemd.user.services.azv-mpc = {
    Service.ExecStart = "${lib.getExe' pkgs.snapcast "snapclient"} --player pipewire tcp://calcifer.azv";
    Unit.Description = "Listen to calcifer mopidy/snapserver";
  };
}
