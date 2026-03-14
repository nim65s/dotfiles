{
  ...
}:
{
  imports = [
    ../../home/nim/main.nix
  ];

  programs = {
    rmpc.config = ''
      (
        address = "spare.w:6600",
      )
    '';
  };

  services.snapclient = {
    enable = true;
    autoStart = false;
  };
}
