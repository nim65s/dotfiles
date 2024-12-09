_: {
  imports = [ ./hardware-configuration.nix ];
  boot = {
    #binfmt.emulatedSystems = [ "aarch64-linux" ];
    initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };
  };
  clan.core.networking = {
    targetHost = "root@loon";
    zerotier.controller = {
      enable = true;
      public = true;
    };
  };
  console.keyMap = "fr-bepo";
  services.getty.autologinUser = "nim";
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = false;
    desktopManager.gnome.enable = false;
    xkb.layout = "fr";
    xkb.variant = "bepo";
    windowManager.i3.enable = true;
  };
  system.stateVersion = "23.05"; # Did you read the comment?
}
