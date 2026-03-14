{
  ...
}:
{
  imports = [
    ../../home/homeModules/snapclient.nix
  ];

  services.snapclient.enable = true;

  home.stateVersion = "25.05";
}
