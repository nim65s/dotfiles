{
  nixpkgs-ros,
  nix-ros-overlay,
  ...
}:
final: prev:
let
  rosPkgs = import nixpkgs-ros {
    inherit (final.stdenv.hostPlatform) system;
    overlays = [ nix-ros-overlay.overlays.default ];
  };
in
{
  inherit (rosPkgs.python3Packages) bloom rosdep;
  ethercat = prev.ethercat.overrideAttrs (super: {
    configureFlags = (super.configureFlags or [ ]) ++ [
      "--with-kmod-dir=${final.kmod}/bin"
      "--with-ip-cmd=${final.lib.getExe' final.iproute2 "ip"}"
    ];
    postPatch = (super.postPatch or "") + ''
      substituteInPlace script/ethercatctl.in --replace-fail \
        "awk" "${final.lib.getExe final.gawk}"
    '';
  });
  # https://github.com/NixOS/nixpkgs/pull/551441
  jrl-cmakemodules-scripts = prev.jrl-cmakemodules-scripts.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "2.3.0";
      src = final.fetchFromGitHub {
        inherit (previousAttrs.src) owner repo;
        tag = "v${finalAttrs.version}";
        hash = "sha256-PjEE/JIb6gegW5fqKiFgN0th8Fi58Pe0u5qrdIz2Rm8=";
      };
      nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [ final.git ];
    }
  );
  # https://github.com/NixOS/nixpkgs/pull/555902
  music-assistant = prev.music-assistant.overrideAttrs (super: {
    disabledTests =
      (super.disabledTests or [ ])
      ++ final.lib.optionals (final.stdenv.hostPlatform.isLinux && final.stdenv.hostPlatform.isAarch64) [
        "test_digital_silence_yields_finite_spectral_centroid"
      ];
  });
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (
      python-final: _python-prev:
      final.lib.filesystem.packagesFromDirectoryRecursive {
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
