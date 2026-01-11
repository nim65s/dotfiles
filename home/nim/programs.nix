{
  config,
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
  home.programs = {
    asciinema = {
      enable = true;
      package = pkgs.asciinema_3;
    };

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

    ghostty.enable = true;

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        hyperlinks = true;
      };
    };

    git = {
      enable = true;
      attributes = [
        "*.png diff=exif-diff"
      ];
      lfs.enable = true;
      settings = {
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
          excludesfile = "${../../gitignore}";
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
          autocorrect = 1;
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
          email = atjoin { name = "guilhem.saurel"; };
          name = "Guilhem Saurel";
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

    halloy = {
      enable = true;
      settings = {
        "buffer.channel.topic" = {
          enabled = true;
        };
        "servers.liberachat" = {
          channels = [
            "#tetaneutral.net"
          ];
          nickname = "nim65s";
          server = "irc.libera.chat";
        };
      };
    };

    hwatch.enable = true;

    jjui.enable = true;

    jujutsu = {
      enable = true;
      settings = {
        user = {
          inherit (config.programs.git.settings.user) name email;
        };
      };
    };

    nixvim = import ../../shared/nixvim.nix // {
      enable = true;
      defaultEditor = true;
    };

    numbat.enable = true;

    nushell.enable = true;

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

    yazi = {
      enable = true;
      initLua = ''
        require("git"):setup()
        require("starship"):setup()
      '';
      keymap = {
        mgr.prepend_keymap = [
          {
            on = [ "+" ];
            run = "arrow next";
          }
          {
            on = [ "-" ];
            run = "arrow prev";
          }
          {
            on = [ "l" ];
            run = "plugin enter";
          }
        ];
      };
      plugins = {
        inherit (pkgs.yaziPlugins) git starship;
      };
      settings = {
        plugin.prepend_fetchers = [
          {
            id = "git";
            url = "*";
            run = "git";
          }
          {
            id = "git";
            url = "*/";
            run = "git";
          }
        ];
      };
    };

    visidata.enable = true;
  };
}
