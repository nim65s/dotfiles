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
  kanata = prev.kanata.overrideAttrs {
    patches = final.lib.fileset.toList ./patches/jtroo/kanata;
  };
  # https://github.com/NixOS/nixpkgs/pull/526892
  zulip = prev.zulip.override { electron_39 = final.electron_40; };
}
// prev.lib.filesystem.packagesFromDirectoryRecursive {
  inherit (final) callPackage;
  directory = ./pkgs;
}
