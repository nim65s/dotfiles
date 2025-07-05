{ pkgs, ... }:
{
  imports = [
    ../../modules/disko-zfs.nix
    ../../modules/display.nix
    ../../modules/shared.nix
    ../../modules/nixos.nix
    ../../modules/x86_64-linux.nix
  ];

  console = {
  };
  disko.devices.disk.main = {
    device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_500GB_23313J803792";
    name = "main-cb1244c6-395c-44db-89db-709173ba9b44";
  };
  environment.systemPackages = with pkgs; [
    bftpd
    evince
    fd
    file
    libreoffice
    pavucontrol
    spotify
    tig
    ripgrep
    vim
  ];
  hardware.sane.enable = true;
  home-manager.users = {
    fil = import ../../modules/fil-home.nix;
    nim = import ../../modules/nim-home.nix;
  };
  networking = {
    interfaces.wlp170s0.mtu = 1400;
  };
  programs.waybar.enable = false;
  services = {
    displayManager = {
      autoLogin.user = "fil";
      defaultSession = null;
    };
    desktopManager.plasma6.enable = true;
    vsftpd = {
      enable = true;
      userlistDeny = false;
      localUsers = true;
      userlist = [ "ftp-test-user" ];
      writeEnable = true;
      localRoot = "/home/$USERS/scans";
    };
    xserver.xkb.variant = "";
  };
  # stylix.image = ../../bg/hattori.jpg;
  users.users.fil = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "lp"
      "scanner"
      "wheel"
    ];
  };
}
