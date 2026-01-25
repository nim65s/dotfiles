{ lib, ... }:
{
  options = {
    nim-disko = {

      bootSize = lib.mkOption {
        type = lib.types.str;
        default = "4G";
      };

      swapSize = lib.mkOption {
        type = lib.types.str;
        default = "16G";
      };

      tmpfsSize = lib.mkOption {
        type = lib.types.str;
        default = "16G";
      };

    };
  };
}
