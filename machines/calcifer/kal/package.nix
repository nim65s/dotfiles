# {
#   lib,
#   rustPlatform,
# }:
# let
#   cargo = lib.importTOML ./Cargo.toml;
# in
# rustPlatform.buildRustPackage {
#   inherit (cargo.package) name version;
#
#   src = lib.fileset.toSource {
#     root = ./.;
#     fileset = lib.fileset.unions [
#       ./Cargo.lock
#       ./Cargo.toml
#       ./src
#     ];
#   };
#
#   cargoLock = {
#     lockFile = ./Cargo.lock;
#   };
#
#   doCheck = false;
#
#   meta = {
#     description = "schedule heater activation";
#     mainProgram = cargo.package.name;
#   };
# }

{
  lib,
  buildPythonApplication,

  uv-build,
  gpiod,
  zenoh,
}:
let
  pyproject = lib.importTOML ./pyproject.toml;
in
buildPythonApplication (_finalAttrs: {
  inherit (pyproject.project) name version;
  pyproject = true;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./pyproject.toml
      ./src
    ];
  };

  build-system = [
    uv-build
  ];

  dependencies = [
    gpiod
    zenoh
  ];

  pythonImportsCheck = [
    pyproject.project.name
  ];

  meta = {
    description = "schedule heater activation";
    mainProgram = pyproject.project.name;
  };
})
