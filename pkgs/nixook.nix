{
  runtimeShell,
  writeShellApplication,
}:
writeShellApplication {
  name = "nixook";
  text = ''
    cd "$(git rev-parse --git-dir)"
    (
      echo '#! ${runtimeShell}'
      echo 'set -eux'
      echo 'nix fmt'
      echo 'git diff --quiet'
      if test -f ../.pre-commit-config.yaml
      then echo 'pre-commit run -a'
      fi
    ) > hooks/pre-commit
    chmod +x hooks/pre-commit
    (
      echo '#! ${runtimeShell}'
      echo 'set -eux'
      echo 'nix flake check -L'
    ) > hooks/pre-push
    chmod +x hooks/pre-push
  '';
}
