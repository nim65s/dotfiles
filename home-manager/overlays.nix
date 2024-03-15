self: super:
let
  lib = self.lib;
 sway-unwrapped = super.sway-unwrapped.overrideAttrs (
    previous: {
      src = self.fetchFromGitHub {
        owner = "nim65s";
        repo = "sway";
        rev = "1-9-smart";
        hash = "sha256-NbmjZKuu1c+m294Vzi35EEjBEWaOfp0F0pz7rtKesJU=";
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
