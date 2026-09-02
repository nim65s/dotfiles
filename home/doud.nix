{
  pkgs,
  ...
}:
{
  config = {
    home = {
      homeDirectory = "/home/doud";
      username = "doud";
      keyboard.layout = "fr";
      packages = [
        pkgs.chromium
        pkgs.libreoffice
        pkgs.sweethome3d.application
        pkgs.vlc
      ]
      ++ (with pkgs.kdePackages; [
        kmines
      ]);
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
