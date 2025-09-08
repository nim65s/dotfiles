{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  config = {
    catppuccin = {
      enable = true;
      accent = "sapphire";
    };

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

    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };

    stylix = {
      cursor = {
        name = "catppuccin-mocha-sapphire-cursors";
        package = pkgs.catppuccin-cursors.mochaSapphire;
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
