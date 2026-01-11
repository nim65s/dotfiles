{
  catppuccin,
  pkgs,
  ...
}:
{

  imports = [
    catppuccin.homeModules.catppuccin
    ./starship.nix
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
    fish = {
      enable = true;
      interactiveShellInit = ''
        set -U fish_color_autosuggestion cba6f7 #cba6f7
        set -U fish_color_comment 94e2d5        #94e2d5
        set -U fish_color_end cdd6f4            #cdd6f4
        set -U fish_color_param 89b4fa          #89b4fa
        for viewer in evince okular tdf zathura
            complete -c $viewer -a '(__fish_complete_pdf)' -f
        end
        for d in /run/system-manager/sw/bin ~/.nix-profile/bin ~/.local/bin
            if path is -dq $d and not contains $d $PATH
                set PATH $d $PATH
            end
        end
      '';
      functions = {
        __fish_complete_pdf = ''
          fd --no-ignore -e pdf
        '';
        # thanks https://hynek.me/til/easier-crediting-contributors-github/
        gcoauth = ''
          set -x GITHUB_TOKEN (rbw get github-token)
          set account $argv[1]
          set data (curl -s --header "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/users/$account)
          set id  (echo $data | jq .id)
          set name (echo $data | jq --raw-output '.name // .login')
          printf "Co-authored-by: %s <%d+%s@users.noreply.github.com>\n" $name $id $account
        '';
        git-remote-add = ''
          echo + git remote add $argv[1] git@github.com:$argv[1]/(basename $PWD)
          git remote add $argv[1] git@github.com:$argv[1]/(basename $PWD)
          echo + git fetch $argv[1]
          git fetch $argv[1]
        '';
        cnake = ''
          cmake (string split " " -- $cmakeFlags) $argv
        '';
      };
      shellAbbrs = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "......" = "cd ../../../../..";
        "=" = {
          expansion = "numbat -e '%'";
          setCursor = true;
        };
        bn = "cnake -B build";
        bnb = "cnake -B build && cmake --build build";
        bb = "cmake --build build";
        bt = "cmake --build build -t test";
        bi = "cmake --build build -t install";
        cdp = "cd (pwd -P)";
        demonte = "~/scripts/demonter.sh";
        dc = "cd";
        gc = {
          expansion = "git commit -am '%'";
          setCursor = true;
        };
        gd = "git difftool";
        gdi = "git difftool -t icat";
        gst = "git status";
        gsts = "git statuses";
        gp = "git push";
        gf = "git fetch --all --prune";
        gcaf = "git commit -a --fixup";
        gcan = "git commit -a --amend --no-edit";
        gcl = "git clone";
        gcr = "git clone --recursive";
        gch = "git checkout";
        gfc = "git fork-clone";
        glp = "git push -o merge_request.create -o merge_request.merge_when_pipeline_succeeds";
        gra = "git-remote-add";
        grhh = "git reset --hard HEAD";
        gsub = "git commit -am submodules; git push";
        ipa = "ip address";
        ipr = "ip route";
        la = "eza -A";
        ll = "eza -l --sort newest";
        ls = "eza";
        lt = "eza --tree";
        lla = "eza -lA";
        llt = "eza -l --tree";
        lat = "eza -A --tree";
        lta = "eza -A --tree";
        man = "batman";
        monte = "~/scripts/monter.sh";
        psef = "ps -ef | grep -v grep | grep";
        v = "nvim";
        vi = "nvim";
        vmi = "nvim";
        vim = "nvim";
        vd = "nvim -d";
        vimdiff = "nvim -d";
        y = "yazi";
        z = "zellij";
        za = "zathura";
      };
      shellAliases = {
        "+" = "echo";
        cp = "cp -r";
        mv = "mv -v";
        rm = "rm -Iv";
        watch = "watch --color -d";
        virerdossiersvides = "find . -name .directory -print0 | xargs -0 /bin/rm -fv ; find . -name Thumbs.db -print0 | xargs -0 /bin/rm -fv ; find . -type d -empty -print0 | xargs -0 /bin/rmdir -pv --ignore-fail-on-non-empty";
        clean = "find -regextype posix-extended -regex '.*\.(orig|aux|nav|out|snm|toc|tmp|tns|pyg|vrb|fls|fdb_latexmk|blg|bbl|un~)' -delete";
      };
    };
    fzf.enable = true;
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };
    # helix = {
    #   enable = true;
    # };
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
