{ config, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      config.boot.kernelPackages.usbip
      cntr
      git
      iwgtk
      vim
    ];
  };
}
