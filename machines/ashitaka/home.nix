{
  lib,
  pkgs,
  ...
}:
{
  imports = [ ../../modules/nim-home.nix ];

  home = {
    packages = with pkgs; [
      deluge-gtk
      filezilla
    ];
  };

  nim-home = {
    niri = [ ./niri.kdl ];
    swaybgs = ''
      ${lib.getExe pkgs.swaybg} -m fill -o DP-1 -i ${../../bg/ashitaka-1.png} &
      ${lib.getExe pkgs.swaybg} -m fill -o DP-2 -i ${../../bg/ashitaka-2.jpg} &
      ${lib.getExe pkgs.swaybg} -m fill -o DP-3 -i ${../../bg/ashitaka-3.jpg} &
      wait
    '';
  };
}
