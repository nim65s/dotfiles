{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-diff-rs";
  version = "0-unstable-2026-07-04";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-diff-rs";
    rev = "fbb2d1ac23a923af05089bbec3f4d44dee3c8072";
    hash = "sha256-fYWuUnDSFrOLbreWw1+qCoSVl9FiKFTnjqwYrPnpZ/o=";
  };

  cargoHash = "sha256-3dh/cH3WOcFesK0QG82huMIf07euHPHAHBDXyJ1u02I=";

  passthru.updateScript = nix-update-script { };

  # flemme to compile twice
  doCheck = false;

  meta = {
    description = "A Rust port of nix-diff, a tool to explain why two Nix derivations differ";
    homepage = "https://github.com/Mic92/nix-diff-rs";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "nix-diff-rs";
  };
})
