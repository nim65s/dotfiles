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
  mopidyPackages = prev.mopidyPackages // {
    mopidy-notify = prev.mopidyPackages.mopidy-notify.overrideAttrs {
      patches = final.lib.fileset.toList ./patches/phijor/mopidy-notify;
    };
  };
  nurl = prev.nurl.overrideAttrs {
    patches = [
      ./patches/nix-community/nurl/388_feat-use-a-github-token-for-authorization-if-it-exists.patch
    ];
  };
  rofi-rbw = prev.rofi-rbw.overrideAttrs {
    patches = [
      ./patches/fdw/rofi-rbw/124_fix-typing-passwords-starting-with-dashes.patch
    ];
  };
}
// prev.lib.filesystem.packagesFromDirectoryRecursive {
  inherit (final) callPackage;
  directory = ./pkgs;
}
