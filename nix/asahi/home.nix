{
  config,
  pkgs,
  lib,
  ...
}:

let
  username = "gsaurel";
  workspaceOutputAssign = [ ];
  nixGL = "";
in
{
  imports = [ ./../common.nix ];
  nixGL = nixGL;

  home.username = username;
  home.homeDirectory = "/home/${username}";
  xdg.systemDirs.data = [ "/home/${username}/.nix-profile/share" ];
  home.sessionVariables.LD_PRELOAD = "/lib/x86_64-linux-gnu/libnss_sss.so.2";
  nix.package = pkgs.nix;
  xsession.windowManager.i3.config = import ./../i3swayconfig.nix {
    lib = lib;
    sway = false;
    pkgs = pkgs;
    workspaceOutputAssign = workspaceOutputAssign;
    nixGL = nixGL;
  };
  wayland.windowManager.sway.config =
    import ./../i3swayconfig.nix {
      lib = lib;
      sway = true;
      pkgs = pkgs;
      workspaceOutputAssign = workspaceOutputAssign;
      nixGL = nixGL;
    }
    // {
      output = {
        "*" = {
          bg = "${./../bg/sleep.jpg} fill";
        };
      };
    };
}
