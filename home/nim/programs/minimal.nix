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
      if [ -f "~/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "~/.nix-profile/etc/profile.d/nix.sh"
      fi
    '';
  };
}
