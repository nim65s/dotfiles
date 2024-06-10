# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    firewall.enable = true;
    hostName = "loon"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure keymap in X11
  #xserver.xkb = {
  #  layout = "fr";
  #  variant = "bepo";
  #};

  # Configure console keymap
  console.keyMap = "fr-bepo";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nim = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Guilhem Saurel";
    extraGroups = [
      "dialout"
      "networkmanager"
      "wheel"
      "docker"
      "video"
    ];
    packages = with pkgs; [ ];
  };

  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    settings = {
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://nim65s-dotfiles.cachix.org"
        "https://nim65s-nur.cachix.org"
        "https://rycee.cachix.org"
        "https://cache.lix.systems"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nim65s-dotfiles.cachix.org-1:6vuY5z8YGzfjrssfcxb3DuH50DC1l562U0BIGMxnClg="
        "nim65s-nur.cachix.org-1:V3uaUnDnkWYgPDZaXpoe/KIbX5913GWfkazhHVDYPoU="
        "rycee.cachix.org-1:TiiXyeSk0iRlzlys4c7HiXLkP3idRf20oQ/roEUAh/A="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  fonts = {
    fontconfig = {
      defaultFonts = {
        serif = [ "Source Serif 4" ];
        sansSerif = [ "Source Sans 3" ];
        monospace = [ "SauceCodePro Nerd Font" ];
      };
    };
  };
  hardware.opengl.enable = true;
  programs.dconf.enable = true;
  programs.fish.enable = true;
  virtualisation.docker.enable = true;
  sound.enable = false;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services = {
    getty.autologinUser = "nim";
    openssh.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      audio.enable = true;
      pulse.enable = true;
    };
    #xdg.portal.wlr.enable = true;

    udev.packages = [ pkgs.stlink ];
  };
}
