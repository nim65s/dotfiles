{
  spicetify-nix,
  ...
}:
final: prev:
{
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
