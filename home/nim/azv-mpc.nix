{
  lib,
  pkgs,
  ...
}:
{
  systemd.user.services.azv-mpc = {
    Service.ExecStart = "${lib.getExe' pkgs.snapcast "snapclient"} --player pipewire tcp://spare.w";
    Unit.Description = "Listen to calcifer mopidy/snapserver";
  };
}
