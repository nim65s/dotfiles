{
  catppuccin,
  pkgs,
  ...
}:
{
  imports = [
    catppuccin.homeModules.catppuccin
  ];

  config = {
    catppuccin = {
      enable = true;
      accent = "blue";
      flavor = "latte";
    };

    gtk.gtk4.theme = null; # silence 26.05 warning
    home = {
      homeDirectory = "/home/fil";
      username = "fil";
      keyboard.layout = "fr";
      packages = [
        pkgs.vlc
      ];
      stateVersion = "25.05";
    };

    programs = {
      element-desktop.enable = true;
      firefox = {
        enable = true;
        configPath = ".mozilla/firefox"; # Too lazy to switch to new "${config.xdg.configHome}/mozilla/firefox";
        languagePacks = [
          "fr"
          "en"
        ];
      };
      fish.enable = true;
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
      thunderbird = {
        enable = true;
        languagePacks = [ "fr" ];
        profiles.fil.isDefault = true;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };

    stylix = {
      cursor = {
        name = "catppuccin-latte-blue-cursors";
        package = pkgs.catppuccin-cursors.latteBlue;
        size = 24;
      };
      targets = {
        firefox.enable = false;
        mako.enable = false; # silence a HM assert
        qt.enable = false;
        starship.enable = false;
      };
    };
  };
}
