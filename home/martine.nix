{
  pkgs,
  ...
}:
{
  config = {
    home = {
      homeDirectory = "/home/martine";
      username = "martine";
      keyboard.layout = "fr";
      packages = [
        pkgs.five-or-more
        pkgs.vlc
      ];
      stateVersion = "25.05";
    };

    programs = {
      element-desktop.enable = true;
      fish.enable = true;
      firefox = {
        enable = true;
        configPath = ".mozilla/firefox"; # Too lazy to switch to new "${config.xdg.configHome}/mozilla/firefox";
        languagePacks = [
          "fr"
          "en"
        ];
      };
      kitty = {
        enable = true;
        settings = {
          enabled_layouts = "splits,fat,tall,grid,horizontal,vertical,stack";
          focus_follows_mouse = true;
          scrollback_pager_history_size = 2;
          shell = "fish";
          tab_bar_style = "powerline";
        };
      };
      starship.enable = true;
    };
  };
}
