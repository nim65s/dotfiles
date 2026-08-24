{
  python3,
  writeShellApplication,
}:
writeShellApplication {
  name = "ask-rbw";
  runtimeInputs = [ python3 ];
  text = ''
    python ${../bin/ask-rbw.py} "$@"
  '';
}
