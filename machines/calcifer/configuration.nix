{
  ...
}:
{
  imports = [
    ../bpi-r4/bpi-r4.nix
    ../../nixos/shared.nix
  ];

  networking.useDHCP = false;
}
