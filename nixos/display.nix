{ lib, pkgs, ... }:
{
  imports = [
    ./ssh-sk1.nix
  ];
  environment.systemPackages = [
    pkgs.nautilus
  ];
  fonts.packages = [
    pkgs.peppercarrot-fonts
  ];
  programs = {
    niri.enable = true;
    sniffnet.enable = true;
    waybar.enable = lib.mkDefault true;
    wireshark.enable = true;
    xwayland.enable = true;
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
        autoNumlock = true;
        package = lib.mkDefault pkgs.kdePackages.sddm;
        wayland.enable = true;
      };
    };
    gnome.gnome-keyring.enable = false;
    xserver = {
      enable = true;
      xkb.layout = "fr";
      xkb.variant = lib.mkDefault "ergol";
      windowManager.i3.enable = true;
    };
  };
  users.users.nim.extraGroups = [
    "wireshark"
  ];
}
