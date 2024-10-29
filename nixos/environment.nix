{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      cntr
      git
      iwgtk
      vim
    ];
  };
}
