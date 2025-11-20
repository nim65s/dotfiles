{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dockgen";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nim65s";
    repo = "dockgen";
    rev = "v${version}";
    hash = "sha256-eFLyHJs2uUZqloWNn/HC5dQ27WEjcOCw34DhtkNl8ww=";
  };

  build-system = [
    python3.pkgs.uv-build
  ];

  dependencies = with python3.pkgs; [
    httpx
    jinja2
  ];

  pythonImportsCheck = [
    "dockgen"
  ];

  meta = {
    description = "Generate fresh docker images";
    homepage = "https://github.com/nim65s/dockgen";
    changelog = "https://github.com/nim65s/dockgen/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "dockgen";
  };
}
