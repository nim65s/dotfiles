{
  lib,
  rustPlatform,
}:
let
  cargo = lib.importTOML ./Cargo.toml;
in
rustPlatform.buildRustPackage {
  inherit (cargo.package) name version;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./Cargo.lock
      ./Cargo.toml
      ./src
    ];
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  doCheck = false;

  meta = {
    description = "schedule heater activation";
    mainProgram = cargo.package.name;
  };
}
