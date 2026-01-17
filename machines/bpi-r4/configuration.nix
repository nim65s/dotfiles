{
  config,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ./bpi-r4.nix
    ../../nixos/minimal.nix
  ];

  environment.systemPackages = [ pkgs.disko ];
  services.getty.autologinUser = "root";

  # make uboot-combined available on sdImage / to allow easy dd
  sdImage.populateRootCommands = ''
    cp ${config.system.build.uboot}/uboot.img ./files/u-boot-bpi-r4-nand.img
  '';
}
