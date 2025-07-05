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
      accent = "yellow";
    };

    home = {
      homeDirectory = "/home/fil";
      username = "fil";
      keyboard.layout = "fr";
      packages = [
      ];
      stateVersion = "25.05";
    };

    programs = {
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
    };

    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };

    stylix = {
      cursor = {
        name = "catppuccin-mocha-yellow-cursors";
        package = pkgs.catppuccin-cursors.mochaYellow;
        size = 16;
      };
      targets = {
        mako.enable = false; # silence a HM assert
        qt.enable = false;
        starship.enable = false;
      };
    };
  };
}
