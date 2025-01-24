{ pkgs, ... }:
{
  services = {
    gnome.gnome-keyring.enable = false;
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      audio.enable = true;
      pulse.enable = true;
    };
    #xdg.portal.wlr.enable = true;
    udev.packages = [
      pkgs.pololu-jrk-g2-software 
      pkgs.stlink 
    ];
  };
}
