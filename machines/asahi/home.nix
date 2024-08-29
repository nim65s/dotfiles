{ config, pkgs, ... }:
{
  inherit (config.my-home)
    accounts
    fonts
    gtk
    programs
    qt
    services
    systemd
    wayland
    xdg
    xsession
    ;
  my-username = "gsaurel";
  home = config.my-home.home // {
    sessionVariables = config.my-home.home.sessionVariables // {
      LD_PRELOAD = "/lib/x86_64-linux-gnu/libnss_sss.so.2";
      SCCACHE_REDIS="redis://asahi";
    };
  };
  nix = config.my-home.nix // {
    package = pkgs.lix;
  };
}
