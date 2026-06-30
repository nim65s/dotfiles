{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../main.nix
    ../lab.nix
    #../aliens/upepesanke/home.nix
  ];

  nim-home = {
    niri = [ ./niri.kdl ];
    swaybgs = ''
      ${lib.getExe pkgs.swaybg} -m fill -o DP-1 -i ${../../../bg/gauche.jpg} &
      ${lib.getExe pkgs.swaybg} -m fill -o DP-2 -i ${../../../bg/droite.jpg} &
      wait
    '';
  };

  home.packages = [
    pkgs.distrobox
  ];

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
      in
      [
        (fixDesktop config.programs.thunderbird.package "/share/applications/thunderbird.desktop")
        (fixDesktop config.programs.firefox.finalPackage "/share/applications/firefox-devedition.desktop")
        (fixDesktop pkgs.zeal "/share/applications/org.zealdocs.zeal.desktop")
      ];
  };
}
