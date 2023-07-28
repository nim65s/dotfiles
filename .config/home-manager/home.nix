{ config, pkgs, ... }:

let
  gruppled-white-lite-cursors = pkgs.callPackage ~/dotfiles/nimxpkgs/gruppled-lite-cursors {
    theme = "gruppled_white_lite";
  };
  sauce-code-pro = pkgs.nerdfonts.override {
    fonts = [ "SourceCodePro" ];
  };
  local = import ~/.config/home-manager/local.nix;
in

{
  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;

  home.username = local.username;
  home.homeDirectory = local.homeDirectory;

  home.enableDebugInfo = true;

  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    bacon
    black
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
    gnupg
    gtklock
    gtklock-userinfo-module
    gtklock-powerbar-module
    gtklock-playerctl-module
    grim
    helix
    htop
    httpie
    hyprpaper
    hyprpicker
    inetutils
    imv
    isort
    pinentry
    just
    khal
    khard
    #llvmPackages_16.bintools
    mdbook
    mpv
    ninja
    nixpkgs-review
    okular
    openssl
    pass
    pavucontrol
    pdfpc
    #pipewire
    pkg-config
    playerctl
    #poetry
    #poetryPlugins.poetry-plugin-up
    #python310Packages.boost
    #python310Packages.django
    #python310Packages.i3ipc
    #python310Packages.ipython
    #python310Packages.numpy
    #python310Packages.pandocfilters
    #python310Packages.python
    #python310Packages.poetry-dynamic-versioning
    pre-commit
    ripgrep
    ruff
    rustup
    sauce-code-pro
    sd
    sccache
    shellcheck
    source-sans
    sqlite
    starship
    swappy
    thunderbird
    tig
    tinc
    todoman
    tree
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

  home.pointerCursor = {
    package = gruppled-white-lite-cursors;
    name = "gruppled_white_lite";
    gtk.enable = true;
  };

  home.file = {
    ".config/dfc/dfcrc".source = ~/dotfiles/.config/dfc/dfcrc;
    ".config/starship.toml".source = ~/dotfiles/.config/starship.toml;
    ".pypirc".source = ~/dotfiles/.pypirc;
    ".latexmkrc".source = ~/dotfiles/.latexmkrc;
    ".icons".source = ~/.nix-profile/share/icons;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    SHELL = "${pkgs.fish}/bin/fish";
  };

  gtk = {
    enable = true;
    font.name = "Source Sans";
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

  programs.btop = {
    enable = true;
    settings = {
      cpu_single_graph = true;
    };
  };

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [ "--ozone-platform=wayland" ];
  };

  programs.firefox = import ~/dotfiles/.config/home-manager/firefox.nix pkgs;

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
    font.name = "Source Code Pro";
    font.size = 8;
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

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "${local.homeDirectory}/.password-store";
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "Source Code Pro 12";
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

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 20;
        output = local.waybar.output;
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ ];
        modules-right = [ "custom/media" "pulseaudio" "network" "memory" "cpu" "temperature" "battery" "clock" "tray"];

        "tray" = { "spacing" = 10; };
        "cpu" = { "format" = "{}% "; };
        "memory" = { "format" = "{}% "; };
        "battery" = {
          "states" = {
            "good" = 80;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          "format-good" = "";
          "format-full" = "";
          "format-icons" = ["" "" "" "" ""];
        };
        "clock" ={
          #"timezone" = "Europe/Paris";
          "tooltip-format" = "<tt>{calendar}</tt>";
          "format-alt" = "{:%Y-%m-%d}";
        };
        "pulseaudio" = {
          "scroll-step" = 1;
          "format" = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = " {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" "" ""];
          };
          "on-click" = "pavucontrol";
        };
        "network" = {
            "format-wifi" = "{essid} ({signalStrength}%) ";
            "format-ethernet" = "{ipaddr}/{cidr} 🌍";
            "tooltip-format" = "{ifname} via {gwaddr} 🌍";
            "format-linked" = "{ifname} (No IP) 🌍";
            "format-disconnected" = "Disconnected 🌍";
            "format-alt" = "{ifname}: {ipaddr}/{cidr}";
        };
        "hyprland/workspaces" = {
          "format" = "{icon}";
          "on-click" = "activate";
          "on-scroll-up" = "hyprctl dispatch workspace e+1";
          "on-scroll-down" = "hyprctl dispatch workspace e-1";
        };
        "custom/media" = {
          "format" = "{icon}{}";
          "return-type" = "json";
          "format-icons" = {
            "Playing" = " ";
            "Paused" = " ";
          };
          "max-length" = 70;
          "exec" = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{album}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
          "on-click" = "playerctl play-pause";
          "on-click-right" = "playerctl next";
        };
      };
    };
    #style = {
    #};
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
        font = "Source Sans";
        browser = "${pkgs.firefox-devedition}/bin/firefox -new-tab";
      };
    };
  };

  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username = "nim65s";
        password_cmd = "pass hm/spotify";
        device_name = "home-manager";
        device_type = "computer";
        backend = "pulseaudio";
      };
    };
  };

  services.swayosd.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = local.hyprland.exec-once ++ [
        "hyprpaper"
        "waybar"
        "nixGL firefox"
        "element-desktop"
      ];
      monitor = local.hyprland.monitor;
      workspace = local.hyprland.workspace;
      env = "PATH, ${local.homeDirectory}/.nix-profile/bin:${local.homeDirectory}/.local/bin:/nix/var/nix/profiles/default/bin:/opt/openrobots/bin:/usr/local/bin:/usr/bin:/bin";
      source = "~/dotfiles/.config/hypr/hyprland.conf";
    };
  };
}
