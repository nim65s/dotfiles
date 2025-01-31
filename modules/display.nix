{ pkgs, ... }:
{
  programs = {
    niri.enable = true;
    waybar.enable = true;
    xwayland.enable = true;
    wireshark.enable = true;
  };
  security = {
    pam.services.swaylock = { };
    rtkit.enable = true;
  };
  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = "nim";
      };
      defaultSession = "niri";
      sddm = {
        enable = true;
        #autoLogin.relogin = true;
        autoNumlock = true;
        package = pkgs.kdePackages.sddm;
        wayland.enable = true;
      };
    };
    xserver = {
      enable = true;
      xkb.layout = "fr";
      xkb.variant = "bepo";
      windowManager.i3.enable = true;
    };
  };
}
