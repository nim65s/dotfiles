{
  ...
}:
{
  imports = [ ../../home/nim/main.nix ];

  programs = {
    rmpc.config = ''
      (
        address = "calcifer.azv:6600",
      )
    '';
  };
}
