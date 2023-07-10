{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = import ~/.config/home-manager/local-username.nix;
  home.homeDirectory = import ~/.config/home-manager/local-home-directory.nix;

  home.enableDebugInfo = true;

  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
    bacon
    cargo-binstall
    cargo-release
    ccze
    clang_16
    cmake
    dfc
    docker-compose
    du-dust
    #eigen
    element-desktop-wayland
    evince
    eww-wayland
    exa
    fd
    file
    fishPlugins.bass
    git
    grim
    helix
    htop
    hyprland
    hyprpaper
    hyprpicker
    inetutils
    imv
    just
    khal
    khard
    #llvmPackages_16.bintools
    mdbook
    mpv
    ninja
    okular
    openssl
    pass
    pdfpc
    #pipewire
    pkg-config
    #poetry
    #poetryPlugins.poetry-plugin-up
    #python310Packages.boost
    #python310Packages.django
    #python310Packages.i3ipc
    #python310Packages.ipython
    #python310Packages.numpy
    #python310Packages.pandocfilters
    #python310Packages.python
    ripgrep
    rustup
    sd
    sccache
    shellcheck
    spotify
    sqlite
    starship
    swappy
    tree
    tig
    tinc
    todoman
    vdirsyncer
    vlc
    watchexec
    wev
    #wireplumber
    xdg-desktop-portal-hyprland
    zathura
    zellij
    zoom-us
  ];

  home.file = {
    ".config/dfc/dfcrc".source = ~/dotfiles/.config/dfc/dfcrc;
    ".config/starship.toml".source = ~/dotfiles/.config/starship.toml;
    ".pypirc".source = ~/dotfiles/.pypirc;
    ".latexmkrc".source = ~/dotfiles/.latexmkrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    SHELL = "fish";  # TODO: pkgs.fish.….path
  };

  gtk = {
    enable = true;
    # TODO cursorTheme
    # TODO font
    theme.package = pkgs.gnome.adwaita-icon-theme;
    theme.name = "Adwaita";
  };

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = { sync_address = "https://atuin.datcat.fr"; };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "zenburn";
      pager = "less";
    };
    extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch ];
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    profiles.nim = {
      id = 0;
      name = "dev-edition-default";
      path = "nim.dev-edition-default";
      isDefault = true;
      search.force = true;
      search.engines = {
        "Nix Packages" = {
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];
        };
      };
      settings = {
       "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = ''
        #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar {
          opacity: 0;
          pointer-events: none;
          margin-bottom: -44px !important;
        }
        #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
            visibility: collapse !important;
        }
        #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
          display: none;
        }
      '';
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      test -f ~/dotfiles/.config/fish/config.fish
      and source ~/dotfiles/.config/fish/config.fish
      '';
  };

  programs.git = {
    enable = true;
    delta.enable = true;
    lfs.enable = true;
    userName = "Guilhem Saurel";
    userEmail = "guilhem.saurel@laas.fr";
    includes = [
      {
        contents = {
          core = { excludesfile = "~/dotfiles/gitignore"; };
          push = { default = "simple"; };
          user = { signingKey = "4653CF28"; };
          pull = { ff = "only"; };
          init = { defaultBranch = "main"; };
          hub = { protocol = "ssh"; };
          submodule = { fetchJobs = 4; };
          fetch = { parallel = 4; };
          blame = { ignoreRevsFile = ".git-blame-ignore-revs"; };
        };
      }
      { path = "~/dotfiles/.gitconfig"; }
    ];
  };

  programs.home-manager.enable = true;

  programs.kitty = {
    enable = true;
    # TODO font.package = (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; });
    keybindings = {
      "kitty_mod+left" = "resize_window narrower";
      "kitty_mod+right" = "resize_window wider";
      "kitty_mod+up" = "resize_window taller";
      "kitty_mod+down" = "resize_window shorter";
      "alt+n" = "launch --location=split --cwd=current";
      "alt+m" = "launch --location=hsplit --cwd=current";
      "alt+z" = "launch --location=vsplit --cwd=current";
      "kitty_mod+n" = "new_os_window_with_cwd";
      "alt+t" = "next_window";
      "alt+s" = "previous_window";
      "alt+shift+t" = "move_window_forward";
      "alt+shift+s" = "move_window_backward";
      "alt+shift+d" = "detach_window";
      "alt+l" = "next_tab";
      "alt+v" = "previous_tab";
      "alt+d" = "new_tab_with_cwd";
      "alt+plus" = "layout_action increase_num_full_size_windows";
      "alt+minus" = "layout_action decrease_num_full_size_windows";
      "kitty_mod+plus" = "change_font_size all +1.0";
      "kitty_mod+minus" = "change_font_size all -1.0";
    };
    settings = {
      "touch_scroll_multiplier" = "10.0";
      "focus_follows_mouse" = true;
      "enable_audio_bell" = false;
      "enabled_layouts" = "splits,fat,tall,grid,horizontal,vertical,stack";
      "placement_strategy" = "top-left";
      "tab_bar_style" = "powerline";
      "tab_separator" = " | ";
      "background_opacity" = "0.7";
      "shell" = "fish";
    };
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
    settings = {
      header = true;
      hyperlink = "auto";
      indicators = true;
      ignore-globs = [
        ".git"
        "*.orig"
        "*~"
      ];
      total-size = true;
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
      color-enabled = true;
      matching = "fuzzy";
      no-lazy-grab = true;
    };
  };

  programs.ssh = {
    enable = true;
    controlMaster = "yes";
    includes = [ "local_config" ];
    matchBlocks = {
      "gh" = {
        hostname = "github.com";
        user = "git";
      };
      "gl" = {
        hostname = "gitlab.laas.fr";
        user = "git";
      };
      "laas" = {
        hostname = "ssh.laas.fr";
        user = "gsaurel";
      };
      "upe" = {
        hostname = "upepesanke";
        user = "gsaurel";
        proxyJump = "laas";
      };
      "totoro" = {
        hostname = "totoro.saurel.me";
        user = "nim";
      };
      "nausicaa" = {
        hostname = "192.168.8.112";
        proxyJump = "totoro";
      };
    };
  };

  programs.starship.enable = true;

  /* TODO
  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      show-failed-attempts = true;
    };
  };
  */

  programs.vim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs; [
      vimPlugins.ale
      vimPlugins.colorizer
      vimPlugins.file-line
      vimPlugins.nerdcommenter
      vimPlugins.vim-airline
      vimPlugins.vim-airline-themes
      vimPlugins.vim-clang-format
      vimPlugins.vim-fugitive
      vimPlugins.vim-nix
      vimPlugins.vim-sensible
      vimPlugins.vim-signify
      vimPlugins.vim-toml
      vimPlugins.yuck-vim
      vimPlugins.zenburn
    ];
    settings = {
      backupdir = [ "~/.vim/tmp" "~/.tmp" "~/tmp" "/var/tmp" "/tmp" ];
      directory = [ "~/.vim/tmp" "~/.tmp" "~/tmp" "/var/tmp" "/tmp" ];
      copyindent = true;
      expandtab = true;
      hidden = true;
      history = 1001;
      ignorecase = true;
      modeline = true;
      mouse = "a";
      mousefocus = true;
      mousehide = false;
      number = true;
      shiftwidth = 4;
      smartcase = true;
      tabstop = 8;
      undofile = true;
    };
    extraConfig = ''
      if empty($DOTFILES)
        let $DOTFILES = expand("~/dotfiles")
      endif
      let $VIMRC = $DOTFILES .. "/.vimrc"
      if filereadable($VIMRC)
        source $VIMRC
      endif
    '';
  };

  programs.zathura = {
    enable = true;
    mappings = {
      r = "reload";
      t = "navigate next";
      s = "navigate previous";
      v = "zoom in";
      l = "zoom out";
      q = "quit";
      n = "rotate";
    };
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "keyboard";
        geometry = "0x5-10+10";
        indicate_hidden = true;
        padding = 10;
        horizontal_padding = 10;
        sort = true;
        format = "<b>%s</b>\n%b";
        # browser = /usr/bin/firefox-developer -new-tab
        # TODO browser = pkgs.firefox.….path -new-tab
      };
    };
  };
}
