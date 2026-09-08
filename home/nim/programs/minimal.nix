{
  imports = [
    ./fish.nix
    ./git.nix
    ./ssh.nix
    ./starship.nix
    ./yazi.nix
  ];

  programs.bash = {
    enable = true;
    profileExtra = ''
      if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi
    '';
  };
}
