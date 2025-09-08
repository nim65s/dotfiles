{
  python3,
  writeShellApplication,
}:
writeShellApplication {
  name = "git-fork-clone";
  runtimeInputs = [ (python3.withPackages (p: [ p.PyGithub ])) ];
  text = ''
    python ${../bin/git-fork-clone.py} "$@"
  '';
}
