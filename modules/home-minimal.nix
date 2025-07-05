{ inputs, pkgs, ... }:
{

  imports = [
    inputs.catppuccin.homeModules.catppuccin
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
        demonte = "~/scripts/demonter.sh";
        dc = "cd";
        gc = {
          expansion = "git commit -am '%'";
          setCursor = true;
        };
        gd = "git difftool";
        gdi = "git difftool -t icat";
        gst = "git status";
        gp = "git push";
        gf = "git fetch --all --prune";
        gcaf = "git commit -a --fixup";
        gcan = "git commit -a --amend --no-edit";
        gcl = "git clone";
        gcr = "git clone --recursive";
        gch = "git checkout";
        gfc = "git fork-clone";
        glp = "git push -o merge_request.create -o merge_request.merge_when_pipeline_succeeds";
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
        vd = "nvim -d";
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
      controlMaster = "auto";
      includes = [ "local_config" ];
      userKnownHostsFile = "~/.ssh/known_hosts ~/dotfiles/known_hosts";
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
      settings = {
        format = "┬─ $all$time$line_break╰─ $jobs$battery$status$container$os$shell$character";
        time.disabled = false;
        status.disabled = false;
        package.disabled = true;
        os = {
          disabled = false;
          symbols = {
            Alpine = " ";
            Amazon = " ";
            Android = " ";
            Arch = " ";
            CentOS = " ";
            Debian = " ";
            DragonFly = " ";
            Emscripten = " ";
            EndeavourOS = " ";
            Fedora = " ";
            FreeBSD = " ";
            Garuda = "﯑ ";
            Gentoo = " ";
            HardenedBSD = "ﲊ ";
            Illumos = " ";
            Linux = " ";
            Macos = " ";
            Manjaro = " ";
            Mariner = " ";
            MidnightBSD = " ";
            Mint = " ";
            NetBSD = " ";
            NixOS = " ";
            OpenBSD = " ";
            openSUSE = " ";
            OracleLinux = " ";
            Pop = " ";
            Raspbian = " ";
            Redhat = " ";
            RedHatEnterprise = " ";
            Redox = " ";
            Solus = "ﴱ ";
            SUSE = " ";
            Ubuntu = " ";
            Unknown = " ";
            Windows = " ";
          };
        };
        aws.symbol = "  ";
        buf.symbol = " ";
        c.symbol = " ";
        conda.symbol = " ";
        dart.symbol = " ";
        directory.read_only = " 󰌾";
        docker_context.symbol = " ";
        elixir.symbol = " ";
        elm.symbol = " ";
        fossil_branch.symbol = " ";
        git_branch.symbol = " ";
        golang.symbol = " ";
        guix_shell.symbol = " ";
        haskell.symbol = " ";
        haxe.symbol = "⌘ ";
        hg_branch.symbol = " ";
        java.symbol = " ";
        julia.symbol = " ";
        lua.symbol = " ";
        memory_usage.symbol = " ";
        meson.symbol = "喝 ";
        nim.symbol = " ";
        nix_shell.symbol = " ";
        nodejs.symbol = " ";
        pijul_channel.symbol = "🪺 ";
        python.symbol = " ";
        rlang.symbol = "ﳒ ";
        ruby.symbol = " ";
        rust.symbol = " ";
        scala.symbol = " ";
        spack.symbol = "🅢 ";
        hostname.ssh_symbol = " ";
      };
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
      fzf.enable = false;
      helix.enable = false;
      kitty.enable = false;
      mako.enable = false; # silence a HM assert in unused module
      neovim.enable = false;
      nixvim.enable = false;
      qt.enable = false;
      starship.enable = false;
      swaylock.enable = false;
      swaync.enable = false;
    };
  };
}
