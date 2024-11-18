{ lib, ... }:
{
  options = {
    my-waybar-output = lib.mkOption {
      type = lib.types.str;
      description = "my waybar main output";
      default = "";
    };

    my-username = lib.mkOption {
      type = lib.types.str;
      default = "nim";
      description = "my username";
    };

    my-sway-extraConfig = lib.mkOption {
      type = lib.types.str;
      description = "my sway output";
      default = "hide_edge_borders --smart-titles smart";
    };

    my-sway-output = lib.mkOption {
      type = lib.types.attrs;
      description = "my sway output";
      default = {
        "*" = {
          bg = lib.mkDefault "${./../bg/sleep.jpg} fill";
        };
      };
    };
  };
}
