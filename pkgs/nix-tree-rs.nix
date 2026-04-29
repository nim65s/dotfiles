{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage (_finalAttrs: {
  pname = "nix-tree-rs";
  version = "0-unstable-2026-04-13";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-tree-rs";
    rev = "18cd924e7a146a271d020cfae2f482bcd48fa524";
    hash = "sha256-lAdYkgUZFz8bQrIDS7M0eFmLodx5pbesVh4/HJWikbc=";
  };

  cargoHash = "sha256-wiijhi1Uuq/RgdqnLd8/eS8pu5zGDKMmsgYGzHRmcUI=";

  nativeBuildInputs = [
    pkg-config
  ];

  doCheck = false;

  meta = {
    description = "Rust port of nix-tree, providing an interactive visualization of Nix store dependencies";
    homepage = "https://github.com/Mic92/nix-tree-rs";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "nix-tree";
  };
})
