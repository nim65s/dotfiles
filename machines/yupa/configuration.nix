{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.alloria.nixosModules.control
    ../../modules/disko-zfs.nix
    ../../modules/display.nix
    ../../modules/shared.nix
    # ../../modules/steam.nix
    # ../../modules/teeworlds.nix
    ../../modules/nixos.nix
    ../../modules/wifi-laas.nix
    ../../modules/x86_64-linux.nix
  ];

  # fix wifi disconnects
  # thx https://bbs.archlinux.org/viewtopic.php?id=287947
  boot.kernelParams = [
    "rtw89_core.disable_ps_mode=Y"
    "rtw89_pci.disable_aspm_l1=Y"
    "rtw89_pci.disable_aspm_l1ss=Y"
    "rtw89_pci.disable_clkreq=Y"
  ];
  disko.devices.disk.main = {
    device = "/dev/disk/by-id/nvme-eui.0025388b11b2bd16";
    name = "main-a855f7621e7c4f468b3e94c4ed4ade19";
  };
  home-manager.users.nim = import ../../modules/nim-home.nix;
  networking = {
    interfaces."tinc.mars".ipv4.addresses = [
      {
        address = "10.0.55.203";
        prefixLength = 24;
      }
    ];
    wireless.iwd.settings.DriverQuirks.PowerSaveDisable = "*";
  };
  services = {
    alloria-control = {
      enable = true;
      openFirewall = true;
      rtp-ip = "hattori.m";
    };
    cage = {
      enable = true;
      extraArguments = [ "-s" ];
      program = lib.getExe config.home-manager.users.nim.programs.spicetify.spicedSpotify;
      user = "nim";
    };
  };
  stylix.image = ../../bg/yupa.jpg;
  # services.flatpak.enable = true;
  virtualisation.docker.enable = true;
}
