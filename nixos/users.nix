{ pkgs, ... }:
{
  users.users =
    let
      common = {
        openssh.authorizedKeys.keyFiles = [
          ../pubkeys/hatto
          ../pubkeys/loon
          ../pubkeys/upe
          ../pubkeys/yubi
        ];
        shell = pkgs.fish;
      };
    in
    {
      root = common;
      nim = common // {
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
      };
    };
}
