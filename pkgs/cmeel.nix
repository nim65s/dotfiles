{
  lib,
  python3,
  fetchFromGitHub,
  installShellFiles,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "cmeel";
  version = "0.60.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cmake-wheel";
    repo = "cmeel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SI/RMJIm+zdIM2Mzui0GdbWBJutot8KFLP8+QsvmoUc=";
  };

  nativeBuildInputs = [
    installShellFiles
    python3.pkgs.argcomplete
  ];

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    tomli
  ];

  optional-dependencies = with python3.pkgs; {
    build = [
      cmake
      git-archive-all
      packaging
      wheel
    ];
    cli = [
      argcomplete
    ];
  };

  pythonImportsCheck = [
    "cmeel"
  ];

  postInstall = ''
    installShellCompletion --cmd cmeel \
      --bash <(register-python-argcomplete --shell bash cmeel) \
      --fish <(register-python-argcomplete --shell fish cmeel) \
      --zsh <(register-python-argcomplete --shell zsh cmeel)
  '';

  meta = {
    description = "Create Wheel from CMake projects";
    homepage = "https://github.com/cmake-wheel/cmeel";
    changelog = "https://github.com/cmake-wheel/cmeel/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "cmeel";
  };
})
