{
  spicetify-nix,
  ...
}:
final: prev:
{
  arsenik = prev.arsenik.overrideAttrs {
    patches = [ ./patches/OneDeadKey/arsenik/77_kanata-numpad-add-operators.patch ];
  };
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
