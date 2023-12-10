{ config, pkgs, lib, ... }:

let
  username = "nim";
in {
  imports = [ ./common.nix ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  programs.waybar.settings.mainBar.output = "eDP-1";
  xsession.windowManager.i3.config = import ./i3swayconfig.nix { lib=lib; sway=false; };
  wayland.windowManager.sway.config = import ./i3swayconfig.nix { lib=lib; sway=true; };
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "hyprpaper"
      "waybar"
      "firefox"
      "thunderbird"
      "element-desktop"
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
