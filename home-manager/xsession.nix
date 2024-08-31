{ config, ... }:
{
  xsession = {
    enable = true;
    numlock.enable = true;
    windowManager.i3 = {
      config = config.my-i3;
      enable = true;
    };
  };
}
