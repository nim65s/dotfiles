{ pkgs, ... }:
let
  keyFiles = [
    ../pubkeys/hatto
    ../pubkeys/loon
    ../pubkeys/upe
    ../pubkeys/yubi
  ];
in
{
  users.users = {
    root = {
      openssh.authorizedKeys.keyFiles = keyFiles;
    };
    nim = {
      shell = pkgs.fish;
      isNormalUser = true;
      description = "Guilhem Saurel";
      extraGroups = [
        "dialout"
        "networkmanager"
        "wheel"
        "docker"
        "video"
        "wireshark"
      ];
      openssh.authorizedKeys.keyFiles = keyFiles;
    };
  };
}
