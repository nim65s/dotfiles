self: super:
let
  lib = self.lib;
in {
  gruppled-white-lite-cursors = self.callPackage ./gruppled-lite-cursors {
    theme = "gruppled_white_lite";
  };
  sauce-code-pro = self.nerdfonts.override {
    fonts = [ "SourceCodePro" ];
  };
  sway = super.sway.override {
    sway-unwrapped = (super.sway-unwrapped.overrideAttrs (finalAttrs: previousAttrs: {
      patches = lib.lists.take 2 previousAttrs.patches ++ lib.lists.drop 3 previousAttrs.patches;
      src = self.fetchFromGitHub {
        owner = "nim65s";
        repo = "sway";
        rev = "fa4c1cdc50b1cf28acac4e599b750a65e788602e";
        hash = "sha256-NbmjZKuu1c+m293Vzi35EEjBEWaOfp0F0pz7rtKesJU=";
      };
    })).override {
      wlroots_0_16 = super.wlroots.overrideAttrs {
        version = "0.18.0-dev";
        src = self.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "wlroots";
          repo = "wlroots";
          rev = "48721bca656556606275a5e776066a2f00822e92";
          hash = "sha256-PUx4RZiLbWineoAvZk7kuUBXRFI15vfxLna49LUR8+s=";
        };
        patches = [];
      };
    };
  };
}
