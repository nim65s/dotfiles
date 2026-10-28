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
    ./kitty.nix
    ./waybar.nix
  ];

  programs = {
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        hyperlinks = true;
      };
    };

    element-desktop = {
      enable = true;
      settings = {
        default_server_config."m.homeserver" = {
          base_url = "https://matrix.laas.fr";
          server_name = "laas.fr";
        };
      };
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
        # https://arialdo.codeberg.page/ju-ju-tsu/appendix/log.html
        templates.log = "simple_log";
        template-aliases = {
          empty_commit_marker = "label('empty', '▢')";
          simple_log = ''
            separate(" ",
              pad_end(
                4,
                separate("/",
                  self.change_id().shortest(),
                  if(self.divergent() || self.hidden(), self.change_offset())
                )
              ),
              if(self.immutable(), "🔒", "  ") ++ " ",
              if(self.empty(), empty_commit_marker),
              if(self.description(), self.description().first_line(), if(self.empty(), ''', label('no_description', '←'))),
              self.bookmarks()
            )
          '';
        };
      };
    };

    msmtp.enable = true;

    neomutt.enable = true;

    nix-index.enable = true;

    numbat.enable = true;

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
      settings = {
        color-enabled = true;
        matching = "prefix";
        no-lazy-grab = true;
        terminal = lib.getExe pkgs.kitty;
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

    zellij = {
      enable = true;
      # attachExistingSession = true;
      # enableFishIntegration = true;
    };
  };
}
