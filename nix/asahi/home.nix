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
  inherit nixGL;

  home.username = username;
  home.homeDirectory = "/home/${username}";
  xdg.systemDirs.data = [ "/home/${username}/.nix-profile/share" ];
  home.sessionVariables.LD_PRELOAD = "/lib/x86_64-linux-gnu/libnss_sss.so.2";
  nix.package = pkgs.nix;
  xsession.windowManager.i3.config = import ./../i3swayconfig.nix {
    inherit lib;
    sway = false;
    inherit pkgs;
    inherit workspaceOutputAssign;
    inherit nixGL;
  };
  wayland.windowManager.sway.config =
    import ./../i3swayconfig.nix {
      inherit lib;
      sway = true;
      inherit pkgs;
      inherit workspaceOutputAssign;
      inherit nixGL;
    }
    // {
      output = {
        "*" = {
          bg = "${./../bg/sleep.jpg} fill";
        };
      };
    };
}
