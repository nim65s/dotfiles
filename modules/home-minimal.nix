{ inputs, ... }:
{

  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin.enable = true;

  home = {
    stateVersion = "25.05";
  };

  programs = {
    bat.enable = true;
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
    fish = {
      enable = true;
      interactiveShellInit = ''
        set -U fish_color_autosuggestion cba6f7 #cba6f7
        set -U fish_color_comment 94e2d5        #94e2d5
        set -U fish_color_end cdd6f4            #cdd6f4
        set -U fish_color_param 89b4fa          #89b4fa
      '';
      shellAbbrs = {
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "......" = "cd ../../../../..";
        bn = "cmake -B build";
        bnb = "cmake -B build && cmake --build build";
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
        gst = "git status";
        gp = "git push";
        gf = "git fetch --all --prune";
        gcan = "git commit -a --amend --no-edit";
        gcl = "git clone";
        gcr = "git clone --recursive";
        gch = "git checkout";
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
        monte = "~/scripts/monter.sh";
        psef = "ps -ef | grep -v grep | grep";
        v = "vim";
        vi = "vim";
        vmi = "vim";
        vd = "vimdiff";
        z = "zellij";
        za = "zathura";
      };
      shellAliases = {
        "+" = "echo";
        cp = "cp -r";
        mv = "mv -v";
        rm = "rm -Iv";
        watch = "watch --color -d";
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
    helix = {
      enable = true;
      defaultEditor = true;
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
      swaylock.enable = false;
    };
  };
}
