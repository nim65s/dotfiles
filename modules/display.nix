{ pkgs, ... }:
{
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
