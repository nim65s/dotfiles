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
  nixGL = nixGL;

  home.username = username;
  home.homeDirectory = "/home/${username}";
  xdg.systemDirs.data = [ "/home/${username}/.nix-profile/share" ];
  home.sessionVariables.LD_PRELOAD = "/lib/x86_64-linux-gnu/libnss_sss.so.2";
  programs.waybar.settings.mainBar.output = "DP-1";
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
        "DP-1" = {
          bg = "${./../bg/gauche.jpg} fill";
          scale = "1.5";
        };
        "DP-2" = {
          bg = "${./../bg/droite.jpg} fill";
        };
      };
    };
}
