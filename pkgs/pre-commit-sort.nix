{
  lib,

  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "pre-commit-sort";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "nim65s";
    repo = "pre-commit-sort";
    tag = "v${version}";
    hash = "sha256-RfhU1ovD85kPM2C/G+rYrgPJW+1g+RgFvFFZp5wj3dQ=";
  };

  cargoHash = "sha256-BTYU6ushrBNY/CSEdzeGGiFenBhkvD4nInt7dm7SHc4=";

  meta = {
    description = "Sort .pre-commit-config.yaml & .pre-commit-hooks.yaml";
    homepage = "https://github.com/nim65s/pre-commit-sort";
    changelog = "https://github.com/nim65s/pre-commit-sort/blob/${src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "pre-commit-sort";
  };
}
