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
      accent = "red";
      firefox.profiles.mimi = {
        enable = true;
        force = true;
      };
    };

    home = {
      homeDirectory = "/home/mimi";
      username = "mimi";
      keyboard.layout = "fr";
      packages =
        with pkgs;
        [
          gcompris
          klavaro
          # libsForQt5.ktouch # TODO: broken on qt6
          superTuxKart
          teeworlds
          vlc
        ]
        ++ (with kdePackages; [
          # keep-sorted start
          bomber
          granatier
          kapman
          kblocks
          kbounce
          kbreakout
          kfourinline
          kmahjongg
          kpat
          blinken
          kanagram
          khangman
          ksudoku
          kmines
          kgeography
          kturtle
          # kstars  # TODO: build broken
          minuet
          # keep-sorted end
        ]);
      stateVersion = "25.05";
    };

    programs = {
      fish.enable = true;
      firefox = {
        enable = true;
        package = pkgs.firefox-devedition;
        languagePacks = [ "fr" ];
        profiles.mimi = {
          id = 0;
          name = "dev-edition-default";
          path = "nim.dev-edition-default";
          isDefault = true;
          extensions.force = true;
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            firefox-color
            ublock-origin
          ];
        };
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
        name = "catppuccin-mocha-red-cursors";
        package = pkgs.catppuccin-cursors.mochaRed;
        size = 24;
      };
      targets = {
        mako.enable = false; # silence a HM assert
        qt.enable = false;
        starship.enable = false;
      };
    };
  };
}
