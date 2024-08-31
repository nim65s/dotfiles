{ lib, ...  }:
{
  options.my-waybar-output = lib.mkOption {
    type = lib.types.str;
    description = "my waybar main output";
    default = "";
  };
}
