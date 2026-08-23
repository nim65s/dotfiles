{
  ...
}:
{
  services = {
    music-assistant = {
      enable = true;
      providers = [
        "filesystem_nfs"
        "listenbrainz_scrobble"
        "lrclib"
        "sendspin"
      ];
    };
  };
}
