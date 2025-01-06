{ config, clan-core, lib, pkgs, ... }:
{
  imports = [
    # Enables the OpenSSH server for remote access
    clan-core.clanModules.sshd
    # Set a root password
    clan-core.clanModules.root-password
    clan-core.clanModules.user-password
    clan-core.clanModules.state-version
  ];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 30;
  };

  clan.user-password.user = "user";

  console.keyMap = "fr-bepo";

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

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  programs = {
    niri.enable = true;
    vim.enable = true;
    waybar.enable = true;
    xwayland.enable = true;
  };

  services = {
    avahi.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        #autoLogin.relogin = true;
        autoNumlock = true;
      };
    };
    xserver = {
      enable = true;
      xkb.layout = "fr";
      windowManager.i3.enable = true;
    };
  };

  system.nixos.variant_id = "installer";

  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH38Iwc5sA/6qbBRL+uot3yqkuACDDu1yQbk6bKxiPGP nim@loon"
    ];
    user = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "input"
      ];
      uid = 1000;
      openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
    };
  };
}
