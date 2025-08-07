{
  imports = [
    ./home-manager.nix
  ];

  laasProxy.enable = false;

  nim-home.username = "gsaurel";
  home.sessionVariables = {
    LD_PRELOAD = "/lib/x86_64-linux-gnu/libnss_sss.so.2";
  };
}
