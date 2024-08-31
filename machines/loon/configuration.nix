_:
{
  imports = [ ./hardware-configuration.nix ];
  boot = {
    #binfmt.emulatedSystems = [ "aarch64-linux" ];
    initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };
  };
  clan.core.networking.targetHost = "root@loon";
  console.keyMap = "fr-bepo";
  services.getty.autologinUser = "nim";
  system.stateVersion = "23.05"; # Did you read the comment?
}
