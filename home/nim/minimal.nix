{
  pkgs,
  ...
}:
{

  imports = [
    ./programs/minimal.nix
    ./ssh.nix
  ];

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
        # "--git-ignore"
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

    fzf = {
      enable = true;
      historyWidget.command = ""; # atuin handle this
    };

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
      settings = {
        "*" = {
          controlMaster = "auto";
          controlPath = "~/.ssh/C-%C";
          controlPersist = "7200";
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
}
