{
  python3,
  writeShellApplication,
}:
writeShellApplication {
  name = "git-objects-cache";
  runtimeInputs = [ (python3.withPackages (p: [ p.tomlkit ])) ];
  text = ''
    python ${../bin/git-objects-cache.py} "$@"
  '';
}
