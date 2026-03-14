{
  ...
}:
{
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/mnt/totoro" = {
    device = "192.168.1.111:/srv/nfs/data";
    fsType = "nfs";
    options = [
      "ro"
      "x-systemd.idle-timeout=600"
    ];
  };

}
