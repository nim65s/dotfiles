{
  config,
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
  xdg.autostart = {
    enable = true;
    entries = [
        "${pkgs.zeal-qt6}/share/applications/org.zealdocs.zeal.desktop"
        "${config.programs.firefox.finalPackage}/share/applications/firefox-devedition.desktop"
        "${config.programs.kitty.package}/share/applications/kitty.desktop"
        "${pkgs.element-desktop.desktopItem}/share/applications/element-desktop.desktop"
        "${config.programs.thunderbird.package}/share/applications/thunderbird.desktop"
        "${config.programs.spicetify.spicedSpotify}/share/spotify/spotify.desktop"
        "${pkgs.pavucontrol}/share/applications/org.pulseaudio.pavucontrol.desktop"
    ];
  };
}
