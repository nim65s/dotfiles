{
  lib,
  rustPlatform,
}:
let
  cargo = lib.importTOML ./Cargo.toml;
in
rustPlatform.buildRustPackage {
  inherit (cargo.package) name version;

  src = lib.cleanSource ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  meta = {
    description = "schedule heater activation";
    mainProgram = cargo.package.name;
  };
}
