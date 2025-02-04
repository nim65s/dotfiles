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
    gnome.gnome-keyring.enable = false;
    udev.packages = [
      pkgs.pololu-jrk-g2-software
    ];
    xserver = {
      enable = true;
      xkb.layout = "fr";
      xkb.variant = "bepo";
      windowManager.i3.enable = true;
    };
  };
  sops.secrets.ssh-sk1.owner = "nim";
  users.users.user.extraGroups = [
    "wireshark"
  ];
}
