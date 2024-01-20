{ config, pkgs, lib, ... }:

let
  username = "nim";
  workspaceOutputAssign = [];
in {
  imports = [ ./common.nix ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  programs.waybar.settings.mainBar.output = "eDP-1";
  xsession.windowManager.i3.config = import ./i3swayconfig.nix {
    lib=lib;
    sway=false;
    pkgs=pkgs;
    workspaceOutputAssign=workspaceOutputAssign;
  };
  wayland.windowManager.sway.config = import ./i3swayconfig.nix {
    lib=lib;
    sway=true;
    pkgs=pkgs;
    workspaceOutputAssign=workspaceOutputAssign;
  } // {
    output = {
      "*" = {
        bg = "${./bg/yupa.jpg} fill";
      };
    };
  };
}
