{ config, pkgs, lib, ... }:

let
  username = "nim";
  workspaceOutputAssign = [];
  nixGL = "";
in {
  imports = [ ./../common.nix ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  xdg.systemDirs.data = [ "/home/${username}/.nix-profile/share" ];
  programs.waybar.settings.mainBar.output = "eDP-1";
  xsession.windowManager.i3.config = import ./../i3swayconfig.nix {
    sway=false;
    pkgs=pkgs;
    workspaceOutputAssign=workspaceOutputAssign;
    nixGL=nixGL;
  };
  wayland.windowManager.sway.config = import ./../i3swayconfig.nix {
    sway=true;
    pkgs=pkgs;
    workspaceOutputAssign=workspaceOutputAssign;
    nixGL=nixGL;
  } // {
    output = {
      "*" = {
        bg = "${./../bg/sleep.jpg} fill";
      };
    };
  };
}
