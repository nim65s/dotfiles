{
  python3,
  writeShellApplication,
}:
writeShellApplication {
  name = "pratches";
  runtimeInputs = [ (python3.withPackages (p: [ p.httpx ])) ];
  text = ''
    python ${../bin/pratches.py} "$@"
  '';
}
