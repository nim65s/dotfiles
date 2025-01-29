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
        wayland.enable = true;
        #autoLogin.relogin = true;
        autoNumlock = true;
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
