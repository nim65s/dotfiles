{
  config,
  lib,
  ...
}:
{
  imports = [
    ../../home/nim/main.nix
  ];

  nim-home = {
    niri = [ ./niri.kdl ];
  };

  programs = {
    rmpc.config = ''
      (
        address = "spare.w:6600",
      )
    '';
    thunderbird.profiles.nim.settings = {
      "mail.pane_config.dynamic" = 1;
    };
  };

  xdg.autostart = {
    enable = true;
    entries = [
      "${config.programs.firefox.finalPackage}/share/applications/firefox-devedition.desktop"
      "${lib.head config.programs.element-desktop.package.desktopItems}/share/applications/element-desktop.desktop"
      "${config.programs.thunderbird.package}/share/applications/thunderbird.desktop"
    ];
  };
}
