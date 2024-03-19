self: super:
let
  lib = self.lib;
 sway-unwrapped = super.sway-unwrapped.overrideAttrs (
    previous: {
      src = self.fetchFromGitHub {
        owner = "svalaskevicius";
        repo = "sway";
        rev = "hiding-lone-titlebar-scenegraph";
        hash = "sha256-cXBEXWUj3n9txzpzDgl6lsNot1ag1sEE07WAwfCLWHc=";
      };
    }
  );
in
{
  gruppled-white-lite-cursors = self.callPackage ./gruppled-lite-cursors {
    theme = "gruppled_white_lite";
  };
  sauce-code-pro = self.nerdfonts.override { fonts = [ "SourceCodePro" ]; };
  sway = super.sway.override { sway-unwrapped = sway-unwrapped; };
}
