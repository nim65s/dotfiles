{
  python3,
  writeShellApplication,
}:
writeShellApplication {
  name = "md5cron";
  runtimeInputs = [ python3 ];
  text = ''
    python ${../bin/md5cron.py} "$@"
  '';
}
