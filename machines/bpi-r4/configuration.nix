{
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ./bpi-r4.nix
  ];
  services.getty.autologinUser = "root";
}
