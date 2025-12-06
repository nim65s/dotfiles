{
  python3,
  writeShellApplication,
}:
writeShellApplication {
  name = "tailstamp";
  runtimeInputs = [ python3 ];
  text = ''
    python ${../bin/tailstamp.py} "$@"
  '';
}
