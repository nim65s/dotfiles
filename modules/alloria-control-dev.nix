{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.alloria-control-dev;
in
{
  options.services.alloria-control-dev = {
    enable = lib.mkEnableOption "Alloria Control room service";
    port = lib.mkOption {
      type = lib.types.port;
      default = 19000;
    };
    ifname = lib.mkOption {
      type = lib.types.str;
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to automatically open ports in the firewall.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.helvum
      pkgs.easyeffects
    ];
    networking.firewall.allowedUDPPorts = lib.optionals cfg.openFirewall [ cfg.port ];
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [ cfg.port ];
    services = {
      pipewire = {
        jack.enable = true;
        extraConfig.pipewire = {
          "20-alloria-netjack2-manager" = {
            "context.modules" = [
              {
                name = "libpipewire-module-netjack2-manager";
                args = {
                  "local.ifname" = cfg.ifname;
                  "netjack2.connect" = false;
                  "netjack2.sample-rate" = 48000;
                  "netjack2.period-size" = 1024;
                  "audio.channels" = 2;
                  "audio.position" = "[ FL FR ]";
                  "source.props" = { };
                  "sink.props" = { };
                };
              }
            ];
          };
        };
      };
    };
    users.extraUsers.nim.extraGroups = [ "jackaudio" ];
    # systemd.user.services.alloria-control-pw-links = {
    #   description = "Alloria Control pipewire links";
    #   wantedBy = [ "default.target" ];
    #   after = [
    #     "pipewire.service"
    #     "pipewire-pulse.service"
    #   ];
    #   script = ''
    #     sleep 5
    #     ${lib.getExe' pkgs.pipewire "pw-link"} rtp-source-r:receive_FL alsa_output.${cfg.device}:playback_FL
    #     ${lib.getExe' pkgs.pipewire "pw-link"} rtp-source-r:receive_FR alsa_output.${cfg.device}:playback_FR
    #     ${lib.getExe' pkgs.pipewire "pw-link"} alsa_input.${cfg.device}:capture_FL rtp-sink-r:send_FL
    #     ${lib.getExe' pkgs.pipewire "pw-link"} alsa_input.${cfg.device}:capture_FR rtp-sink-r:send_FR
    #   '';
    # };
  };
}
