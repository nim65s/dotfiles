{
  pkgs,
  ...
}:
{
  imports = [
    # inputs.alloria.nixosModules.control
    ../../nixos/disko/zfs.nix
    ../../nixos/display.nix
    ../../nixos/laptop.nix
    ../../nixos/monitored.nix
    ../../nixos/shared.nix
    # ../../nixos/steam.nix
    # ../../nixos/teeworlds.nix
    ../../nixos/nixos.nix
    ../../nixos/wifi-laas.nix
    ../../nixos/systemd-boot.nix
  ];

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    # fix wifi disconnects
    # thx https://bbs.archlinux.org/viewtopic.php?id=287947
    kernelParams = [
      "rtw89_core.disable_ps_mode=Y"
      "rtw89_pci.disable_aspm_l1=Y"
      "rtw89_pci.disable_aspm_l1ss=Y"
      "rtw89_pci.disable_clkreq=Y"
    ];
  };
  disko.devices.disk.main = {
    device = "/dev/disk/by-id/nvme-eui.0025388b11b2bd16";
    name = "main-a855f7621e7c4f468b3e94c4ed4ade19";
  };
  home-manager.users.nim = import ../../home/nim/main.nix;
  networking = {
    interfaces."tinc.mars".ipv4.addresses = [
      {
        address = "10.0.55.203";
        prefixLength = 24;
      }
    ];
    wireless.iwd.settings.DriverQuirks.PowerSaveDisable = "*";
    networkmanager.wifi.powersave = false;
  };
  services = {
    # alloria-control = {
    #   enable = true;
    #   openFirewall = true;
    #   rtp-ip = "hattori.m";
    # };
  };
  stylix.image = ../../bg/yupa.jpg;
  # services.flatpak.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # thermostasvenoh
  boot.blacklistedKernelModules = [ "rtw88_8822bu" ];
  services.udev = {
    extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="2357", ATTR{idProduct}=="0138", \
        MODE="0660", GROUP="wheel"
    '';
    packages = [ pkgs.probe-rs-tools ];
  };
}
