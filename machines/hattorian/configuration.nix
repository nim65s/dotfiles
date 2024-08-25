{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot = {
    # Setup keyfile
    initrd = {
      secrets = {
        "/crypto_keyfile.bin" = null;
      };
      luks.devices."luks-4ab47c02-8ffd-4e89-9a1f-1b6d1bdfc829" = {
        device = "/dev/disk/by-uuid/4ab47c02-8ffd-4e89-9a1f-1b6d1bdfc829";
        keyFile = "/crypto_keyfile.bin";
      };
    };
  };

  console.keyMap = "fr-bepo";

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    stlink
  ];

  networking.hostName = "hattorixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nim = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Guilhem Saurel";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "docker"
      "video"
      "input"
    ];
    packages = [ ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.dconf.enable = true;

  security.pam.services.swaylock = { };

  services = {
    getty.autologinUser = "nim";
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    sshd.enable = true;
    udev.packages = [ pkgs.stlink ];
    xserver = {
      #libinput.enable = true;
      displayManager = {
        startx.enable = true;
      };
      enable = true;
      xkb = {
        layout = "fr";
        variant = "bepo";
      };
    };
  };

  virtualisation.docker.enable = true;

  xdg.portal = {
    config.common.default = [
      "wlr"
      "gtk"
    ];
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
