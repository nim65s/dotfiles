{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../home/nim/main.nix
  ];

  home = {
    packages = with pkgs; [
      deluge-gtk
      filezilla
      music-assistant-companion
      zulip
    ];
  };

  nim-home = {
    niri = [ ./niri.kdl ];
    swaybgs = ''
      ${lib.getExe pkgs.swaybg} -m fill -o DP-1 -i ${../../bg/ashitaka-1.png} &
      ${lib.getExe pkgs.swaybg} -m fill -o DP-2 -i ${../../bg/ashitaka-2.jpg} &
      ${lib.getExe pkgs.swaybg} -m fill -o HDMI-A-1 -i ${../../bg/ashitaka-3.jpg} &
      wait
    '';
  };

  programs = {
    btop.package = pkgs.btop-cuda;

    rmpc.config = ''
      (
        address = "spare.w:6600",
      )
    '';
  };

  xdg.autostart = {
    enable = true;
    entries = [
      "${pkgs.zeal}/share/applications/org.zealdocs.zeal.desktop"
      "${config.programs.firefox.finalPackage}/share/applications/firefox-devedition.desktop"
      "${config.programs.kitty.package}/share/applications/kitty.desktop"
      "${lib.head config.programs.element-desktop.package.desktopItems}/share/applications/element-desktop.desktop"
      "${config.programs.thunderbird.package}/share/applications/thunderbird.desktop"
      "${pkgs.pwvucontrol}/share/applications/com.saivert.pwvucontrol.desktop"
      "${pkgs.signal-desktop}/share/applications/signal.desktop"
      "${pkgs.zulip}/share/applications/zulip.desktop"
      "${pkgs.music-assistant-companion}/share/applications/Music\ Assistant.desktop"
    ];
  };
}
