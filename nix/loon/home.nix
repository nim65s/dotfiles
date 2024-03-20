{
  config,
  pkgs,
  lib,
  ...
}:

let
  username = "nim";
  workspaceOutputAssign = [ ];
  nixGL = "";
in
{
  imports = [ ./../common.nix ];
  inherit nixGL;

  home.username = username;
  home.homeDirectory = "/home/${username}";
  xdg.systemDirs.data = [ "/home/${username}/.nix-profile/share" ];
  programs.waybar.settings.mainBar.output = "eDP-1";
  xsession.windowManager.i3.config = import ./../i3swayconfig.nix {
    inherit
      lib
      pkgs
      workspaceOutputAssign
      nixGL
      ;
    sway = false;
  };
  wayland.windowManager.sway.config =
    import ./../i3swayconfig.nix {
      inherit
        lib
        pkgs
        workspaceOutputAssign
        nixGL
        ;
      sway = true;
    }
    // {
      output = {
        "*" = {
          bg = "${./../bg/sleep.jpg} fill";
        };
      };
    };
}
