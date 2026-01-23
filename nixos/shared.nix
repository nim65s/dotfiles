{
  catppuccin,
  config,
  flake,
  home-manager,
  lib,
  nixvim,
  pkgs,
  stylix,
  ...
}:
{
  imports = [
    home-manager.nixosModules.home-manager
    catppuccin.nixosModules.catppuccin
    nixvim.nixosModules.nixvim
    ./access-tokens.nix
    ./minimal.nix
    ./tinc.nix
  ];

  catppuccin = {
    enable = true;
    accent = lib.mkDefault "blue";
  };

  console.useXkbConfig = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    alacritty
    btop
    coreutils
    cntr
    dfc
    file
    git
    graphviz
    htop
    inetutils
    iproute2
    jq
    kitty
    nettools
    ncdu
    pciutils
    psmisc
    ripgrep
    swaylock
    tig
    tmux
    usbutils
    zellij
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit (config) sops;
      inherit
        catppuccin
        nixvim
        stylix
        ;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.root = import ../home/nim/minimal.nix;
  };

  i18n.defaultLocale = "fr_FR.UTF-8";

  networking = {
    domain = lib.mkDefault "m";
    firewall = {
      allowedTCPPorts = [ 655 ];
      allowedUDPPorts = [ 655 ];
    };
    # https://git.clan.lol/clan/clan-core/commit/122dbf42400ff313bab1b5dcaf6c140cec3704e8
    hosts =
      let
        aliases = {
          "ashitaka.m" = [
            "grafana.m"
            "home-assistant.m"
          ];
        };
        allPeersWithIp = builtins.mapAttrs (
          _: x: lib.removeSuffix "\n" x.config.clan.core.vars.generators.mycelium.files.ip.value
        ) flake.nixosConfigurations;
        myceliumHosts = lib.mapAttrs' (
          host: ip: lib.nameValuePair ip ([ "${host}.m" ] ++ (aliases."${host}.m" or [ ]))
        ) allPeersWithIp;
      in
      myceliumHosts;
    useNetworkd = true;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 60d";
      persistent = false;
    };
    settings = {
      accept-flake-config = false;
      extra-substituters = [
        "https://gepetto.cachix.org"
        "https://nix-community.cachix.org"
        "https://rycee.cachix.org"
        "https://ros.cachix.org"
      ];
      extra-trusted-public-keys = [
        "gepetto.cachix.org-1:toswMl31VewC0jGkN6+gOelO2Yom0SOHzPwJMY2XiDY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "rycee.cachix.org-1:TiiXyeSk0iRlzlys4c7HiXLkP3idRf20oQ/roEUAh/A="
        "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = lib.attrValues flake.overlays;
  };

  programs = {
    fish.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
    };
    nix-ld.enable = true;
    trippy.enable = true;
    vim.enable = true;
    nixvim = import ../shared/nixvim.nix { inherit lib; } // {
      enable = true;
      defaultEditor = true;
    };
  };

  services = {
    arsenik = {
      enable = true;
      package = pkgs.arsenik.overrideAttrs {
        patches = [
          (pkgs.fetchpatch {
            name = "kanata-numpad-add-operators.patch";
            url = "https://github.com/OneDeadKey/arsenik/pull/77.patch";
            hash = "sha256-fIGp9IZ19gUq5tsnuX4I2KOLBA7HaF6u1berDleSnKg=";
          })
        ];
      };
      long_hold_timeout = 180;
      lt = true;
      vim = true;
    };
    avahi.enable = true;

    fwupd.enable = true;

    kanata.keyboards.arsenik.extraArgs = [ "-q" ];

    locate.enable = true;

    udev.packages = [
      pkgs.stlink
    ];

    upower.enable = true;
  };

  system.autoUpgrade = {
    enable = lib.mkDefault true;
    flake = "github:nim65s/dotfiles";
  };

  users.users = {
    root.shell = pkgs.fish;
    nim = {
      isNormalUser = true;
      extraGroups = [
        "dialout"
        "docker"
        "input"
        "networkmanager"
        "plugdev"
        "video"
        "wheel"
      ];
      uid = 1000;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
    };
  };
}
