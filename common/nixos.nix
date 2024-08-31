{ allSystems, config, inputs, pkgs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.clan-core.clanModules.iwd
    ./nixgl.nix
    ./i3sway.nix
    ./my-i3.nix
    ./my-sway.nix
    ./my-home.nix
    ./my-programs.nix
    ./my-firefox.nix
  ];
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  clan.iwd.networks = {
    baron.ssid = "Baron";
    sabliere.ssid = "Livebox-7730";
  };
  environment.systemPackages = with pkgs; [
    git
    vim
  ];
  fonts = {
    fontconfig = {
      defaultFonts = {
        serif = [ "Source Serif 4" ];
        sansSerif = [ "Source Sans 3" ];
        monospace = [ "SauceCodePro Nerd Font" ];
      };
    };
  };
  hardware = {
    graphics.enable = true;
    pulseaudio.enable = false;
  };
  home-manager = {
    useGlobalPkgs = true;
    users.${config.my-username} = config.my-home;
  };
  i18n = {
    defaultLocale = "fr_FR.UTF-8";
    extraLocaleSettings = {
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
  };
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    package = pkgs.lix;
    settings = {
      extra-substituters = [
        "https://gepetto.cachix.org"
        "https://nim65s.cachix.org"
        "https://nix-community.cachix.org"
        "https://rycee.cachix.org"
      ];
      extra-trusted-public-keys = [
        "gepetto.cachix.org-1:toswMl31VewC0jGkN6+gOelO2Yom0SOHzPwJMY2XiDY="
        "nim65s.cachix.org-1:aycmWbuJijDcr9npRLM/2X76kY86iToBI2tlkpp2BLE="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "rycee.cachix.org-1:TiiXyeSk0iRlzlys4c7HiXLkP3idRf20oQ/roEUAh/A="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  nixpkgs = {
    inherit (allSystems.${config.nixpkgs.hostPlatform.system}._module.args) pkgs;
  };
  programs = {
    dconf.enable = true;
    fish.enable = true;
  };
  security.rtkit.enable = true;
  services = {
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
  time.timeZone = "Europe/Paris";
  users.users.${config.my-username} = {
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
  };
  virtualisation.docker.enable = true;
}
