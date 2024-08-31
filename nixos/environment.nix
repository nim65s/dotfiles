{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      git
      iwgtk
      vim
    ];
  };
}
