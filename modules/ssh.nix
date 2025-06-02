{ lib, config, ... }:
{
  options.laasProxy = {
    enable = lib.mkEnableOption "proxy jump on laas bastion.";
    value = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };
  };
  config = lib.mkIf config.laasProxy.enable {
    laasProxy.value = {
      proxyJump = "laas";
    };
  };
}
