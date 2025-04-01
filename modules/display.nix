{ lib, pkgs, ... }:
{
  programs = {
    niri.enable = true;
    waybar.enable = lib.mkDefault true;
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
        user = lib.mkDefault "nim";
      };
      defaultSession = lib.mkDefault "niri";
      sddm = {
        enable = true;
        #autoLogin.relogin = true;
        autoNumlock = true;
        package = lib.mkDefault pkgs.kdePackages.sddm;
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
      xkb.variant = lib.mkDefault "ergol";
      windowManager.i3.enable = true;
    };
  };
  sops.secrets.ssh-sk1.owner = "nim";
  users.users.nim.extraGroups = [
    "wireshark"
  ];
}
