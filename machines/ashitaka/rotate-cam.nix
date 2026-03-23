{
  config,
  pkgs,
  ...
}:
{
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=10 card_label="rotated" exclusive_caps=1
  '';

  environment.systemPackages = with pkgs; [
    ffmpeg
    v4l-utils
  ];
}
