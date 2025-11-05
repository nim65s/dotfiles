{
  config,
  lib,
  pkgs,
  ...
}:
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

  programs.ssh.matchBlocks."*".identityFile = "/home/gsaurel/.ssh/id_ed25519";

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
        (fixDesktop config.programs.spicetify.spicedSpotify "/share/spotify/spotify.desktop")
        (fixDesktop config.programs.thunderbird.package "/share/applications/thunderbird.desktop")
        (fixDesktop config.programs.firefox.finalPackage "/share/applications/firefox-devedition.desktop")
        (fixDesktop pkgs.zeal "/share/applications/org.zealdocs.zeal.desktop")
      ];
  };
}
