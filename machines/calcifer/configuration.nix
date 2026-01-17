{
  ...
}:
{
  imports = [
    ../bpi-r4/bpi-r4.nix
    ../../nixos/disko/ext4-swap.nix
    ../../nixos/shared.nix
  ];

  networking.useDHCP = false;
}
