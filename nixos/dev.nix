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
        "(^|/)(cc|cpp|gcc|g++|cc1plus)$"
      ];
    };
  };
}
