{
  catppuccin,
  pkgs,
  ...
}:
{

  imports = [
    catppuccin.homeModules.catppuccin
    ./programs/minimal.nix
  ];

  catppuccin = {
    enable = true;
    accent = "blue";
    thunderbird.profile = "nim";
  };

  home = {
    stateVersion = "25.05";
  };

  programs = {
    bat = {
      enable = true;
      config = {
        style = "plain";
      };
      extraPackages = with pkgs.bat-extras; [
        batman
      ];
    };

    btop = {
      enable = true;
      settings.cpu_single_graph = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      git = true;
      icons = "auto";
      extraOptions = [
        "--classify"
        "--color-scale=all"
        "--git-ignore"
        "--group"
        "--header"
        "--hyperlink"
        "--ignore-glob=.git|*.orig|*~"
      ];
    };

    fd = {
      enable = true;
      extraOptions = [
        "--hyperlink"
      ];
    };

    fzf.enable = true;

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };

    home-manager.enable = true;

    lsd = {
      enable = true;
      settings = {
        header = true;
        hyperlink = "auto";
        indicators = true;
        #total-size = true;
      };
    };

    ripgrep = {
      enable = true;
      arguments = [
        "--hyperlink-format=kitty"
      ];
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      includes = [ "local_config" ];
      matchBlocks = {
        "*" = {
          controlMaster = "auto";
          userKnownHostsFile = "~/.ssh/known_hosts ~/dotfiles/known_hosts";
        };
        "gh" = {
          hostname = "github.com";
          user = "git";
          forwardAgent = false;
        };
        "gl" = {
          hostname = "gitlab.laas.fr";
          user = "git";
          forwardAgent = false;
        };
        "laas" = {
          hostname = "ssh.laas.fr";
          user = "gsaurel";
          forwardAgent = true;
        };
        "mononokem" = {
          hostname = "10.0.55.50";
          port = 2222;
          forwardAgent = true;
        };
        ghm = {
          hostname = "github.com";
          user = "git";
          proxyJump = "mononokem";
        };
      };
    };

    starship = {
      enable = true;
    };

    zoxide = {
      enable = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
  };

  stylix = {
    # Those are handled by catppuccin-nix
    targets = {
      alacritty.enable = false;
      bat.enable = false;
      btop.enable = false;
      firefox.enable = false;
      fzf.enable = false;
      halloy.enable = false;
      helix.enable = false;
      kitty.enable = false;
      mako.enable = false; # silence a HM assert in unused module
      neovim.enable = false;
      nixvim.enable = false;
      qt.enable = false;
      starship.enable = false;
      swaylock.enable = false;
      swaync.enable = false;
      yazi.enable = false;
    };
  };
}
