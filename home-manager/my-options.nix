{ lib, ...  }:
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
