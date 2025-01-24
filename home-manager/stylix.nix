{ lib, pkgs, ... }:
{
  stylix = {
    # Those are handled by catppuccin-nix
    targets = {
      alacritty.enable = false;
      bat.enable = false;
      btop.enable = false;
      fzf.enable = false;
      helix.enable = false;
      swaylock.enable = false;
      vim.enable = false; # TODO
    };
  } // import ../stylix.nix { inherit lib pkgs; };
}
