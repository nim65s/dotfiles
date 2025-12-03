{
  nixpkgs-ros,
  nix-ros-overlay,
  spicetify-nix,
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
  nurl = prev.nurl.overrideAttrs {
    patches = [
      ./patches/nix-community/nurl/388_feat-use-a-github-token-for-authorization-if-it-exists.patch
    ];
  };
  spicetify-extensions = spicetify-nix.legacyPackages.${prev.stdenv.system}.extensions;
}
// prev.lib.filesystem.packagesFromDirectoryRecursive {
  inherit (final) callPackage;
  directory = ./pkgs;
}
