{ config, ... }:
{
  wayland = {
    windowManager.sway = {
      config = config.my-sway;
      enable = true;
      extraConfig = ''
        hide_edge_borders --smart-titles smart
      '';
    };
  };
}
