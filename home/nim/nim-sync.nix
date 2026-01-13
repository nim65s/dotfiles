{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "nim-sync";
  cfg = config.services."${name}";
  desc = "periodically run stuff if keyring is unlocked";
  script = pkgs.writeShellScriptBin name ''
    ${lib.concatStringsSep "\n" cfg.stuff}
  '';

in
{
  options.services."${name}" = {
    enable = lib.mkEnableOption desc;
    unlocked = lib.mkOption {
      type = lib.types.str;
      default = "${lib.getExe pkgs.rbw} unlocked";
    };
    stuff = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "${lib.getExe pkgs.nb} sync"
        "${lib.getExe pkgs.vdirsyncer} sync"
      ];
    };
    period = lib.mkOption {
      type = lib.types.str;
      default = "5m";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services."${name}" = {
      Service = {
        Type = "oneshot";
        ExecCondition = cfg.unlocked;
        ExecStart = lib.getExe script;
      };
      Unit.Description = desc;
    };
    systemd.user.timers."${name}" = {
      Install.WantedBy = [ "timers.target" ];
      Timer = {
        OnActiveSec = cfg.period;
        OnUnitActiveSec = cfg.period;
        Unit = "${name}.service";
      };
      Unit.Description = desc;
    };
  };
}
