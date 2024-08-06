{
  config,
  pkgs,
  lib,
  ...
}:

let
  username = "gsaurel";
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
  nixGL = "nixGL";
in
{
  imports = [ ./../common.nix ];
  inherit nixGL;

  home.username = username;
  home.homeDirectory = "/home/${username}";
  xdg.systemDirs.data = [ "/home/${username}/.nix-profile/share" ];
  home.sessionVariables.LD_PRELOAD = "/lib/x86_64-linux-gnu/libnss_sss.so.2";
  programs.waybar.settings.mainBar.output = "DP-1";
  nix.package = pkgs.lix;
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
        "DP-1" = {
          bg = "${./../bg/gauche.jpg} fill";
          scale = "1.5";
          mode = "3840x2160";
          pos = "0 0";
        };
        "DP-2" = {
          bg = "${./../bg/droite.jpg} fill";
          mode = "1920x1080";
          pos = "2560 0";
        };
      };
    };
}
