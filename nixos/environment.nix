{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      cntr
      git
      iwgtk
      pololu-jrk-g2-software
      vim
    ];
  };
}
