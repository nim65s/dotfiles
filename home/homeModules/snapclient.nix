{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.snapclient;
in
{
  options.services.snapclient = {
    enable = lib.mkEnableOption "snapclient service";
    package = lib.mkPackageOption pkgs "snapcast" { };

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    player = lib.mkOption {
      type = lib.types.str;
      default = "pipewire";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "tcp://spare.w";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.snapclient = {
      Service.ExecStart = "${lib.getExe' cfg.package "snapclient"} --player ${cfg.player} ${cfg.url}";
      Unit.Description = "Start snapserver";
      Install.WantedBy = lib.optional cfg.autoStart "default.target";
    };
  };
}
