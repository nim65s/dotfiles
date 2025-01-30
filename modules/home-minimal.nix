{
  home = {
    stateVersion = "25.05";
  };

  programs = {
    bat.enable = true;
    btop.enable = true;
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
    };
    helix = {
      enable = true;
      defaultEditor = true;
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
}
