{
  flakoboros,
  nixpkgs-ros,
  nix-ros-overlay,
  ...
}:
final: prev:
let
  lib = final.lib // {
    inherit (flakoboros.lib) tmpOverride;
  };

  rosPkgs = import nixpkgs-ros {
    inherit (final.stdenv.hostPlatform) system;
    overlays = [ nix-ros-overlay.overlays.default ];
  };
in
{
  inherit (rosPkgs.python3Packages) rosdep;
  inherit (flakoboros.packages."${final.stdenv.system}") flakoboros;

  bloom = (lib.tmpOverride rosPkgs.python3Packages.bloom "0.14.3").overridePythonAttrs (
    finalAttrs: prevAttrs: {
      version = "0.14.4";
      src = final.fetchFromGitHub {
        inherit (prevAttrs.src) owner repo;
        rev = finalAttrs.version;
        hash = "sha256-zLmxIbCOfQFXsko7Vfy7L97hV1rSnvEcYjnyObWJGSI=";
      };
      dependencies = prevAttrs.dependencies ++ [ rosPkgs.python3Packages.tomli-w ];
    }
  );

  ethercat = prev.ethercat.overrideAttrs (super: {
    configureFlags = (super.configureFlags or [ ]) ++ [
      "--with-kmod-dir=${final.kmod}/bin"
      "--with-ip-cmd=${lib.getExe' final.iproute2 "ip"}"
    ];
    postPatch = (super.postPatch or "") + ''
      substituteInPlace script/ethercatctl.in --replace-fail \
        "awk" "${lib.getExe final.gawk}"
    '';
  });

  music-assistant = prev.music-assistant.overrideAttrs (super: {
    disabledTests =
      (super.disabledTests or [ ])
      ++ lib.optionals (final.stdenv.hostPlatform.isLinux && final.stdenv.hostPlatform.isAarch64) [
        "test_digital_silence_yields_finite_spectral_centroid"
      ];
  });

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (
      python-final: _python-prev:
      lib.filesystem.packagesFromDirectoryRecursive {
        inherit (python-final) callPackage;
        directory = ./py-pkgs;
      }
    )
  ];

  ros2cli =
    with rosPkgs.rosPackages.rolling;
    rosPkgs.stdenv.mkDerivation {
      pname = "ros2cli";
      inherit (ros2cli) version;

      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;
      dontWrapQtApps = true;
      doCheck = false;

      nativeBuildInputs = [ rosPkgs.makeWrapper ];
      buildInputs = [
        ros2action
        ros2cli
        ros2component
        ros2controlcli
        ros2doctor
        ros2interface
        ros2lifecycle
        # ros2log
        ros2multicast
        ros2node
        ros2param
        ros2pkg
        ros2run
        ros2service
        ros2topic
      ];

      installPhase = ''
        makeWrapper '${ros2cli}/bin/ros2' "$out/bin/ros2" \
          --prefix PYTHONPATH : "$PYTHONPATH"
      '';
    };
}
// prev.lib.filesystem.packagesFromDirectoryRecursive {
  inherit (final) callPackage;
  directory = ./pkgs;
}
