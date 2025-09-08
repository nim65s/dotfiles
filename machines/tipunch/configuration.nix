{ pkgs, ... }:
{
  imports = [
    ../../modules/disko-ext4-swap-tmpfs.nix
    ../../modules/display.nix
    ../../modules/shared.nix
    ../../modules/nixos.nix
  ];

  disko.devices.disk.main = {
    device = "/dev/disk/by-id/wwn-0x5002538f55509f41";
    name = "main-c0fc6b32-a1ef-4428-96fa-96ae7a428510";
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
  nim-disko.tmpfsSize = "300M";
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
