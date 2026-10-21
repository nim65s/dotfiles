{
  nixpkgs-ros,
  nix-ros-overlay,
  ...
}:
final: prev:
let
  inherit (final) lib;

  rosPkgs = import nixpkgs-ros {
    inherit (final.stdenv.hostPlatform) system;
    overlays = [ nix-ros-overlay.overlays.default ];
  };

  tmpOverride =
    prevPkg: prevVersion:
    lib.throwIfNot (lib.versionAtLeast prevVersion prevPkg.version)
      "${prevPkg.pname} ${prevPkg.version} is now available. Please remove (or update) its override for ${prevVersion}"
      prevPkg;
in
{
  inherit (rosPkgs.python3Packages) bloom rosdep;

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

  # https://github.com/NixOS/nixpkgs/pull/576662
  khal = (tmpOverride prev.khal "0.24.4").overrideAttrs {
    sphinxBuilders = [ "html man" ];
  };

  # https://github.com/NixOS/nixpkgs/pull/555902
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

  # https://github.com/NixOS/nixpkgs/pull/576228
  toml-sort = (tmpOverride prev.toml-sort "0.24.4").overridePythonAttrs (
    finalAttrs: prevAttrs: {
      version = "0.25.0";
      src = final.fetchFromGitHub {
        inherit (prevAttrs.src) owner repo;
        tag = "v${finalAttrs.version}";
        hash = "sha256-uEmIQq0Mc7dpDOzfhSgj6MY2EJMrn6MiT8SL1eYLtzE=";
      };
      dependencies = [ final.python3Packages.tomlrt ];
    }
  );
}
// prev.lib.filesystem.packagesFromDirectoryRecursive {
  inherit (final) callPackage;
  directory = ./pkgs;
}
