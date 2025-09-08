{
  lib,

  buildPythonApplication,
  fetchFromGitHub,

  cmake,
  git-archive-all,
  hatchling,
  packaging,
  tomli,
  wheel,
}:

buildPythonApplication rec {
  pname = "cmeel";
  version = "0.57.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cmake-wheel";
    repo = "cmeel";
    tag = "v${version}";
    hash = "sha256-fiIymwdv3Ojv3t4upM03GRO80YQoGu/BXjKhdLTX+rw=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    tomli
  ];

  optional-dependencies = {
    build = [
      cmake
      git-archive-all
      packaging
      wheel
    ];
  };

  pythonImportsCheck = [
    "cmeel"
  ];

  meta = {
    description = "Create Wheel from CMake projects";
    homepage = "https://github.com/cmake-wheel/cmeel";
    changelog = "https://github.com/cmake-wheel/cmeel/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "cmeel";
  };
}
