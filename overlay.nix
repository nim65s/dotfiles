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
  jrl-cmakemodules-scripts = prev.jrl-cmakemodules-scripts.overrideAttrs (super: {
    nativeBuildInputs = super.nativeBuildInputs ++ [ final.git ];
  });
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (
      python-final: python-prev:
      final.lib.filesystem.packagesFromDirectoryRecursive {
        inherit (python-final) callPackage;
        directory = ./py-pkgs;
      }
      // {
        zenoh = python-prev.zenoh.overrideAttrs { pname = "eclipse-zenoh"; };
      }
    )
  ];
}
// prev.lib.filesystem.packagesFromDirectoryRecursive {
  inherit (final) callPackage;
  directory = ./pkgs;
}
