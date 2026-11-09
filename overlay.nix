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
  inherit (rosPkgs.python3Packages) bloom rosdep;
  inherit (flakoboros.packages."${final.stdenv.system}") flakoboros;

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

  # https://github.com/NixOS/nixpkgs/pull/585437
  gersemi = (lib.tmpOverride prev.gersemi "0.29.2").overrideAttrs {
    buildInputs = [ final.sqlite ];
  };

  # https://github.com/NixOS/nixpkgs/pull/582758
  git-statuses = (lib.tmpOverride prev.git-statuses "0.8.2").overrideAttrs (
    _finalAttrs: prevAttrs: {
      version = "1.0.0";
      src = final.fetchFromGitHub {
        inherit (prevAttrs.src)
          owner
          repo
          tag
          ;
        hash = "sha256-2TY5/3+NLCews07fQ5nrmubmICmdKhqFFvvI0VvFlRI=";
      };
      cargoHash = "sha256-LWeQYsH6xG9RCCp8BROmrK2jP5XcXnyGZPy7rVnvr94=";
      buildInputs = prevAttrs.buildInputs ++ [ final.libgit2 ];
      preCheck = "stty -F /dev/stdout cols 100";
    }
  );

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

  # https://github.com/NixOS/nixpkgs/pull/585077
  slint-lsp = (lib.tmpOverride prev.slint-lsp "1.18.1").overrideAttrs (
    _finalAttrs: prevAttrs: {
      rpathLibs = prevAttrs.rpathLibs ++ [ final.rust-jemalloc-sys ];
    }
  );

  slint-viewer = (lib.tmpOverride prev.slint-viewer "1.18.1").overrideAttrs (
    _finalAttrs: prevAttrs: {
      buildInputs = prevAttrs.buildInputs ++ [ final.rust-jemalloc-sys ];
    }
  );

  # https://github.com/NixOS/nixpkgs/pull/585310
  sniffnet = (lib.tmpOverride prev.sniffnet "1.5.1").overrideAttrs (
    _finalAttrs: prevAttrs: {
      buildInputs = prevAttrs.buildInputs ++ [ final.aws-lc ];
    }
  );
}
// prev.lib.filesystem.packagesFromDirectoryRecursive {
  inherit (final) callPackage;
  directory = ./pkgs;
}
