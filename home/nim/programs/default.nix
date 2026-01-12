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
  imports = [
    ./firefox.nix
    ./git.nix
    ./kitty.nix
    ./ssh.nix
    ./waybar.nix
    ./yazi.nix
  ];

  programs = {
    alacritty.enable = true;

    asciinema = {
      enable = true;
      package = pkgs.asciinema_3;
    };

    atuin = {
      enable = true;
      daemon.enable = true;
      flags = [ "--disable-up-arrow" ];
      settings.sync_address = "https://atuin.datcat.fr";
    };

    bacon = {
      enable = true;
      settings = {
        reverse = true;
      };
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        hyperlinks = true;
      };
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

    msmtp.enable = true;

    neomutt.enable = true;

    nix-index.enable = true;

    nix-init = {
      enable = true;
      settings = {
        maintainers = [ "nim65s" ];
        access-tokens = {
          "github.com" = {
            command = [
              "rbw"
              "get"
              "github-token"
            ];
          };
        };
      };
    };

    nixvim = import ../../../shared/nixvim.nix // {
      enable = true;
      defaultEditor = true;
    };

    notmuch.enable = true;

    numbat.enable = true;

    nushell.enable = true;

    offlineimap.enable = true;

    rbw = {
      enable = true;
      settings = {
        email = atjoin {
          name = "guilhem";
          host = "saurel.me";
        };
        base_url = "https://safe.datcat.fr";
        pinentry = pkgs.pinentry-qt;
      };
    };

    rofi = {
      enable = true;
      terminal = lib.getExe pkgs.kitty;
      extraConfig = {
        color-enabled = true;
        matching = "prefix";
        no-lazy-grab = true;
      };
    };

    swaylock = {
      enable = true;
      settings = {
        show-failed-attempts = true;
        ignore-empty-password = true;
        font = "Iosevka";
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

    visidata.enable = true;

    zathura = {
      enable = true;
      mappings = {
        s = "reload";
        r = "navigate next";
        t = "navigate previous";
        h = "zoom in";
        g = "zoom out";
        q = "quit";
        n = "rotate";
      };
    };
  };
}
