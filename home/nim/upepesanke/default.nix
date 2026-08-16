{
  config,
  lib,
  pkgs,
  ...
}:
let
  xwayland-satellite-auth = pkgs.writeShellApplication {
    name = "xwayland-satellite";
    text = ''
      export XAUTHORITY="$HOME/.Xauthority"

      xauth list | grep -q ':0  MIT-MAGIC-COOKIE-1' || xauth add :0 . "$(${lib.getExe pkgs.xxd} -l 16 -p /dev/urandom)"

      exec ${lib.getExe pkgs.xwayland-satellite} "$@" -auth "$XAUTHORITY"
    '';
  };
  niri-session-xwayland-satellite-auth = pkgs.writeShellApplication {
    name = "niri-session-xwayland-satellite-auth";
    text = ''
      export PATH=${lib.getBin xwayland-satellite-auth}/bin:$PATH
      exec ${lib.getExe' pkgs.niri "niri-session"}
    '';
  };
in
{
  imports = [
    ../main.nix
    ../lab.nix
    ../dev.nix
    #../aliens/upepesanke/home.nix
  ];

  stylix.image = ../../../bg/gauche.jpg;

  nim-home = {
    niri = [ ./niri.kdl ];
    swaybgs = ''
      ${lib.getExe pkgs.swaybg} -m fill -o DP-1 -i ${../../../bg/gauche.jpg} &
      ${lib.getExe pkgs.swaybg} -m fill -o DP-2 -i ${../../../bg/droite.jpg} &
      wait
    '';
  };

  home = {
    packages = with pkgs; [
      distrobox
      niri-session-xwayland-satellite-auth
    ];
    sessionVariables = {
      XAUTHORITY = "${config.nim-home.homeDirectory}/.Xauthority";
    };
  };

  programs.thunderbird.profiles.nim.settings = {
    "mail.pane_config.dynamic" = 1;
  };

  xdg.autostart = {
    enable = true;
    entries =
      let
        fixDesktop =
          pkg: path:
          pkgs.runCommandLocal "nix-${pkg.pname}.desktop"
            {
              buildInputs = [ pkg ];
              nativeBuildInputs = [ pkgs.gnused ];
            }
            ''
              sed 's|^Exec=.*|Exec=${lib.getExe pkg}|' ${pkg}${path} > $out
            '';
        elementDesktop =
          pkg: path:
          pkgs.runCommandLocal "nix-${pkg.pname}.desktop"
            {
              buildInputs = [ pkg ];
              nativeBuildInputs = [ pkgs.gnused ];
            }
            ''
              sed 's|^Exec=.*|Exec=/run/system-manager/sw/bin/element-desktop|' ${pkg}${path} > $out
            '';

      in
      [
        (fixDesktop config.programs.thunderbird.package "/share/applications/thunderbird.desktop")
        (fixDesktop config.programs.firefox.finalPackage "/share/applications/firefox-devedition.desktop")
        (fixDesktop pkgs.zeal "/share/applications/org.zealdocs.zeal.desktop")
        (elementDesktop pkgs.element-desktop "/share/applications/element-desktop.desktop")
      ];
  };
}
