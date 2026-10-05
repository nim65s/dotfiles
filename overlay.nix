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
      python-final: python-prev:
      lib.filesystem.packagesFromDirectoryRecursive {
        inherit (python-final) callPackage;
        directory = ./py-pkgs;
      }
      // {
        # retry
        vdirsyncer = (tmpOverride python-prev.vdirsyncer "0.20.0").overridePythonAttrs (super: {
          src = final.fetchFromGitHub {
            owner = "pimutils";
            repo = "vdirsyncer";
            rev = "7ef30bfaad2891c3fb177d1d8a9bd4a486be8a1c";
            hash = "sha256-pSMDQGceooVLV0/ZaWw7YEZM3/aAWFr0nRheb7vDMMI=";
          };
          dependencies = super.dependencies ++ [ python-final.tenacity ];
        });
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
  # jj support
  starship_jj_merge_commit = (tmpOverride prev.starship "1.26.0").overrideAttrs (
    finalAttrs: prevAttrs: {
      src = final.fetchFromGitHub {
        inherit (prevAttrs.src) owner repo;
        # merge commit for https://github.com/starship/starship/pull/7612
        rev = "131bf9552d7e927607e155ea3a9b8c8a170a0356";
        hash = "sha256-H85gbkcFiGIOAx11F2/U+V2WxkDKhIF1qcasvnxN8L8=";
      };
      cargoDeps = final.rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) src;
        hash = "sha256-g06GmHmTC5X6R/YgIvKcwnN//fvLwh3hhnOAFhWnMwA=";
      };
      doCheck = false;
    }
  );
}
// prev.lib.filesystem.packagesFromDirectoryRecursive {
  inherit (final) callPackage;
  directory = ./pkgs;
}
