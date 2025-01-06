{ config, pkgs, ... }:
{
  imports = [
    ../../modules/disko.nix
    ../../modules/shared.nix
  ];

  users.users.user.name = "nim";
  clan.core.networking.targetHost = "root@192.168.8.238";
  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-eui.0025385b4140cf80";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH38Iwc5sA/6qbBRL+uot3yqkuACDDu1yQbk6bKxiPGP nim@loon"
  ];

  # Zerotier needs one controller to accept new nodes. Once accepted
  # the controller can be offline and routing still works.
  clan.core.networking.zerotier.controller.enable = true;

  # nvidia
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
      videoDrivers = [ "nvidia" ];
      xkb.layout = "fr";
      xkb.variant = "bepo";
      windowManager.i3.enable = true;
    };
  };
  hardware.nvidia.open = true;
  nixpkgs.config.allowUnfree = true;

  # misc
  environment.systemPackages = with pkgs; [
    alacritty
    kitty
    zellij
    usbutils
    tmux
    file
    pciutils
    iproute2
    coreutils
    jq
    nettools
    htop
    btop
    psmisc
  ];

  # systemd-boot
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 30;
  };

  # ease reinstall
  system.nixos.variant_id = "installer";


  programs = {
    niri.enable = true;
    vim.enable = true;
    waybar.enable = true;
    xwayland.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };



  networking = {
    interfaces.enp3s0 = {
      ipv4.addresses = [{
        address = "192.168.8.238";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.8.1";
      interface = "enp3s0";
    };
  };

  console.keyMap = "fr-bepo";
}
