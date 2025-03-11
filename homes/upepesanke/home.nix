{ config, lib, pkgs, ... }:
{
  imports = [
    ../../modules/nim-home.nix
    ../../modules/lab.nix
    #../aliens/upepesanke/home.nix
  ];

  stylix.image = ../../bg/gauche.jpg;

  nim-home = {
    niri = [ ./niri.kdl ];
    swaybgs = ''
      ${lib.getExe pkgs.swaybg} -m fill -o DP-1 -i ${../../bg/gauche.jpg} &
      ${lib.getExe pkgs.swaybg} -m fill -o DP-2 -i ${../../bg/droite.jpg} &
      wait
    '';
  };

  xdg.autostart.entries = [
    "${config.programs.spicetify.spicedSpotify}/share/spotify/spotify.desktop"
    "${config.programs.thunderbird.package}/share/applications/thunderbird.desktop"
    "${config.programs.firefox.finalPackage}/share/applications/firefox-devedition.desktop"
    "${pkgs.zeal-qt6}/share/applications/org.zealdocs.zeal.desktop"
  ];
}
