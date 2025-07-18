{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.alloria-escape-dev;
in
{
  options.services.alloria-escape-dev = {
    enable = lib.mkEnableOption "Alloria Escape room service";
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
    # device = lib.mkOption {
    #   type = lib.types.str;
    #   default = "pci-0000_04_00.6.analog-stereo";
    # };
    # capture-left = lib.mkOption {
    #   type = lib.types.str;
    #   default = "usb-MUSIC-BOOST_USB_Microphone_MB-306-00.mono-fallback:capture_MONO";
    # };
    # capture-right = lib.mkOption {
    #   type = lib.types.str;
    #   default = "usb-MUSIC-BOOST_USB_Microphone_MB-306-00.2.mono-fallback:capture_MONO";
    # };
    # playback = lib.mkOption {
    #   type = lib.types.str;
    #   default = "pci-0000_00_1f.3.analog-stereo";
    # };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.helvum
      pkgs.easyeffects
    ];
    networking.firewall.allowedUDPPorts = lib.optionals cfg.openFirewall [ cfg.port ];
    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [ cfg.port ];
    services.pipewire.extraConfig.pipewire = {
      "20-alloria-netjack2-driver" = {
        "context.modules" = [
          {
            name = "libpipewire-module-netjack2-driver";
            args = {
              "local.ifname" = cfg.ifname;
              "netjack2.connect" = true;
              "netjack2.latency" = 2;
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
    # systemd.user.services.alloria-escape-pw-links = {
    #   description = "Alloria Escape pipewire links";
    #   wantedBy = [ "default.target" ];
    #   after = [
    #     "pipewire.service"
    #     "pipewire-pulse.service"
    #   ];
    #   script = ''
    #     sleep 5
    #     # ${lib.getExe' pkgs.pipewire "pw-link"} rtp-source-e:receive_FL alsa_output.${cfg.playback}:playback_FL
    #     # ${lib.getExe' pkgs.pipewire "pw-link"} rtp-source-e:receive_FR alsa_output.${cfg.playback}:playback_FR
    #     # ${lib.getExe' pkgs.pipewire "pw-link"} alsa_input.${cfg.capture-left} rtp-sink-e:send_FL
    #     # ${lib.getExe' pkgs.pipewire "pw-link"} alsa_input.${cfg.capture-right} rtp-sink-e:send_FR
    #     ${lib.getExe' pkgs.pipewire "pw-link"} rtp-source-e:receive_FL alsa_output.${cfg.device}:playback_FL
    #     ${lib.getExe' pkgs.pipewire "pw-link"} rtp-source-e:receive_FR alsa_output.${cfg.device}:playback_FR
    #     ${lib.getExe' pkgs.pipewire "pw-link"} alsa_input.${cfg.device}:capture_FL rtp-sink-e:send_FL
    #     ${lib.getExe' pkgs.pipewire "pw-link"} alsa_input.${cfg.device}:capture_FR rtp-sink-e:send_FR
    #   '';
    # };
  };
}
