{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.nixGL = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = ''
      Some GUI commands will be prefixed by this.
      Possible values: "" & "nixgl"
    '';
  };
}
