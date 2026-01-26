{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "nim-mopidy";
  cfg = config.services."${name}";
in
{
  options.services."${name}" = {
    enable = lib.mkEnableOption "pre-configured mopidy for NixOS or Home-Manager. You must choose at least one.";
    enable-nixos = lib.mkEnableOption "run as system service";
    enable-hm = lib.mkEnableOption "run as user service";
  };

  config = lib.mkIf cfg.enable {

    clan.core.vars.generators = {
      mopidy-listenbrainz = {
        prompts.token-input.description = "your listenbrainz token";
        files.conf = {
          secret = true;
          owner = "nim";
          group = "mopidy";
          mode = "0440";
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
          group = "mopidy";
          mode = "0440";
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

    home-manager.users.nim.services.mopidy = lib.mkIf cfg.enable-hm {
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

    services.mopidy = lib.mkIf cfg.enable-nixos {
      enable = true;
      extensionPackages = with pkgs.mopidyPackages; [
        mopidy-listenbrainz
        mopidy-mpd
        mopidy-muse
        # mopidy-mpris
        # mopidy-notify
        mopidy-spotify
      ];
      extraConfigFiles = [
        config.clan.core.vars.generators.mopidy-listenbrainz.files.conf.path
        config.clan.core.vars.generators.mopidy-spotify.files.conf.path
      ];
      settings = { };
    };

    users.groups.mopidy = { };
  };
}
