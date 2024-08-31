{ pkgs, ... }:
{
  services = {
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      audio.enable = true;
      pulse.enable = true;
    };
    #xdg.portal.wlr.enable = true;
    udev.packages = [ pkgs.stlink ];
  };
}
