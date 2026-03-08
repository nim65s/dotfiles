{
  ...
}:
{
  imports = [
    ../../home/nim/main.nix
    ../../home/nim/azv-mpc.nix
  ];

  programs = {
    rmpc.config = ''
      (
        address = "calcifer.azv:6600",
      )
    '';
  };
}
