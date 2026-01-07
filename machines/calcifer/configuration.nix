{
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    ./bpi-r4.nix
  ];

  boot.supportedFilesystems.zfs = false;

  networking.useDHCP = false;
  systemd.network.enable = true;

  powerManagement.cpuFreqGovernor = "ondemand";

  services.irqbalance.enable = true;

  environment.systemPackages = [
    pkgs.conntrack-tools
    pkgs.ethtool
    pkgs.i2c-tools
    pkgs.python313Packages.wakeonlan
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
}
