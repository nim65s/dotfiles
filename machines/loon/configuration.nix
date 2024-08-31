{ config, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  boot = {
    #binfmt.emulatedSystems = [ "aarch64-linux" ];
    initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };
  };
  console.keyMap = "fr-bepo";
  services.getty.autologinUser = config.my-username;
  system.stateVersion = "23.05"; # Did you read the comment?
}
