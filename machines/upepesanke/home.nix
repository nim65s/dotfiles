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
  nixGL = "nixGL";
  my-username = "gsaurel";
  my-waybar-output = "DP-1";
  my-sway-output = {
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
  my-workspaceOutputAssign = [
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
  home = config.my-home.home // {
    sessionVariables = config.my-home.home.sessionVariables // {
      LD_PRELOAD = "/lib/x86_64-linux-gnu/libnss_sss.so.2";
    };
  };
  nix = config.my-home.nix // {
    package = pkgs.lix;
  };
}
