{
  lib,

  stdenv,

  fetchPnpmDeps,

  nodejs,
  pnpmConfigHook,
  pnpm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kal-schedule-card";
  version = "0.1.0";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./package.json
      ./pnpm-lock.yaml
      ./src/kal-schedule-card.js
    ];
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-aVBgtcBWs75Yc4+ZQgpca8Uz1DBuEz2Taj4GLJEnKaI=";
  };

  buildPhase = ''
    pnpm install
    pnpm build
  '';
  installPhase = ''
    mkdir $out
    cp dist/* $out
  '';

  meta = {
    description = "Kal Schedule Lovelace card";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
