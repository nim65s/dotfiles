{
  pkgs,
  ...
}:
{
  imports = [
    # inputs.alloria.nixosModules.escape
    ../../nixos/disko/zfs.nix
    ../../nixos/display.nix
    ../../nixos/laptop.nix
    # ../../nixos/monitored.nix
    ../../nixos/shared.nix
    ../../nixos/nixos.nix
    # ../../nixos/parental-control.nix
    ../../nixos/systemd-boot.nix
  ];

  console = {
    useXkbConfig = false;
    keyMap = "fr";
  };
  disko.devices.disk.main = {
    device = "/dev/disk/by-id/wwn-0x500a0751210f7632";
    name = "main-5960c9984f2d43c8b5158243d19fb2fc";
  };
  home-manager.users = {
    doud = import ../../home/doud.nix;
    mimi = import ../../home/mimi.nix;
    nim = import ../../home/nim/main.nix;
  };
  networking = {
    interfaces."tinc.mars".ipv4.addresses = [
      {
        address = "10.0.55.200";
        prefixLength = 24;
      }
    ];
  };
  programs.waybar.enable = false;
  services = {
    # alloria-escape = {
    #   enable = true;
    #   openFirewall = true;
    #   rtp-ip = "yupa.w";
    # };
    displayManager = {
      autoLogin.user = "mimi";
      defaultSession = null;
    };
    desktopManager.plasma6.enable = true;
    xserver.xkb.variant = "";
  };
  stylix.image = ../../bg/hattori.jpg;
  users.users = {
    doud = {
      isNormalUser = true;
      shell = pkgs.fish;
    };
    mimi = {
      isNormalUser = true;
      shell = pkgs.fish;
      # group = "kids";
    };
  };
}
