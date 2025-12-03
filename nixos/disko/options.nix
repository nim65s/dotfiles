{ lib, ... }:
{
  options = {
    nim-disko = {
      tmpfsSize = lib.mkOption {
        type = lib.types.str;
        default = "1G";
      };
    };
  };
}
