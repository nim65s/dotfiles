{
  config,
  pkgs,
  ...
}:
{
  clan.core.vars.generators = {
    mopidy-listenbrainz = {
      prompts.token-input.description = "your listenbrainz token";
      files.conf = {
        secret = true;
        owner = "nim";
        restartUnits = [ "mopidy.service" ];
      };
      script = ''
        echo "[listenbrainz]" > $out/conf
        echo "token = $(cat $prompts/token-input)" >> $out/conf
      '';
      share = true;
    };
    mopidy-spotify = {
      prompts.id-input.description = "your spotify client_id";
      prompts.secret-input.description = "your spotify client_secret";
      files.conf = {
        secret = true;
        owner = "nim";
        restartUnits = [ "mopidy.service" ];
      };
      script = ''
        echo "[spotify]" > $out/conf
        echo "client_id = $(cat $prompts/id-input)" >> $out/conf
        echo "client_secret = $(cat $prompts/secret-input)" >> $out/conf
      '';
      share = true;
    };
  };

  home-manager.users.nim.services.mopidy = {
    enable = true;
    extensionPackages = with pkgs.mopidyPackages; [
      mopidy-listenbrainz
      mopidy-mpd
      mopidy-muse
      mopidy-mpris
      mopidy-notify
      mopidy-spotify
    ];
    extraConfigFiles = [
      config.clan.core.vars.generators.mopidy-listenbrainz.files.conf.path
      config.clan.core.vars.generators.mopidy-spotify.files.conf.path
    ];
  };
}
