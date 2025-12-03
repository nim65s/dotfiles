{ pkgs, ... }:
{
  imports = [
    ../../nixos/disko-zfs-swap.nix
    ../../nixos/display.nix
    ../../nixos/shared.nix
    ../../nixos/nixos.nix
  ];

  catppuccin = {
    flavor = "latte";
    accent = "blue";
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
    pwvucontrol
    simple-scan
    spotify
    tig
    ripgrep
    vim
  ];
  hardware = {
    sane = {
      enable = true;
      brscan5 = {
        enable = true;
        netDevices = {
          baroustan = {
            model = "MFC-9140CDN";
            ip = "192.168.1.100";
          };
        };
      };
    };
  };
  home-manager.users = {
    fil = import ../../home/fil.nix;
    nim = import ../../home/nim/main.nix;
  };
  networking = {
    firewall.allowedTCPPorts = [ 21 ];
    firewall.allowedTCPPortRanges = [
      {
        from = 40000;
        to = 40100;
      }
    ];
  };
  programs = {
    waybar.enable = false;
    system-config-printer.enable = true;
  };
  services = {
    displayManager = {
      autoLogin.user = "fil";
      defaultSession = null;
    };
    desktopManager.plasma6.enable = true;
    printing = {
      enable = true;
      drivers = [
        pkgs.mfc9140cdnlpr
        pkgs.mfc9140cdncupswrapper
      ];
    };
    saned = {
      enable = true;
    };
    vsftpd = {
      enable = true;
      localUsers = true;
      chrootlocalUser = true;
      allowWriteableChroot = true;
      writeEnable = true;
      extraConfig = ''
        pasv_enable=YES
        pasv_min_port=40000
        pasv_max_port=40100
      '';
    };
    xserver.xkb = {
      variant = "";
      options = "caps:digits_row";
    };
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
