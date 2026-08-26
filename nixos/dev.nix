{
  ...
}:
{
  services = {
    earlyoom = {
      enable = true;
      enableNotifications = true;
      extraArgs = [
        "--prefer"
        "(^|/)(cc|cpp|gcc|g++|cc1|cc1plus|clang|clang++)$"
      ];
    };
  };
}
