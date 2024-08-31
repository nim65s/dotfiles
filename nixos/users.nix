{ config, pkgs, ... }:
{
  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH38Iwc5sA/6qbBRL+uot3yqkuACDDu1yQbk6bKxiPGP nim@loon"
    ];
    ${config.my-username} = {
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
  };
}
