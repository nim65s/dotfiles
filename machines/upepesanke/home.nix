{
  config,
  pkgs,
  lib,
  ...
}:

let
  workspaceOutputAssign = [
    {
      "workspace" = "1";
      "output" = "DP-1";
    }
    {
      "workspace" = "2";
      "output" = "DP-1";
    }
    {
      "workspace" = "3";
      "output" = "DP-1";
    }
    {
      "workspace" = "4";
      "output" = "DP-1";
    }
    {
      "workspace" = "5";
      "output" = "DP-1";
    }
    {
      "workspace" = "6";
      "output" = "DP-1";
    }
    {
      "workspace" = "7";
      "output" = "DP-1";
    }
    {
      "workspace" = "8";
      "output" = "DP-2";
    }
    {
      "workspace" = "9";
      "output" = "DP-2";
    }
    {
      "workspace" = "10";
      "output" = "DP-2";
    }
    {
      "workspace" = "11";
      "output" = "DP-2";
    }
    {
      "workspace" = "12";
      "output" = "DP-2";
    }
  ];
  my-username = "gsaurel";
in

#import ../../common/home.nix {inherit config lib pkgs; } "gsaurel" // {
  {
    nixGL = "nixGL";
    home = {
      sessionVariables.LD_PRELOAD = "/lib/x86_64-linux-gnu/libnss_sss.so.2";
      username = my-username;
      homeDirectory = "/home/${my-username}";
    };
    nix.package = pkgs.lix;
    programs.waybar.settings.mainBar.output = "DP-1";
    xdg.systemDirs.data = [ "/home/${my-username}/.nix-profile/share" ];
    xsession.windowManager.i3.config = {
      inherit workspaceOutputAssign;
    };
    wayland.windowManager.sway.config = {
      inherit workspaceOutputAssign;
      output = {
        "DP-1" = {
          bg = "${./../../bg/gauche.jpg} fill";
          scale = "1.5";
          mode = "3840x2160";
          pos = "0 0";
        };
        "DP-2" = {
          bg = "${./../../bg/droite.jpg} fill";
          mode = "1920x1080";
          pos = "2560 0";
        };
      };
    };
  }
#}
