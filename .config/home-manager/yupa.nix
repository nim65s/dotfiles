{ config, pkgs, lib, ... }:

{
  imports = [ ./common.nix ];

  home.username = "nim";
  home.homeDirectory = "/home/nim";
  programs.waybar.settings.mainBar.output = "eDP-1";
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "hyprpaper"
      "waybar"
      "firefox"
    ];
    monitor = [
      "eDP-1, 1920x1080, 0x0, 1"
    ];
    workspace = [
      "1, default:true"
      "2"
      "3"
      "4"
      "5"
      "6"
      "7"
      "8"
      "9"
      "10, gapsin:0, gapsout:0, rounding:0, decorate:0, default:true"
      "11, gapsin:0, gapsout:0, rounding:0, decorate:0"
      "12, gapsin:0, gapsout:0, rounding:0, decorate:0"
    ];
  };
}
