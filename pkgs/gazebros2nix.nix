{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (_finalAttrs: {
  pname = "gazebros2nix";
  version = "0-unstable-2026-07-23";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "gazebros2nix";
    rev = "2bc2a8f9ce78b581ad88d2023300b2149b5db95a";
    hash = "sha256-8xzMPdN0Yr+ntSPgg1PsAeplDZyGkR0d6GGQD+kyKLg=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = with python3Packages; [
    case-converter
    catkin-pkg
    jinja2
    pygithub
    pyyaml
  ];

  pythonImportsCheck = [
    "gazebros2nix"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate and maintain Nix packages from gazebodistro & ROS package.xmls";
    homepage = "https://github.com/Gepetto/gazebros2nix";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "ros2nix";
  };
})
