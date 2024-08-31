{ lib, ... }:
{
  options.my-username = lib.mkOption {
    type = lib.types.str;
    default = "nim";
    description = "my username";
  };
}
