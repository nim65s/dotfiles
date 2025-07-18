{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  atjoin =
    {
      name,
      host ? "laas.fr",
    }:
    lib.concatStringsSep "@" [
      name
      host
    ];
in
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];
  home = {
    packages = with pkgs; [
      acpi
      age
      black
      brightnessctl
      broot
      cachix
      cage
      cargo
      cargo-binstall
      cargo-release
      clan-cli
      clang_19
      cmeel
      comma
      dcfldd
      deadnix
      # devenv
      dfc
      d-spy
      dig
      dos2unix
      chrpath
      cmake
      # cmake-format
      cntr
      docker-compose
      du-dust
      evince
      #eww-wayland
      ffmpeg
      file
      fishPlugins.bass
      #font-awesome
      fuzzel
      gersemi
      ghostscript
      git-extras
      git-fork-clone
      gnupg
      gparted
      grim
      himalaya
      htop
      httpie
      hugo
      hwloc
      iftop
      inetutils
      imv
      iotop
      iosevka
      iosevka-aile
      iosevka-etoile
      iosevka-term
      jless
      jq
      just
      kcov
      kdePackages.kolourpaint
      kdePackages.okular
      keep-sorted
      khal
      khard
      killall
      less
      libreoffice
      lsof
      gnumake
      mdcat
      mdbook
      meld
      meshlab
      mosh
      mpv
      mypy
      ncdu
      ninja
      niri
      nitrogen
      nixook
      nixd
      nixfmt-rfc-style
      nixpkgs-review
      #nix-du
      nix-diff
      nix-init
      nix-output-monitor
      nix-tree
      nix-update
      nmap
      #noto-fonts-emoji
      nurl
      openldap
      openssh
      openssl
      pandoc
      pwvucontrol
      pciutils
      pdfarranger
      pdfpc
      pipewire
      pinentry-qt
      pipx
      plantuml
      pkg-config
      playerctl
      pmapnitor
      #(poetry.withPlugins (ps: with ps; [ poetry-plugin-up ]))
      (python3.withPackages (
        ps: with ps; [
          django
          httpx
          ipython
          jinja2
          ldap3
          numpy
          pandas
          pandocfilters
          pip
          pyarrow
          pyyaml
          tabulate
          tomlkit
          tqdm
          wand
          wheel
        ]
      ))
      pratches
      pre-commit
      pre-commit-sort
      pulseaudio
      pwgen
      rofi-rbw
      rofimoji
      ruff
      rustc # nor pre-commit
      signal-desktop
      sd
      sccache
      shellcheck
      slurp
      #snapcast
      sops
      # spotify
      sqlite
      ssh-to-age
      statix
      strace
      #sway
      swaybg
      swaylock
      tdf
      tig
      toml-sort
      tree
      unzip
      usbutils
      uv
      #ventoy  # TODO: https://github.com/ventoy/Ventoy/issues/3224
      vdirsyncer
      vlc
      vscode-fhs
      watchexec
      wev
      #wireplumber
      wl-clipboard
      wget
      wtype
      wdisplays
      #xdg-desktop-portal
      #xdg-desktop-portal-gtk
      #xdg-desktop-portal-wlr
      xwayland
      yq
      yt-dlp
      zathura
      zeal-qt6
      zellij
      zfs
      #zola
    ];

    file = {
      ".config/dfc/dfcrc".source = ../.config/dfc/dfcrc;
      ".config/distrobox/distrobox.conf".source = ../.config/distrobox/distrobox.conf;
      # TODO: wip bépo / ergol
      #".config/niri/config.kdl".source = ../.config/niri/config.kdl;
      ".config/kitty/open-actions.conf".source = ../.config/kitty/open-actions.conf;
      ".config/khal/config".source = ../.config/khal/config;
      ".config/khard/khard.conf".source = ../.config/khard/khard.conf;
      ".config/python_keyring/keyringrc.cfg".source = ../.config/python_keyring/keyringrc.cfg;
      ".config/rofi-rbw.rc".source = ../.config/rofi-rbw.rc;
      ".config/vdirsyncer/config".source = ../.config/vdirsyncer/config;
      ".ipython/profile_default/ipython_config.py".source = ../.ipython/profile_default/ipython_config.py;
      ".latexmkrc".source = ../.latexmkrc;
      ".pypirc".source = ../.pypirc;

      ".xinitrc".text = "exec ${lib.getExe pkgs.i3} > ~/.x.log 2> ~/.x.err";
    };

    sessionVariables = {
      BROWSER = lib.getExe config.programs.firefox.finalPackage;
      CLAN_DIR = "$HOME/dotfiles";
      CMAKE_BUILD_TYPE = "RelWithDebInfo";
      CMAKE_C_COMPILER_LAUNCHER = "sccache";
      CMAKE_CXX_COMPILER_LAUNCHER = "sccache";
      CMAKE_COLOR_DIAGNOSTICS = "ON";
      CMAKE_EXPORT_COMPILE_COMMANDS = "ON";
      CMAKE_GENERATOR = "Ninja";
      CMEEL_LOG_LEVEL = "DEBUG";
      CTEST_OUTPUT_ON_FAILURE = "ON";
      CTEST_PROGRESS_OUTPUT = "ON";
      DELTA_PAGER = "less -FR";
      GITHUB_TOKEN_CMD = "rbw get github-token";
      NIXOS_OZONE_WL = 1;
      # PAGER = "vim -c PAGER -";
      POETRY_VIRTUALENVS_IN_PROJECT = "true";
      RUSTC_WRAPPER = lib.getExe pkgs.sccache;
      SHELL = lib.getExe pkgs.fish;
      SSH_ASKPASS = "$HOME/scripts/ask_rbw.py";
      SSH_ASKPASS_REQUIRE = "prefer";
      #SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
      #TWINE_USERNAME = "nim65s";
    };
  };

  programs = {
    element-desktop = {
      enable = true;
      combineDefaultSettings = true;
      combineSettingsProfiles = true;
      package = pkgs.element-desktop.overrideAttrs {
        # ref. https://github.com/fabiospampinato/atomically/issues/13
        postFixup = ''
          substituteInPlace \
            $out/share/element/electron/node_modules/atomically/dist/constants.js \
            --replace-fail "os.userInfo().uid;" "process.geteuid ? process.geteuid() : -1;" \
            --replace-fail "os.userInfo().gid;" "process.getegid ? process.getegid() : -1;"
        '';
      };
      settings = {
        default_server_config."m.homeserver" = {
          base_url = "https://matrix.laas.fr";
          server_name = "laas.fr";
        };
      };
      profiles.ttnn.default_server_config."m.homeserver" = {
        base_url = "https://matrix.tetaneutral.net";
        server_name = "tetaneutral.net";
      };
    };
    git = {
      enable = true;
      attributes = [
        "*.png diff=exif-diff"
      ];
      delta = {
        enable = true;
        options = {
          hyperlinks = true;
        };
      };
      lfs.enable = true;
      userName = "Guilhem Saurel";
      userEmail = atjoin { name = "guilhem.saurel"; };
      extraConfig = {
        alias = {
          git = "!exec git";
          lg = "log --graph --pretty=tformat:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%an %ar)%Creset'";
        };
        blame = {
          ignoreRevsFile = ".git-blame-ignore-revs";
        };
        branch = {
          sort = "-committerdate";
        };
        color = {
          ui = "always";
          branch = "always";
          interactive = "always";
          status = "always";
        };
        column = {
          ui = "auto";
        };
        commit = {
          verbose = true;
        };
        core = {
          excludesfile = "~/dotfiles/gitignore";
        };
        diff = {
          algorithm = "histogram";
          colorMoved = true;
          colorMovedWS = "allow-indentation-change";
          guitool = "meld";
          tool = "nvimdiff";
          renames = "true";
          exif-diff.textconv = lib.getExe pkgs.exif-diff;
        };
        difftool = {
          cmd = "nvimdiff";
          prompt = false;
          icat.cmd = "compare -background none $REMOTE $LOCAL png:- | montage -background none -geometry 200x -font Iosevka $LOCAL - $REMOTE png:- | kitten icat";
        };
        fetch = {
          all = true;
          parallel = 4;
          prune = true;
          # pruneTags = true;
        };
        help = {
          autocorrect = 10;
        };
        hub = {
          protocol = "ssh";
        };
        init = {
          defaultBranch = "main";
        };
        merge = {
          conflictstyle = "zdiff3";
          tool = "nvimdiff";
          guitool = "meld";
        };
        mergetool = {
          meld.cmd = ''
            meld "$LOCAL" "$MERGED" "$REMOTE" --output "$MERGED"
          '';
        };
        user = {
          signingKey = "4653CF28";
        };
        pull = {
          ff = "only";
          rebase = true;
        };
        push = {
          autoSetupRemote = true;
          default = "simple";
        };
        rebase = {
          autosquash = true;
          autostash = true;
        };
        rerere = {
          autoupdate = true;
          enabled = true;
        };
        submodule = {
          fetchJobs = 4;
        };
        tag = {
          sort = "version:refname";
        };
        url = {
          "git@github.com:" = {
            insteadOf = "https://github.com/";
          };
          "git@gitlab.laas.fr:" = {
            insteadOf = "https://gitlab.laas.fr/";
          };
        };
      };
      includes = [
        { path = "~/dotfiles/.gitconfig"; }
      ];
    };
    hwatch.enable = true;
    nixvim = import ../modules/nixvim.nix // {
      enable = true;
      defaultEditor = true;
    };
    numbat.enable = true;
    spicetify = {
      enable = true;
      enabledExtensions = with inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system}.extensions; [
        autoVolume
        beautifulLyrics
        powerBar
        shuffle
      ];
    };
    ssh = {
      matchBlocks = {
        "upe" = config.laasProxy.value // {
          hostname = "upepesanke";
          user = "gsaurel";
        };
        "miya" = config.laasProxy.value // {
          hostname = "miyanoura";
          user = "gsaurel";
        };
        "totoro" = {
          hostname = "totoro.saurel.me";
          user = "nim";
        };
        "ashitaka" = {
          user = "nim";
          proxyJump = "totoro";
        };
        "nausicaa" = {
          user = "nim";
          proxyJump = "totoro";
        };
        "datcat" = {
          port = 2222;
          user = "root";
          hostname = "%h.fr";
          forwardAgent = true;
        };
        "marsbase" = {
          user = "root";
          hostname = "192.168.1.1";
          extraOptions = {
            HostKeyAlgorithms = "+ssh-rsa";
            PubkeyAcceptedKeyTypes = "+ssh-rsa";
          };
        };
        "*.l" = config.laasProxy.value // {
          hostname = "%haas.fr";
          forwardAgent = true;
          user = "gsaurel";
        };
        "*.L" = config.laasProxy.value // {
          hostname = "%haas.fr";
          forwardAgent = true;
          user = "root";
        };
        "*.m" = {
          forwardAgent = true;
        };
        "*.M" = {
          forwardAgent = true;
          user = "root";
        };
        "*.t" = {
          hostname = "%hetaneutral.net";
          user = "root";
          port = 2222;
        };
      };
    };
    thunderbird = {
      enable = true;
      profiles.nim = {
        isDefault = true;
        settings = {
          "extensions.activeThemeID" = "{f6d05f0c-39a8-5c4d-96dd-4852202a8244}";
          "mail.identity.default.compose_html" = 1;
          "mail.pane_config.dynamic" = 2;
          "mail.server.default.check_all_folders_for_new" = true;
          "mail.uidensity" = 0;
          "mail.uifontsize" = 10;
          "ldap_2.autoComplete.useDirectory" = true;
          "ldap_2.servers.laas.description" = "Serveur LDAP LAAS";
          "ldap_2.servers.laas.filename" = "ldap.sqlite";
          "ldap_2.servers.laas.maxHits" = 100;
          "ldap_2.servers.laas.uri" = "ldap://ldap2.laas.fr/dc=laas,dc=fr%20??sub?(objectClass=person)";
          "ldap_2.servers.default.attrmap.PrimaryEmail" = "laas-mainMail";
        };
      };
    };
    vim = {
      enable = true;
      #defaultEditor = true;
      plugins = with pkgs; [
        # vimPlugins.ale
        # vimPlugins.colorizer
        # vimPlugins.file-line
        # vimPlugins.nerdcommenter
        vimPlugins.plantuml-syntax
        vimPlugins.vim-airline
        vimPlugins.vim-airline-themes
        # vimPlugins.vim-clang-format
        # vimPlugins.vim-fugitive
        # vimPlugins.vim-jinja
        # vimPlugins.vim-manpager
        # vimPlugins.vim-nix
        # vimPlugins.vim-pager
        # vimPlugins.vim-plugin-AnsiEsc
        # vimPlugins.vim-sensible
        # vimPlugins.vim-signify
        vimPlugins.vim-toml
        # vimPlugins.vimspector
        # vimPlugins.yuck-vim
        #vimPlugins.zenburn
      ];
      settings = {
        backupdir = [
          "~/.vim/tmp"
          "~/.tmp"
          "~/tmp"
          "/var/tmp"
          "/tmp"
        ];
        directory = [
          "~/.vim/tmp"
          "~/.tmp"
          "~/tmp"
          "/var/tmp"
          "/tmp"
        ];
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
    visidata.enable = true;
  };
}
