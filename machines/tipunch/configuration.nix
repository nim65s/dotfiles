{ pkgs, ... }:
{
  imports = [
    ../../modules/disko-zfs-swap.nix
    ../../modules/display.nix
    ../../modules/shared.nix
    ../../modules/nixos.nix
    ../../modules/x86_64-linux.nix
  ];

  disko.devices.disk.main = {
    device = "/dev/disk/by-id/wwn-0x50004cf20e36a7b7";
    name = "main-80bb289a-6988-4863-aad9-9fd308eacd58";
  };
  environment.systemPackages = with pkgs; [
    evince
    fd
    file
    libreoffice
    pwvucontrol
    tig
    ripgrep
    vim
  ];
  home-manager.users = {
    martine = import ../../modules/martine-home.nix;
    nim = import ../../modules/nim-home.nix;
  };
  programs.waybar.enable = false;
  services = {
    displayManager = {
      autoLogin.user = "martine";
      defaultSession = null;
    };
    desktopManager.plasma6.enable = true;
    xserver.xkb.variant = "";
  };
  # stylix.image = ../../bg/hattori.jpg;
  users.users.martine = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
    ];
  };
}
