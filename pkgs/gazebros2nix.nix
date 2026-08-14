{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (_finalAttrs: {
  pname = "gazebros2nix";
  version = "0-unstable-2026-08-14";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "gazebros2nix";
    rev = "11add21f599c88b5db9aba0326f9bc1638f55674";
    hash = "sha256-N1VD45tdFLkulZCfH6N4u0jDz586poOHCZ+Ce03vhpM=";
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
