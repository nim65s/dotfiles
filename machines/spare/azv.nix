{
  ...
}:
{
  imports = [
    ../../nixos/small.nix
    ../../nixos/nas.nix
  ];

  fileSystems."/mnt/totoro".options = [
    "x-systemd.after=systemd-networkd-wait-online@eno1.service"
    "x-systemd.requires=systemd-networkd-wait-online@eno1.service"
  ];

  networking.firewall.allowedTCPPorts = [
    8080
    9090
    9777
    8095 # music-assistant
  ];

  # kodi

  services.displayManager = {
    autoLogin.user = "kodi";
    sddm.enable = false;
    defaultSession = "kodi";
  };

  users.extraUsers.kodi.isNormalUser = true;
  home-manager.users.kodi = import ./home.nix;
  home-manager.users.nim.nim-home.gui = false;

  services.xserver = {
    enable = true;
    desktopManager.kodi.enable = true;
    displayManager = {
      lightdm.greeter.enable = false;
    };
  };

  # music-assistant

  services = {
    music-assistant = {
      enable = true;
      openFirewall = true;
      providers = [
        "filesystem_nfs"
        "listenbrainz_scrobble"
        "lrclib"
        "sendspin"
      ];
    };
  };
}
