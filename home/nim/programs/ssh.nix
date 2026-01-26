{
  config,
  ...
}:
{
  programs.ssh = {
    matchBlocks = {
      "upe" = config.laasProxy.value // {
        hostname = "upepesanke";
        user = "gsaurel";
      };
      "miya" = config.laasProxy.value // {
        hostname = "miyanoura";
        user = "gsaurel";
      };
      "calcifer" = {
        hostname = "calcifer.saurel.me";
        user = "nim";
        forwardAgent = true;
      };
      "totoro" = {
        user = "nim";
        forwardAgent = true;
      };
      "ashitaka" = {
        user = "nim";
        forwardAgent = true;
      };
      "datcat" = {
        port = 2222;
        user = "root";
        hostname = "%h.fr";
        forwardAgent = true;
      };
      "marsbase" = {
        user = "root";
        hostname = "192.168.1.1";
        extraOptions = {
          HostKeyAlgorithms = "+ssh-rsa";
          PubkeyAcceptedKeyTypes = "+ssh-rsa";
        };
      };
      "*.l" = config.laasProxy.value // {
        hostname = "%haas.fr";
        forwardAgent = true;
        user = "gsaurel";
      };
      "*.L" = config.laasProxy.value // {
        hostname = "%haas.fr";
        forwardAgent = true;
        user = "root";
      };
      "*.m" = {
        forwardAgent = true;
      };
      "*.M" = {
        forwardAgent = true;
        user = "root";
      };
      "*.t" = {
        hostname = "%hetaneutral.net";
        user = "root";
        port = 2222;
      };
    };
  };
}
