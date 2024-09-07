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
          bg = "${./../bg/sleep.jpg} fill";
        };
      };
    };

    nixGL = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Some GUI commands will be prefixed by this.
        Possible values: "" & "nixgl"
      '';
    };
  };
}
