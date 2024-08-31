{ pkgs, ... }:
{
  systemd = {
    user.services.spotifyd.Service.Environment = [ "PATH=${pkgs.rbw}/bin" ];
  };
}
