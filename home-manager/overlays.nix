self: super:
let
  lib = self.lib;
 sway-unwrapped = super.sway-unwrapped.overrideAttrs (
    previous: {
      src = self.fetchFromGitHub {
        owner = "nim65s";
        repo = "sway";
        rev = "1-9-smart";
        hash = "sha256-yeXZ9+/qSWh1FYbiHst0PLr6B066kR5I0+evu3kRtwQ=";
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
