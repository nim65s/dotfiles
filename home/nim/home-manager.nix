# Standalone HM things
# ie. not nixos hm
{
  config,
  lib,
  pkgs,
  stylix,
  ...
}:
{
  imports = [
    stylix.homeModules.stylix
    ../../shared/stylix.nix
  ];

  home = {
    packages = [ pkgs.nix ];
  };
  services.home-manager = {
    autoExpire = {
      enable = true;
      frequency = "weekly";
      store.cleanup = true;
      store.options = "--delete-older-than 30d";
    };
    autoUpgrade = {
      enable = true;
      flakeDir = "${config.nim-home.homeDirectory}/dotfiles";
      frequency = "weekly";
      preSwitchCommands = [ ]; # dont want "nix flake update", default for 26.05
      useFlake = true;
    };
  };

  stylix = {
    # Those are handled by catppuccin-nix
    targets = {
      alacritty.enable = false;
      bat.enable = false;
      btop.enable = false;
      firefox.enable = false;
      fzf.enable = false;
      halloy.enable = false;
      helix.enable = false;
      kitty.enable = false;
      mako.enable = false; # silence a HM assert in unused module
      neovim.enable = false;
      nixvim.enable = false;
      qt.enable = false;
      starship.enable = false;
      swaylock.enable = false;
      swaync.enable = false;
      yazi.enable = false;
      zellij.enable = false;
    };
  };

  systemd.user.services.home-manager-auto-upgrade = {
    Service.ExecStartPre = "${lib.getExe pkgs.git} pull https://github.com/nim65s/dotfiles";
  };
  xdg.portal = {
    enable = true;
    configPackages = [ pkgs.niri ];
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };
}
