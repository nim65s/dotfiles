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
  kanata = prev.kanata.overrideAttrs {
    patches = final.lib.fileset.toList ./patches/jtroo/kanata;
  };
  mopidyPackages = prev.mopidyPackages // {
    mopidy-notify = prev.mopidyPackages.mopidy-notify.overrideAttrs {
      patches = final.lib.fileset.toList ./patches/phijor/mopidy-notify;
    };
  };
}
// prev.lib.filesystem.packagesFromDirectoryRecursive {
  inherit (final) callPackage;
  directory = ./pkgs;
}
