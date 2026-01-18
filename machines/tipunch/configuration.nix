{ pkgs, ... }:
{
  imports = [
    ../../nixos/disko/ext4-swap-tmpfs.nix
    ../../nixos/display.nix
    ../../nixos/laptop.nix
    ../../nixos/shared.nix
    ../../nixos/nixos.nix
    ../../nixos/systemd-boot.nix
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
    martine = import ../../home/martine.nix;
    nim = import ../../home/nim/main.nix;
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
