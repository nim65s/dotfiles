{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      cntr
      git
      helix
      iwgtk
      pololu-jrk-g2-software
      vim
    ];
  };
}
