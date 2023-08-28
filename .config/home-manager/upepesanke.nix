{ config, pkgs, lib, ... }:

let
  username = "gsaurel";
in {
  imports = [ ~/dotfiles/.config/home-manager/common.nix ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.sessionVariables.LD_PRELOAD = "/lib/x86_64-linux-gnu/libnss_sss.so.2";
  programs.waybar.settings.mainBar.output = "DP-2";
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "hyprpaper"
      "waybar"
      "firefox"
      "thunderbird"
      "nheko"
    ];
    monitor = [
      "DP-2, 3840x2160, 0x0, 1.5"
      "DP-1, 1920x1080, 2560x0, 1"
    ];
    workspace = [
      "1, monitor:DP-2, default:true"
      "2, monitor:DP-2"
      "3, monitor:DP-2"
      "4, monitor:DP-2"
      "5, monitor:DP-2"
      "6, monitor:DP-2"
      "7, monitor:DP-2"
      "8, monitor:DP-2"
      "9, monitor:DP-1"
      "10, monitor:DP-1, gapsin:0, gapsout:0, rounding:0, decorate:0, default:true"
      "11, monitor:DP-1, gapsin:0, gapsout:0, rounding:0, decorate:0"
      "12, monitor:DP-1, gapsin:0, gapsout:0, rounding:0, decorate:0"
    ];
  };
}
