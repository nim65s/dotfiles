self: super:
let
  lib = self.lib;
  sway-unwrapped =
    (super.sway-unwrapped.overrideAttrs (
      finalAttrs: previousAttrs: {
        src = self.fetchFromGitHub {
          owner = "svalaskevicius";
          repo = "sway";
          rev = "hiding-lone-titlebar-scenegraph";
          hash = "sha256-cXBEXWUj3n9txzpzDgl6lsNot1ag1sEE07WAwfCLWHc=";
        };
      }
    )).override
      {
        wlroots = super.wlroots.overrideAttrs {
          version = "0.18.0-dev";
          src = self.fetchFromGitLab {
            domain = "gitlab.freedesktop.org";
            owner = "wlroots";
            repo = "wlroots";
            rev = "48721bca656556606275a5e776066a2f00822e92";
            hash = "sha256-PUx4RZiLbWineoAvZk7kuUBXRFI15vfxLna49LUR8+s=";
          };
          patches = [ ];
        };
      };
in
{
  gruppled-white-lite-cursors = self.callPackage ./gruppled-lite-cursors {
    theme = "gruppled_white_lite";
  };
  sauce-code-pro = self.nerdfonts.override { fonts = [ "SourceCodePro" ]; };
  sway = super.sway.override { sway-unwrapped = sway-unwrapped; };
}
