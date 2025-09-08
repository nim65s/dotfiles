{
  python3,
  writeShellApplication,
}:
writeShellApplication {
  name = "pmapnitor";
  runtimeInputs = [ python3 ];
  text = ''
    python ${../bin/pmapnitor.py} "$@"
  '';
}
